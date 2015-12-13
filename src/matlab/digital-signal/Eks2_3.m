% General figure initializations
clear all
set(0,'DefaultFigureColor','w');
set(0,'DefaultFigurePaperType','A4');
clf reset;
cla reset;
% Example 2.3 DFT transform of sampled square wave
f=[1 1 1 0 0 0 1 1];
stem(0:23,[f f f]);
set(gca,'Box','Off');
set(gca,'YLim',[0 2]);
set(gca,'Ytick',[0 1]);
set(gca,'Xtick',[0 8 16 24])
pause
N=length(f);
F=fft(f)/N      % Equation (2.2)
stem(-4:3,fftshift(F))
axis([-4 4 -0.25 0.8]);
% Print resultatet i EPS-format
%print -deps2 FigEx2_4.eps
fback=ifft(F)*N  % Equation (2.2)
pause
% Shift of F - wrong placement of frequency 0
Fs=fftshift(F);
fbacks=ifft(Fs)*N
% multiplied by exp(-j*pi*k)