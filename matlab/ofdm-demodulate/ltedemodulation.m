
waveform = [];
info = struct();
info.Nfft = 128;                     % Nfft                    - FFT size
info.SamplingRate = 30720000 / 2048 * info.Nfft;         % SamplingRate            - The sampling rate of the time domain WAVEFORM, given by SamplingRate = 30.72MHz / 2048 * Nfft.
info.CyclicPrefixLengths = [10 9 9 9 9 9 9 10 9 9 9 9 9 9];  % CyclicPrefixLengths - Cyclic prefix length (in samples) of each OFDM symbol in a subframe.

%      NRB     Nfft     Windowing     CyclicPrefixLengths (Normal)
%        6      128             4     [10 9 9 9 9 9 9 10 9 9 9 9 9 9]
%       15      256             6     [20 18 18 18 18 18 18 20 18 18 18 18 18 18]
%       25      512             4     [40 36 36 36 36 36 36 40 36 36 36 36 36 36]
%       50     1024             6     [80 72 72 72 72 72 72 80 72 72 72 72 72 72]
%       75     2048             8     [160 144 144 144 144 144 144 160 144 144 144 144 144 144]
%      100     2048             8     [160 144 144 144 144 144 144 160 144 144 144 144 144 144]
%
% Note:   As shown in table above, for info.Nfft < 2048,
% info.CyclicPrefixLengths are the CyclicPrefixLengths for info.Nfft = 2048 scaled by info.Nfft / 2048.
%
% Ref: http://se.mathworks.com/help/lte/ref/lteofdmmodulate.html

enb = struct();
enb.NDLRB = 6;                       % NDLRB                   - Number of downlink resource blocks (Downlink bandwidth configuration) 
enb.CellRefP = 1;                    % CellRefP                - Number of transmit antenna Ports

cpFraction = 0.55;                  %cpFraction               - cpFraction is between 0 and 1, with 0 representing the start of the cyclic prefix and 1 representing the end of the cyclic prefix. The default value is 0.55, which allows for the default level of windowing

% Compute the number of samples per subframe and FFT size from
% the cell wide settings.
samplesPerSubframe=info.SamplingRate*0.001;
nFFT=double(info.Nfft);

% Get the cyclic prefix lengths for one slot for the cyclic prefix
% type specified in ENB.
cpLengths=double(info.CyclicPrefixLengths); 
cpLengths=cpLengths(1:length(cpLengths)/2);

% Calculate the number of symbols in a slot from the cyclic prefix
% lengths, and the number of whole subframes in WAVEFORM.
nSymbols=length(cpLengths);    
nSubframes=fix(size(waveform,1)/samplesPerSubframe);        

% Calculate position of the first active subcarrier in the FFT output,
% and the total number of active subcarriers, according to the FFT
% size and number of resource blocks. 
firstActiveSC=(nFFT/2)-(enb.NDLRB*6)+1;
totalActiveSC=enb.NDLRB*12;

% Create an empty output GRID of the correct size.    
%   The vector D is [N M CellRefP] where N is the number of subcarriers
%   (12*NDLRB), M is the number of OFDM symbols in a subframe (14 for
%   normal cyclic prefix and 12 for extended cyclic prefix) and CellRefP is
%   the number of transmit antenna ports.
D=[totalActiveSC 14 enb.CellRefP];
D(2)=D(2)*nSubframes;    
reGrid=zeros(D);    
idx=0:nFFT-1;   

% For each subframe in WAVEFORM, each slot in a subframe and each
% symbol in a slot:  
i=1;    
offset=0;
for subframe=0:nSubframes-1 
    for slot=0:1
        for symbol=0:nSymbols-1                

            % Get cyclic prefix length in samples for the current symbol.
            cpLength=cpLengths(symbol+1);

            % Position the FFT part of the way through the cyclic
            % prefix; the value of cpFraction should ensure that the 
            % reception is unaffected by the windowing applied in the 
            % lteOFDMModulate function. Default is 55%.                
            fftStart=fix(cpLength*cpFraction);

            % Create vector of phase corrections, one per FFT sample,
            % to compensate for FFT performed away from zero phase
            % point on the original subcarriers.
            phaseCorrection=repmat(exp(-1i*2*pi*(cpLength-fftStart)/nFFT*idx)',1,size(waveform,2));

            % Extract the appropriate section of WAVEFORM, perform the
            % FFT and apply the phase correction.
            fftOutput=fftshift(fft(waveform(offset+fftStart+(1:nFFT),:)).*phaseCorrection,1);

            % Extract the active subcarriers for each antenna from the 
            % FFT output, removing the DC subcarrier (which is unused). 
            activeSCs=fftOutput(firstActiveSC:firstActiveSC+totalActiveSC,:);
            activeSCs(totalActiveSC/2+1,:)=[];

            %OFDMSymbolIndices Generates indices for a given OFDM symbol of a resource array.
            %   IND = OFDMSymbolIndices(GRID,SYMBOL) gives the indices for OFDM symbol number
            %   SYMBOL of the resource array GRID, in per-antenna linear indices form. 
            nSCs = size(reGrid,1);
            nAnts = size(reGrid,3);
            firstSCs = sub2ind(size(reGrid),ones(1,nAnts),repmat(i,1,nAnts),1:nAnts);
            ind = repmat(firstSCs,nSCs,1)+repmat((0:nSCs-1).',1,nAnts);
            
            % Assign the active subcarriers into the appropriate column
            % of the received GRID, for each antenna.            
            reGrid(ind)=activeSCs;

            % update counter of overall symbol number and position in
            % the input WAVEFORM.
            i=i+1;
            offset=offset+nFFT+cpLength;
        end
    end
end    

