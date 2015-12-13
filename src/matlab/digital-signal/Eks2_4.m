% General figure initializations
clear all
set(0,'DefaultFigureColor','w');
set(0,'DefaultFigurePaperType','A4');
clf reset;
cla reset;
% Example 2.4 DFT as approximation to transform
N=16;                   % Chosen to get enough information
T=2;                    % Chosen to demonstrate the effect of T
f=[1 2 1 zeros(1,N-3)]; % From Example 2.1
F=T*fft(f);             % Equation (2.3)
FIndex=-N/2:N/2-1;
stem(FIndex,real(fftshift(F)))
hold on
% Analytical expression from Example 2.1
omega=2*pi*FIndex/N/T;
plot(FIndex,real(2*T*(1+cos(omega*T)).*exp(-j*omega*T)))
title('Comparison of real part')
hold off
pause
stem(FIndex,imag(fftshift(F)))
hold on
plot(FIndex,imag(2*T*(1+cos(omega*T)).*exp(-j*omega*T)))
title('Comparison of imaginary part')
hold off
% Inverse transform
f=ifft(F)/T
return
% Correlation and spectrum
pause
R=T*xcorr(f)
Rp=[R(16:end) R(1:15)]
Sf=real(T*fft(Rp));
plot(Sf,'r')
hold on
% Analytical expression from Example 2.1 and (2.16)
Findex=0:length(R)-1;
omega=Findex*2*pi/length(R)/T;
plot(abs(2*T*(1+cos(omega*T)).*exp(-j*omega*T)).^2)
hold off