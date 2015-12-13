% Øvelse 2
% tid 2 sek
step=0.01
t=0:step:2-step;
% cos med frekvens f
f=3;
v=cos(2*pi*f*t);
plot(t,v);
% Samplingstid målt i steps
m=input('Samplingstid målt i antal steps: ');
Ts=m*step;
samplingfrekvens=1/Ts
%vsampled=zeros(1,length(v));
vsampled=0*v;   % Simplere at skrive
% Indsætning af sampleværdier i hvert m'te element:
vsampled(1:m:length(v))=v(1:m:length(v)); 
plot(t,v)
hold on
stem(t,vsampled)
hold off
pause
% Interpolationsfunktion
ti=-4*Ts:step:4*Ts;
interp=sin(pi*ti/Ts)./(pi*ti/Ts);
interp(4*m+1)=1;    % Division by 0
% r er det rekonstruerede signal
r=conv(vsampled,interp);
plot(r)
hold on
plot(v,'r')
hold off