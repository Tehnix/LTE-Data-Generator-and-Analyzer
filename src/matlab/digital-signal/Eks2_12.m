clear all
% Example 2.12 Pseudo random sequence
r=[1 1 1 1];
for j=1:15
   % Add new row in r with shift register state
   r=[r;xor(r(j,3),r(j,4)) r(j,1:3)];
end   
r
% Output sequence
f=r(2:16,1)'
pause
% Example 2.13 Spectrum
freal=2*f-1
F=fft(freal)/length(freal)
Sf=abs(F).^2
% Correlation method
% Rf=xcorr([freal freal],freal)/length(freal); % Version 5.x
Rf=xcorr(freal,[freal freal])/length(freal); % Version 6.x
Rfper=Rf(length(freal):2*length(freal)-1)
Sf=fft(Rfper)/length(freal)