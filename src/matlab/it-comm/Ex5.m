% Øvelse 5
% Initializations for white background
clear
set(0,'DefaultFigureColor','w');
set(0,'DefaultFigurePaperType','A4');
% Overføringsfunktion
R=10;
C=10^-3;
f=0.1:0.01:100;
H=1./(1+j*2*pi*f*R*C);
plot(f,abs(H));
title('Overføringsfunktion for tidskontinuert system')
xlabel('Frekvens i Hz')
pause
semilogx(f,abs(H));
title('Overføringsfunktion for tidskontinuert system')
xlabel('Frekvens i Hz')
pause
loglog(f,abs(H));
title('Overføringsfunktion for tidskontinuert system')
xlabel('Frekvens i Hz')
pause
% Spm 2: Tidsdiskret system
Ts=0.01;
h0=1;h1=3/4;h2=-1/4;
f=0.1:0.01:200;
H=h0+h1*exp(-j*2*pi*f*Ts)+h2*exp(-j*2*pi*2*f*Ts);
plot(f,abs(H));
%semilogx(f,abs(H));
% Built-in function to give H
% H=freqz([h0 h1 h2],[1],f,1/Ts);
% plot(f,abs(H),'r');
title('Overføringsfunktion for tidsdiskret system')
xlabel('Frekvens i Hz')
pause
% tid 0.3 sek
t=0:Ts:0.3-Ts;
% Frekvens 0
fi=0
x=cos(2*pi*fi*t);
y=h0*x(3:end)+h1*x(2:end-1)+h2*x(1:end-2);
plot(t,x,'r')
set(gca,'YLim',[0 2])
hold on
plot(t(3:end),y,'g')
hold off
title('Ind- og udgangssignal (frekvens 0) for tidsdiskret system')
xlabel('Tid i sek')
overfoering=H(1)
pause
% Frekvens 16.67
fi=16.67
x=cos(2*pi*fi*t);
y=h0*x(3:end)+h1*x(2:end-1)+h2*x(1:end-2);
plot(t,x,'r')
hold on
plot(t(3:end),y,'g')
title('Ind- og udgangssignal (frekvens 16.67) for tidsdiskret system')
xlabel('Tid i sek')
pause
% kryds for "toppunkt" af y signal - regnet ud ved overføringsfunktion
index=find(f==16.67);       % 1658
overfoering=H(index);
amplitudeskift=abs(H(index));
faseskiftdeg=angle(H(index))/pi*180;
plot(1/fi-faseskiftdeg/360/fi,amplitudeskift,'gx')
pause
% Spm 4:
% Udregning ved conv
yc=conv([h0 h1 h2],x);
% Haler fjernes i plottet
plot(t(3:end),yc(3:end-2),'k')
hold off
pause
% Spm 5
overfoering
amplitudeskift
faseskiftdeg
% Spm 6: Energispektre:
% Vi vælger et interval af længde 100Ts = 0.1 sekund
% og et signal klart inden for dette
N=100;
g=[.1 .2 -.3 .4 -.3 .2 .1];  % Symmetrisk, men ligegyldigt for energispektrum
extg=[g zeros(1,N-length(g))];
% (4.4) i MATLAB
G=Ts*fft(extg);
% Hvad er frekvenserne?
f=0:1/N/Ts:(N-1)/N/Ts;
% Energispektrum for puls
plot(f,abs(G).^2)
title('Energispektrum for indgangssignal for tidsdiskret system')
xlabel('Hz')
pause
H=fft([h0 h1 h2], N);
yc=conv([h0 h1 h2],g);
% (4.4) i MATLAB
YC=Ts*fft(yc,N);
hold on
plot(f,abs(YC).^2,'g')
title('Energispektrum for ind- og udgangssignal for tidsdiskret system')
pause
plot(f,abs(G).^2.*abs(H).^2,'r')
hold off

