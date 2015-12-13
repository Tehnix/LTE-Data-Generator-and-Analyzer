% Øvelse 8
% AM
clear all;
f0=1000;
% Afstand mellem samples
Ts=0.001/f0;
% og antal samples i figur (og transformationer siden hen)
N=1000;
t=(0:N-1)*Ts;
x=cos(2*pi*f0*t)-cos(6*pi*f0*t)/3;
% Printing commands
set(0,'DefaultFigureColor','w');
set(0,'DefaultFigurePaperType','A4');
clf reset;
cla reset;
axis([0 10^-3 -1 1]);
l=plot(t,x);
xlabel('t','Position',[1.06*10^-3 -1.15]);
ylabel('Modulationssignal f');
pause
v=x.*sqrt(2).*cos(2*pi*20000*t);
l=plot(t,v);
xlabel('t','Position',[1.06*10^-3 -1.65]);
ylabel('20 kHz moduleret med f');
pause
env=x*sqrt(2);
l=line(t,env);
set(l,'color','k');
set(l,'linestyle','--');
l=line(t,-env);
set(l,'color','k');
set(l,'linestyle','--');
pause
% Brug MATLAB til at give spektre:
% t har N punkter med afstand Ts
% MATLABs fft udregner en periode af spektret 
% fra 0 til frekvensen lige før perioden 1/Ts
% Spektrets frekvenser ligger med afstand 1/(N*Ts)
% PAS PÅ! Periodiske signaler er lumske
% N skal indeholde et helt antal perioder
% Prøv andre N: 1200, 1500(!), 2000
X=real(fft(x)/N);
% Da spektret er periodisk er det mere almindeligt at se
% det startende med -1/(2Ts) op til 1/(2Ts) (- 1/(2NTs))
% For N = 1000 er afstanden 1/(N*Ts) = 1/(1000*0.001/f0) = 1 kHz 
kHz=1000;               %Konverteringsfaktor fra Hz til kHz
stem((-N/2:N/2-1)/(N*Ts)/kHz,fftshift(X))
xlabel('kHz')
title('Modulationssignal')
pause
V=real(fft(v)/N);
stem((-N/2:N/2-1)/(N*Ts)/kHz,fftshift(V))
xlabel('kHz')
title('Moduleret signal')
pause
xd=v.*sqrt(2).*cos(2*pi*20000*t);
Xd=real(fft(xd)/N);
stem((-N/2:N/2-1)/(N*Ts)/kHz,fftshift(Xd))
xlabel('kHz')
title('Demoduleret spektrum uden filter')
pause
% LP filter
XdLP=Xd;
L=25;
XdLP(L:N/2)=0;      % Fjern høje positive frekvenser
XdLP(N/2:N-L+1)=0;  % Fjern høje negative frekvense
stem((-N/2:N/2-1)/(N*Ts)/kHz,fftshift(XdLP))
xlabel('kHz')
title('Demoduleret spektrum med filter')
pause
xdLP=real(N*ifft(XdLP));
l=plot(t,xdLP);
xlabel('t','Position',[1.06*10^-3 -1.15]);
ylabel('Demoduleret signal');