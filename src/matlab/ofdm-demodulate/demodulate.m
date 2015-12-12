%lteOFDMDemodulate OFDM demodulation
%   GRID = lteOFDMDemodulate(ENB,WAVEFORM) performs OFDM demodulation of
%   the time domain waveform WAVEFORM given cell-wide settings structure
%   ENB which must include the following fields:
%   NDLRB        - Number of downlink resource blocks
%   CyclicPrefix - Optional. Cyclic prefix length 
%                  ('Normal'(default),'Extended')
%
%   The demodulation performs one FFT operation per received OFDM symbol,
%   to recover the received subcarrier values which are then used to
%   construct each column of the output resource array GRID. The FFT is
%   positioned part-way through the cyclic prefix, to allow for a certain
%   degree of channel delay spread whilst avoiding the overlap between
%   adjacent OFDM symbols. The particular position of the FFT chosen here
%   avoids the OFDM symbol overlapping used in the <a href="matlab: help('lteOFDMModulate')">lteOFDMModulate</a>
%   function. Given that the FFT is performed away from the original zero
%   phase point on the transmitted subcarriers, a phase correction is
%   applied to each subcarrier after the FFT. Then, the received
%   subcarriers are extracted from the FFT bins, skipping unused frequency
%   bins at either end of the spectrum and the central DC frequency bin.
%   These extracted subcarriers form the columns of the output GRID.
%
%   Note that the sampling rate of the time domain waveform WAVEFORM must
%   be the same as used in the lteOFDMModulate modulator function for the
%   specified number of resource blocks NDLRB. WAVEFORM must also be
%   time-aligned such that the first sample is the first sample of the
%   cyclic prefix of the first OFDM symbol in a subframe. This alignment
%   can be achieved by using the <a href="matlab:
%   help('lteDLFrameOffset')">lteDLFrameOffset</a> function.
%
%   GRID = lteOFDMDemodulate(ENB,WAVEFORM,CPFRACTION) allows the
%   specification of the position of the demodulation through the cyclic
%   prefix. CPFRACTION is between 0 and 1, with 0 representing the start of
%   the cyclic prefix and 1 representing the end of the cyclic prefix. The
%   default value is 0.55, which allows for the default level of windowing
%   in the <a href="matlab:
%   help('lteOFDMModulate')">lteOFDMModulate</a> function.
%
%   Example: 
%   The modulated waveform for Test Model 1.1 5MHz is demodulated.
%   
%   cfg = lteTestModel('1.1','5MHz');
%   txWaveform = lteTestModelTool(cfg);
%   rxGrid = lteOFDMDemodulate(cfg,txWaveform);
%
%   See also lteOFDMModulate, lteOFDMInfo, lteDLFrameOffset,
%   lteDLChannelEstimate, lteDLPerfectChannelEstimate.

%   Copyright 2009-2014 The MathWorks, Inc.

function reGrid = demodulate(enb,waveform,varargin)

    if (nargin==3)
      cpFraction = varargin{1};
    else
      cpFraction = 0.55;
    end
    
    % Compute the number of samples per subframe and FFT size from
    % the cell wide settings.
    info=lteOFDMInfo(enb);
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
    dims=lteDLResourceGridSize(enb,size(waveform,2));
    dims(2)=dims(2)*nSubframes;    
    reGrid=zeros(dims);    
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
                
                % Assign the active subcarriers into the appropriate column
                % of the received GRID, for each antenna.
                reGrid(OFDMSymbolIndices(reGrid,i))=activeSCs;
                
                % update counter of overall symbol number and position in
                % the input WAVEFORM.
                i=i+1;
                offset=offset+nFFT+cpLength;
            end
        end
    end    
end

%OFDMSymbolIndices Generates indices for a given OFDM symbol of a resource array.
%   IND = OFDMSymbolIndices(GRID,SYMBOL) gives the indices for OFDM symbol number
%   SYMBOL of the resource array GRID, in per-antenna linear indices form. 
function ind = OFDMSymbolIndices(reGrid,symbol)
    nSCs = size(reGrid,1);
    nAnts = size(reGrid,3);
    firstSCs = sub2ind(size(reGrid),ones(1,nAnts),repmat(symbol,1,nAnts),1:nAnts);
    ind = repmat(firstSCs,nSCs,1)+repmat((0:nSCs-1).',1,nAnts);    
end

