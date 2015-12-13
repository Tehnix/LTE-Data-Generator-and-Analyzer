% DFT Eksempel, side 36
clear
f0=1000;
N=8;
t=0/f0:1/N/f0:1/f0;
t=t(1:end-1);   % Nøjagtigt 1 periode
v=cos(2*pi*f0*t)-1/3*cos(2*pi*3*f0*t);
V=real(fft(v)/N)
Vnaturlig=fftshift(V)
pause
set(0,'DefaultFigureColor','w');
set(0,'DefaultFigurePaperType','A4');
clf reset
cla reset
m=-N/2:N/2-1;
stem(m,Vnaturlig)
set(gca,'Box','Off');
xlabel('m (~ kHz)')
set(gca,'XTick',[-5 -3 -1 0 1 3 5]);
set(gca,'YLim',[-0.3 0.6]);
set(gca,'YTick',[-1/6 1/2]);
set(gca,'YTickLabel','-1/6|1/2');
ylabel('V_m','Rotation',0)
pause
% Flere 
N=16;
t=0/f0:1/N/f0:1/f0;
t=t(1:end-1);   % Nøjagtigt 1 periode
v=cos(2*pi*f0*t)-1/3*cos(2*pi*3*f0*t);
V=real(fft(v)/N)
Vnaturlig=fftshift(V)
pause
m=-N/2:N/2-1;
stem(m,Vnaturlig)
set(gca,'Box','Off');
xlabel('m (~ kHz)')
set(gca,'XTick',[-5 -3 -1 0 1 3 5]);
set(gca,'YLim',[-0.3 0.6]);
set(gca,'YTick',[-1/6 1/2]);
set(gca,'YTickLabel','-1/6|1/2');
ylabel('V_m','Rotation',0)
pause
% Længere tid, to perioder
t=[t t];
N=2*N;
v=cos(2*pi*f0*t)-1/3*cos(2*pi*3*f0*t);
V=real(fft(v)/N)
Vnaturlig=fftshift(V)
pause
m=-N/2:N/2-1;
stem(m,Vnaturlig)
set(gca,'Box','Off');
xlabel('m (~ 0.5 kHz)')
set(gca,'XTick',[-10 -6 -2 0 2 6 10]);
set(gca,'YLim',[-0.3 0.6]);
set(gca,'YTick',[-1/6 1/2]);
set(gca,'YTickLabel','-1/6|1/2');
ylabel('V_m','Rotation',0)



