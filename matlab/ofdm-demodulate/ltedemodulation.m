clear;
cfg = lteTestModel('1.1','5MHz');
waveform = lteTestModelTool(cfg);
rxGrid = lteOFDMDemodulate(cfg,waveform);

% This function generate subframe for given test model subframe
% configuration TMCONFIG and PDSCH transmission configuration CONFIG.
% TMCONFIG must be a structure including the fields:
                     
info = struct()
info.SamplingRate = 7680000         % SamplingRate            - Sampling rate
info.Nfft = 512                     % Nfft                    - FFT size
info.Windowing = 0                  % Windowing               - The number of time-domain samples over which windowing and overlapping of OFDM symbols is applied
info.CyclicPrefixLengths = [40	36	36	36	36	36	36	40	36	36	36	36	36	36]

enb = struct()
enb.TMN = '1.1'                     % testModelNo             - Test Model number (TS 36.141) is one of the following: ('1.1','1.2','2','3.1','3.2','3.3')
enb.BW = '5MHz'                     % BW                      - Channel bandwidth
enb.NDLRB = 25                      % NDLRB                   - Number of downlink resource blocks (Downlink bandwidth configuration) 
enb.CellRefP = 1                    % CellRefP                - Number of transmit antenna Ports
enb.NCellID = 1                     % NCellID                 - Physical layer cell identity
enb.CyclicPrefix = 'Normal'         % CyclicPrefix            - Cyclic prefix length
enb.CFI = 1                         % CFI                     - Control Format Indicator value
enb.Ng = 'Sixth'                    % Ng                      - PHICH groups (HICH group multiplier ('Sixth','Half','One','Two'))
enb.PHICHDuration = 'Normal'        % PHICHDuration           - PHICH duration
enb.NSubframe = 0                   % NSubframe               - Subframe number
enb.TotSubframes = 10               % TotSubframes            - Total number of subframes to be generated
enb.Windowing = 0                   % Windowing               - The number of time-domain samples over which windowing and overlapping of OFDM symbols is applied
enb.DuplexMode = 'FDD'              % DuplexMode              - Duplexing mode: 'FDD' or 'TDD'

enb.PDSCH = struct();
enb.PDSCH.TxScheme = 'Port0';       % TxScheme                - Transmission scheme, will be one of: 'Port0' - Single-antenna port, Port 0
enb.PDSCH.Modulation = ('QPSK');    % Modulation              - A cell array of one or two strings specifying the modulation formats for boosted and deboosted PRBs: ('QPSK','16QAM','64QAM')
enb.PDSCH.NLayers = 1;              % NLayers                 - Number of transmission layers

enb.CellRSPower = 0                 % CellRSPower             - Cell-specific reference symbol power adjustment in dB
enb.PSSPower = 0                    % SSSPower                - SSS symbol power adjustment in dB
enb.SSSPower = 0                    % SSSPower                - SSS symbol power adjustment in dB
enb.PBCHPower = 0                   % PDSCH                   - PDSCH transmission configuration structure
enb.PCFICHPower = 0                 % PCFICHPower             - PCFICH symbol power adjustment in dB
enb.NAllocatedPDCCHREG = 36         % NAllocatedPDCCHREG      - Number of allocated PDCCH REGs as per Test Model number and BW
enb.PDCCHPower = 1.8800             % PDCCHPower              - PDCCH symbol power adjustment in dB
enb.PDSCHPowerBoosted = 0           % PDSCHPowerBoosted       - PDSCH symbol power adjustment in dB for the Boosted PRBs
enb.PDSCHPowerDeboosted = 0         % PDSCHPowerDeboosted     - PDSCH symbol power adjustment in dB for the deboosted PRBs

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
D=[totalActiveSC 14 enb.CellRefP]
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
            symbol = i;
            nSCs = size(reGrid,1);
            nAnts = size(reGrid,3);
            firstSCs = sub2ind(size(reGrid),ones(1,nAnts),repmat(symbol,1,nAnts),1:nAnts);
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

