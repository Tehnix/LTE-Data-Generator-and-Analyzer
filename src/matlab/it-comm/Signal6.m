% Fouriertransformationer
set(0,'DefaultFigureColor','w');
set(0,'DefaultFigurePaperType','A4');
clf reset
cla reset
clear
% Spektrum for tidskontinuert puls til sammenligning
% 200 samples med puls centreret og placeret som lige funktion
% (Figur 4.2)
puls=[ones(1,11) zeros(1,200-11-10) ones(1,10)];
% B = 0,2 sek (ca.)
Ts=0.01;
t=-1.0:Ts:1-Ts;
subplot(1,2,1,'v6');
subplot('Position',[0.05 0.1 0.4 0.3]);
plot(t,fftshift(puls))
set(gca,'XLim',[-0.5 0.5]);
set(gca,'XTick',[  -0.11 0 0.11]);
set(gca,'XTickLabel','-B/2||B/2');
set(gca,'YLim',[0 2]);
set(gca,'YTick',[0 1]);
set(gca,'Box','Off');
xlabel('Tid t')
title('Tidskontinuert puls');
subplot(1,2,2,'v6');
subplot('Position',[0.5 0.1 0.45 0.3]);
B=0.2;
f=-1/(2*Ts):1/(200*Ts):1/(2*Ts);
f=f(1:end-1);
V=B*sin(pi*f*B)./(pi*f*B);
V(101)=B;
plot(V)
set(gca,'XTick',[91 101 111]);
set(gca,'XTickLabel','-1/B||1/B');
set(gca,'YTick',[0]);
set(gca,'Box','Off');
xlabel('Frekvens f')
title('Spektrum for tidskontinuert puls');
pause
hold on
% Tilnærmelse til fft
V=fftshift(real(Ts*fft(puls)));
stem(V,'g')
l=text(30,0.19,'Tilnærmelse');
set(l,'Color','g')
hold off
pause

% Spektrum for tidsdiskret system
% (Figur 4.3)
% Samplingfrekvens 100 Hz
Ts=0.01;
% periode 20 med puls centreret
t=-0.1:Ts:0.09;
p=[zeros(1,8) ones(1,5) zeros(1,7)];
subplot(1,2,1,'v6');
subplot('Position',[0.05 0.1 0.4 0.3]);
stem(t,p)
set(gca,'XLim',[-0.1 0.1]);
set(gca,'XTick',[-2*Ts 0 2*Ts]);
set(gca,'XTickLabel','-2||2');
set(gca,'YLim',[0 2]);
set(gca,'YTick',[0 1]);
xlabel('t/T_S')
text(-0.05,1.5,'Samplet med 100 Hz');
subplot(1,2,2,'v6');
subplot('Position',[0.5 0.1 0.45 0.3]);
f=-3*1/(2*Ts):3*1/(2*Ts);
% Periodisk spektrum fra eksempel
P=Ts*(1+2*cos(2*pi*f*Ts)+2*cos(2*pi*2*f*Ts));
plot(f,P)
set(gca,'XTick',[-1/(2*Ts) 0 1/(2*Ts)]);
set(gca,'XTickLabel','-1/2||1/2');
set(gca,'YTick',[0]);
xlabel('fT_S')
title('3 perioder af spektrum');
pause
% Samplingfrekvens 1000 Hz
Ts=Ts/10;
t=-0.1:Ts:0.099;
% periode 200 med puls centreret
p=[zeros(1,75) ones(1,51) zeros(1,74)];
subplot(1,2,1,'v6');
subplot('Position',[0.05 0.1 0.4 0.3]);
stem(t,p)
set(gca,'XLim',[-0.1 0.1]);
set(gca,'XTick',[-25*Ts 0 25*Ts]);
set(gca,'XTickLabel','-25||25');
set(gca,'YLim',[0 2]);
set(gca,'YTick',[0 1]);
xlabel('t/T_S')
text(-0.05,1.5,'Samplet med 1000 Hz');
subplot(1,2,2,'v6');
subplot('Position',[0.5 0.1 0.45 0.3]);
f=-3*1/(2*Ts):3*1/(2*Ts);
% Periodisk spektrum
% k=0
P=Ts*1;
for k=1:25
    P=P+Ts*2*cos(2*pi*k*f*Ts);
end
plot(f,P)
set(gca,'XTick',[-1/(2*Ts) 0 1/(2*Ts)]);
set(gca,'XTickLabel','-1/2||1/2');
set(gca,'YTick',[0]);
xlabel('fT_S')
title('3 perioder af spektrum');
pause
% Spektrum for tidskontinuert puls til sammenligning
% 200 samples med puls centreret
B=1/20;
subplot(1,2,1,'v6');
subplot('Position',[0.05 0.1 0.4 0.3]);
plot(t,p)
set(gca,'XLim',[-0.1 0.1]);
set(gca,'XTick',[-B/2 0 B/2]);
set(gca,'XTickLabel','-B/2||B/2');
set(gca,'YLim',[0 2]);
set(gca,'YTick',[0 1]);
xlabel('t')
title('Tidskontinuert puls, B = 1/20 sek');
subplot(1,2,2,'v6');
subplot('Position',[0.5 0.1 0.45 0.3]);
V=B*sin(pi*f*B)./(pi*f*B);
V(1501)=B;
plot(f,V)
set(gca,'YTick',[0]);
xlabel('Hz')
title('Spektrum af tidskontinuert puls')
pause
%Energispektrum for lidt mindre område
plot(f(1441:1561),abs(V(1441:1561)).^2)
xlabel('Hz')
set(gca,'YLim',[0 3/1000]);
set(gca,'YTick',[0 3/1000]);
set(gca,'YTickLabel','0|');
title('Energispektrum (frekvenszoom)')
