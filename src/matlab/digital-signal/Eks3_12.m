clear
clf reset
cla reset
set(0,'DefaultFigureColor','w');
set(0,'DefaultFigurePaperType','A4');

% Example 3.12
% Oversampled, bandlimited pulse
T=1;
m=4;   %Oversampling factor
K=4;   %Length(/T) of time pulse
% Pulse in frequency domain:
Ts=T/m;
N=K*m;
G=[1 1 .5 zeros(1,N-5) .5 1];
f=-N/2*Ts:Ts:(N/2-1)*Ts;
plot(f,fftshift(G),'--')
hold on
stem(f,fftshift(G))
set(gca,'Box','Off');
set(gca,'Xtick',[-2 -3/4 -1/4 0 1/4 3/4 2]);
set(gca,'XtickLabel','-2|-3/4|-1/4|0|1/4|3/4|2');
xlabel('\omegaT/2\pi');
set(gca,'Ytick',[0 1/2]);
text(-2.25,1,'G');
text(-1.25,0.5,'K = 4');
set(gca,'PlotBoxAspectRatio',[1 0.5 1]);
hold off
% Print resultatet i EPS-format
%print -deps2 F_Ex3_12_1.eps
pause
% real is used to remove negliglible imaginary parts
% ifft scaled as in (2.3)
g=fftshift(real(ifft(G)/Ts));
% Completely symmetric pulse:
g=[g(1)/2 g(2:end) g(1)/2];
t=-N/2*Ts:Ts:(N/2)*Ts;
stem(t,g)
set(gca,'Box','Off');
xlabel('t/T');
text(-1.8,0.8,'m = 4, T_S = T/4');
Etime=sum(g.^2)*Ts
Efreq=sum(G.^2)/Ts/N
% Print resultatet i EPS-format
%print -deps2 F_Ex3_11_2.eps
pause
% Sidelobes of the designed filter
% Transfer function of filter with frequency resolution 1/(32T):
g_T=fftshift([zeros(1,56) g zeros(1,55)]);
% fft scaled as in (2.3)
G_T=abs(fft(g_T)*Ts);
semilogy([-2:1/32:63/32],fftshift(G_T));
set(gca,'Box','Off');
set(gca,'Ygrid','on');
set(gca,'YLim',[1e-6 1.1]);
set(gca,'YTick',[1e-6,1e-4,1e-2,1]);
set(gca,'Xtick',[-2 -3/4 -1/4 0 1/4 3/4 2]);
set(gca,'XtickLabel','-2|-3/4|-1/4|0|1/4|3/4|2');
xlabel('\omegaT/2\pi');
title('Spectrum of sampled finite pulse');
% Print resultatet i EPS-format til
%print -deps2 F_Ex3_12_3.eps
pause

figure
% A higher oversampling is obtained by increasing the length of G
mH=8;   %Oversampling factor
NH=K*mH;
Tsh=T/mH;
GH=[1 1 .5 zeros(1,NH-5) .5 1];
gh=fftshift(real(ifft(GH)/Tsh));
% Completely symmetric pulse:
gh=[gh(1)/2 gh(2:end) gh(1)/2];
t=-NH/2*Tsh:Tsh:NH/2*Tsh;
stem(t,gh)
set(gca,'Box','Off');
xlabel('t/T');
text(-1.8,0.8,'m = 8, T_S = T/8');
title('Higher sampling rate');
% Print resultatet i EPS-format
%print -deps2 F_Ex3_12_4.eps
pause
% Transfer function of filter with frequency resolution 1/(32T):
gh_T=fftshift([zeros(1,48) gh zeros(1,47)]);
% fft scaled as in (2.3)
GH_T=abs(fft(gh_T)*Tsh);
semilogy([-4:1/16:127/32],fftshift(GH_T));
set(gca,'Box','Off');
set(gca,'Ygrid','on');
set(gca,'YTick',[1e-10,1e-8,1e-6,1e-4,1e-2,1]);
set(gca,'Xtick',[-2 -3/4 -1/4 0 1/4 3/4 2]);
set(gca,'XtickLabel','-2|-3/4|-1/4|0|1/4|3/4|2');
xlabel('\omegaT/2\pi');
title('Higher sampling rate');
% No improvement since length is unchanged
pause
% A longer part of the pulse implies another frequency step in G
% An improvement in sidelobes should be possible here
KL=8;   %Length(/T) of time pulse
NL=KL*m;
GL=[1 1 1 .75 .5 .25 zeros(1,NL-11) .25 .5 .75 1 1];
gl=fftshift(real(ifft(GL)/Ts));
gl=[gl(1)/2 gl(2:end) gl(1)/2];
t=-NL/2*Ts:Ts:NL/2*Ts;
stem(t,gl)
set(gca,'Box','Off');
xlabel('t/T');
text(-2.25,0.5,'K = 8');
title('Longer pulse');
% Print resultatet i EPS-format
%print -deps2 F_Ex3_12_5.eps
pause
% Transfer function of long filter with frequency resolution 1/(32T):
gl_T=fftshift([zeros(1,48) gl zeros(1,47)]);
% fft scaled as in (2.3)
GL_T=abs(fft(gl_T)*Ts);
semilogy([-2:1/32:63/32],fftshift(GL_T));
set(gca,'Box','Off');
set(gca,'Ygrid','on');
set(gca,'YTick',[1e-10,1e-8,1e-6,1e-4,1e-2,1]);
set(gca,'Xtick',[-2 -3/4 -1/4 0 1/4 3/4 2]);
set(gca,'XtickLabel','-2|-3/4|-1/4|0|1/4|3/4|2');
xlabel('\omegaT/2\pi');
title('Longer pulse');
% Not shown in Lecture notes
% Small improvement seen (best close to +-2 freq)
pause
%
% Transfer function of quantized filter with frequency resolution 1/(32T):
M=1024;  %# steps in uniform quantization of -1 to +1
gq=quant(g,2/M);
g_T=fftshift([zeros(1,56) gq zeros(1,55)]);
% fft scaled as in (2.3)
G_T=abs(fft(g_T)*Ts);
semilogy([-2:1/32:63/32],fftshift(G_T),'r--');
set(gca,'Box','Off');
set(gca,'Ygrid','on');
set(gca,'YLim',[1e-6 1.1]);
set(gca,'YTick',[1e-6,1e-4,1e-2,1]);
set(gca,'Xtick',[-2 -3/4 -1/4 0 1/4 3/4 2]);
set(gca,'XtickLabel','-2|-3/4|-1/4|0|1/4|3/4|2');
xlabel('\omegaT/2\pi');
M=128;  %# steps in uniform quantization of -1 to +1
gq=quant(g,2/M);
g_T=fftshift([zeros(1,56) gq zeros(1,55)]);
% fft scaled as in (2.3)
G_T=abs(fft(g_T)*Ts);
hold on
plot([-2:1/32:63/32],fftshift(G_T),'b');
hold off
legend('10 bits','7 bits');
title('Quantization of coefficients');
% Print resultatet i EPS-format til
%print -deps2 F_Ex3_12_6.eps