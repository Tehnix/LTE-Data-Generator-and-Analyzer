% Forslag til Løsning af Øvelse 7
% Forslager er gjort lidt mere raffineret end det
% kan forventes af de studerende.
% Først og fremmest er der rigtige tider, frekvenser og dimensioner
clear;
close all;
set(0,'DefaultFigureColor','w');
set(0,'DefaultFigurePaperType','A4');
clf reset;
cla reset;

% Frekvensområde for PAM signal
T=1;    % Længde af symbol
m=8;    % Antal samplinger af puls, "oversamplingsfaktor"
Ts=T/m; % Samplingstider for puls
L=1000;
a=sign(randn(1,L));
a0=reshape([a; zeros(m-1,L)],1,L*m);
firk=ones(1,m);
v=conv(firk,a0);
% Afsnit 4.4 giver Fouriertransformation for samplet signal
% Frekvensområdet for Fouriertransformationen er altid
% +- 1/(2Ts) og her får vi (givet 1/T = 1 baud)
VF=Ts*fft(v);
N=length(VF);
% Frekvensområdet deles i N stykker
f=[-N/2:N/2-1]/(N*Ts);
plot(f,fftshift(abs(VF)))
title('Spektrum for signal med firkantpuls')
xlabel('Frekvens i Hz givet 1 Baud')
pause
% CosRoll off puls:
K=4;
alpha=0.5;
ti=-K*T:Ts:K*T;
puls=sin(pi*ti/T)./(pi*ti/T).*cos(alpha*pi*ti/T)...
     ./(1-4*alpha^2*ti.^2/T^2);
puls(K*m-m+1)=0;   % Division by 0
puls(K*m+1)=1;     % Division by 0
puls(K*m+m+1)=0;   % Division by 0
stem(ti,puls)
title('Cosinus roll-off puls')
xlabel('Tid i sekunder givet 1 Baud')
pause
slength=100;
v=conv(puls,a0);
stem(v(1:slength))
set(gca,'XTick',K*m+1:m:slength);
set(gca,'XGrid','On');
hold on
line([0 slength],[1 1]);
line([0 slength],[-1 -1]);
hold off
title('Signal med Cosinus roll-off puls')
xlabel('"Samplet tid"')
pause
V=Ts*fft(v);
N=length(V);
% Frekvensområdet deles i N stykker
f=[-N/2:N/2-1]/(N*Ts);
plot(f,fftshift(abs(V)))
title('Spektrum for signal med Cosinus roll-off puls')
xlabel('Frekvens i Hz givet 1 Baud')
pause
% Lavpas
B=input('Båndbredde for lavpasfilter i Hz: ');  % Hz
Bf=ceil(B*(N*Ts));
% Filtrer signalet ved at nulstille alle frekvenser uden for +- B
VLP=[V(1:Bf+1) zeros(1,N-2*Bf-1) V(end-Bf+1:end)];
plot(f,fftshift(abs(VLP)))
pause
% Output fra LP-filter findes ved invers Fouriertransformation
vlp=ifft(VLP)/Ts;
% Sample signalet i "symbolpunkter"
s=vlp(K*m+1:m:end-K*m);
stem(s)
title('Modtagne symboler i lavpasfiltreret signal');
pause
 for i=1:length(s)
     plot(s(i),'o');
     hold on;
 end
hold off
title('Modtagne symboler i lavpasfiltreret signal')
pause
eyediagram(vlp(K*m+1:end-K*m),m,m)
pause
% Lavpas for firkantsignal
Bf=ceil(B*(length(VF)*Ts));
VLP=[VF(1:Bf+1) zeros(1,length(VF)-2*Bf-1) VF(end-Bf+1:end)];
vlp=ifft(VLP)/Ts;
% Sample signalet i midtpunktet af firkantpulser "symbolpunkter"
s=vlp(5:8:end-7);
for i=1:length(s)
    plot(s(i),'o');
    hold on;
end
hold off
title('Modtagne symboler i lavpasfiltreret signal med firkant');
pause
eyediagram(vlp,m,m,m/2)
