% Sampling
% Figur med harmonisk funktion for forelæsning
set(0,'DefaultFigureColor','w');
set(0,'DefaultFigurePaperType','A4');
clf reset
cla reset
clear

% tid 2 sek
t=-0.75:0.01:1.24;
% cos med frekvens f
f=4;
phi=3*pi/2;
A=0.5;
v=A*cos(2*pi*f*t+phi);
plot(t,v)
set(gca,'YLim',[-1 1]);
set(gca,'YTick',[-0.5 0 0.5]);
set(gca,'YTickLabel','-A|0|A');
line([-0.8 1.3],[0 0]);
line([0 0],[-1 1]);
xlabel('Tid i sek.')
l=title('Harmonisk funktion');
set(l,'Fontsize',12);
set(l,'Color','b');
l=text(-0.75,0.75,'Acos(2{\pi}ft + {\phi})');
set(l,'Fontsize',12);
set(l,'Color','b');
%
pause
startp=-0.65;
slutp=startp+1/f;
yp=A*cos(2*pi*f*startp+phi);
handle=line([startp slutp],[yp yp]);
set(handle,'LineWidth',[2])
set(handle,'Color','r')
handle=line([startp startp],[yp-0.05 yp+0.05]);
set(handle,'LineWidth',[2])
set(handle,'Color','r')
handle=line([slutp slutp],[yp-0.05 yp+0.05]);
set(handle,'LineWidth',[2])
set(handle,'Color','r')
text(startp+0.05,yp+0.05,'1/f');
handle=text(0.1,0.9,'Frekvens f');
set(handle,'Color','r')
handle=text(0.1,0.8,'Periode 1/f');
set(handle,'Color','r')
%
pause
xA=0.3125;
handle=line([xA xA],[0 A]);
set(handle,'LineWidth',[2])
set(handle,'Color','r')
handle=line([xA-0.05 xA+0.05],[A A]);
set(handle,'LineWidth',[2])
set(handle,'Color','r')
text(xA+0.01,0.25,'A');
handle=text(0.1,0.7,'Amplitude A');
set(handle,'Color','r')
%
pause
startp=-0.1875;
slutp=0;
yp=0.05;
handle=line([startp slutp],[yp yp]);
set(handle,'LineWidth',[2])
set(handle,'Color','r')
handle=line([startp startp],[yp-0.05 yp+0.05]);
set(handle,'LineWidth',[2])
set(handle,'Color','r')
handle=line([slutp slutp],[yp-0.05 yp+0.05]);
set(handle,'LineWidth',[2])
set(handle,'Color','r')
handle=line([startp startp],[0 0.6]);
set(handle,'LineStyle','--')
text(startp+0.02,yp+0.05,'{\phi}/2{\pi}f');
handle=text(0.1,0.6,'Faseforskydning {\phi}');
set(handle,'Color','r')
pause
%
l=text(-0.75,0.6,'Acos({\omega}t + {\phi})');
set(l,'Fontsize',12);
set(l,'Color','b');
handle=text(0.74,0.9,'Vinkelfrekvens {\omega} = 2{\pi}f');
set(handle,'Color','r')
handle=text(0.74,0.6,' i tid: {\phi}/{\omega}');
set(handle,'Color','r')
pause
% Sampling
% tid 2 sek
step=0.01;
t=0:step:2-step;
% cos med frekvens f
f=3;
v=cos(2*pi*f*t);
plot(t,v);
l=text(0.1,0.7,'3 Hz');
set(l,'Fontsize',12);
set(l,'Color','r');
xlabel('Tid i sek.')
pause
% Samplingstid målt i steps
m=14;
Ts=m*step;
sampling_frequency=1/Ts
sampledv=zeros(1,length(v));
sampledv=v(1:m:length(v));
plot(t,v)
hold on
l=stem(t(1:m:length(v)),sampledv);
set(l,'Color','r')
hold off
pause
% Interpolationsfunktion
ti=-10*Ts:step:10*Ts;
interp=sin(pi*ti/Ts)./(pi*ti/Ts);
interp(10*m+1)=1;    % Division by 0
plot(ti,interp)
hold on
set(gca,'Xtick',-10*Ts:Ts:10*Ts);
set(gca,'XtickLabel','-10|-9|-8|-7|-6|-5|-4|-3|-2|-1|0|1|2|3|4|5|6|7|8|9|10');
set(gca,'XGrid','On');
xlabel('t/T_S');
l=text(0,1,'*v(kT_S)');
set(l,'Color','b')
pause
plot(ti(1:end-m)+Ts,0.8*interp(1:end-m),'g')
l=text(Ts,0.8,'*v((k+1)T_S)');
set(l,'Color','g')
pause
plot(ti(1:end-2*m)+2*Ts,0.2*interp(1:end-2*m),'r')
l=text(2*Ts,0.2,'*v((k+2)T_S)');
set(l,'Color','r')
hold off
pause
% Cosine reconstruction
vrek=zeros(1,length(interp)+m*length(sampledv));
for i=1:length(sampledv)
    vrek(1+(i-1)*m:length(interp)+(i-1)*m)=...
        vrek(1+(i-1)*m:length(interp)+(i-1)*m)+sampledv(i)*interp;
    plot(vrek);
    set(gca,'Ylim',[-1.2 1.2]);
    title('Gradvis opbygning af 3 Hz cosinus samplet med 7,14 Hz')
    hold on
    for j=1:i
        l=stem(ceil(length(interp)/2)+(j-1)*m,sampledv(j),'rx');
        %set(l,'LineWidth',[2]);
    end
    hold off
    pause
end