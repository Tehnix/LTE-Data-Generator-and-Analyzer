% Øvelse 3
% tid 0.2 sek
step=0.01;          % Tidsopløsning
P=0.2;              % Periode
N=20;               % P/step = Periode målt i antal tidstrin
t=0:step:P-step;
% Periode med længde N
v=[ones(1,6) zeros(1,N-11) ones(1,5)];
stem(t,v)
pause
% 3 perioder er tydeligere
stem([t-P t t+P],[v v v]);
pause
V=real(fft(v)/N);
% Plot for k=0:N-1
stem(0:N-1,V)
% Frekvenstrin k/P = k*5 Hz
pause
% Sammenligning (for de positive frekvenser) med teori
B=0.11;
hold on
% k=0:
F(1)=B/P;
k=1:N/2;
F(k+1)=B/P*sin(pi*k*B/P)./(pi*k*B/P);
% Plot for k=0:N/2
plot(0:N/2,F,'r')
hold off
pause
% Approksimation med fft-koefficienter:
% Frekvens 0
plot(t,v);
hold on
f=0;
a=V(1)*cos(2*pi*f*t);
plot(t,a,'r')
text(0.08,0.5,'0 Hz, k=0');
hold off
pause
% Frekvens 5 Hz
plot(t,v);
hold on
f=5;
%a=a+2*V(2)*cos(2*pi*f*t); % eller mere explicit:
a=a+V(2)*cos(2*pi*f*t)+V(20)*cos(2*pi*(-f)*t);
plot(t,a,'r')
text(0.08,0.5,'5 Hz, k=+-1');
hold off
pause
% Frekvens 10 Hz
plot(t,v);
hold on
f=10;
a=a+V(3)*cos(2*pi*f*t)+V(19)*cos(2*pi*(-f)*t);
plot(t,a,'r')
text(0.08,0.5,'10 Hz, k=+-2');
hold off
pause
% Frekvens 15 Hz
plot(t,v);
hold on
f=15;
a=a+V(4)*cos(2*pi*f*t)+V(18)*cos(2*pi*(-f)*t);
plot(t,a,'r')
text(0.08,0.5,'15 Hz, k=+-3');
hold off
pause
% Frekvens 20 Hz
plot(t,v);
hold on
f=20;
a=a+V(5)*cos(2*pi*f*t)+V(17)*cos(2*pi*(-f)*t);
plot(t,a,'r')
text(0.08,0.5,'20 Hz, k=+-4');
hold off
pause
% Frekvens 25 Hz
plot(t,v);
hold on
f=25;
a=a+V(6)*cos(2*pi*f*t)+V(16)*cos(2*pi*(-f)*t);
plot(t,a,'r')
text(0.08,0.5,'25 Hz, k=+-5');
hold off
pause
% Frekvens 30 Hz
plot(t,v);
hold on
f=30;
a=a+V(7)*cos(2*pi*f*t)+V(15)*cos(2*pi*(-f)*t);
plot(t,a,'r')
text(0.08,0.5,'30 Hz, k=+-6');
hold off
pause
% Frekvens 35 Hz
plot(t,v);
hold on
f=35;
a=a+V(8)*cos(2*pi*f*t)+V(14)*cos(2*pi*(-f)*t);
plot(t,a,'r')
text(0.08,0.5,'35 Hz, k=+-7');
hold off
pause
% Frekvens 40 Hz
plot(t,v);
hold on
f=40;
a=a+V(9)*cos(2*pi*f*t)+V(13)*cos(2*pi*(-f)*t);
plot(t,a,'r')
text(0.08,0.5,'40 Hz, k=+-8');
hold off
pause
% Frekvens 45 Hz
plot(t,v);
hold on
f=45;
a=a+V(10)*cos(2*pi*f*t)+V(12)*cos(2*pi*(-f)*t);
plot(t,a,'r')
text(0.08,0.5,'45 Hz, k=+-9');
hold off
pause
% Frekvens 50 Hz
plot(t,v);
hold on
f=50;
a=a+V(11)*cos(2*pi*f*t);    % Bemærk kun et bidrag (fælles for +50 og -50)
plot(t,a,'r');
text(0.08,0.5,'50 Hz, k=10 !!!!');
text(0.02,0.6,'Fourierkoefficienter fra fft med længde 20');
hold off
pause
% Anvendes de teoretiske værdier i approximationen fås en lille differens:
% Frekvens 0
plot(t,v);
hold on
f=0;
a=F(1)*cos(2*pi*f*t);
plot(t,a,'r')
hold off
pause
for k=2:10
    % Frekvens (k-1)*5 Hz
    plot(t,v);
    hold on
    f=(k-1)*5;
    a=a+2*F(k)*cos(2*pi*f*t);
    plot(t,a,'r')
    text(0.08,0.5,[num2str(f) ' Hz, k=+-' num2str(k)]);
    hold off 
    pause
end
% Frekvens 50 Hz
plot(t,v);
hold on
f=50;
a=a+2*F(11)*cos(2*pi*f*t);    % Bemærk her to bidrag
plot(t,a,'r');
text(0.08,0.5,'50 Hz, k=+-10 !!!!');
text(0.02,0.6,'Teoretiske Fourierkoefficienter');
hold off
