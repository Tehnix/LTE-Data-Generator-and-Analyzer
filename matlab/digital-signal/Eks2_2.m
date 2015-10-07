% General figure initializations
clear all
set(0,'DefaultFigureColor','w');
set(0,'DefaultFigurePaperType','A4');
clf reset;
cla reset;
% Example 2.2 Complex exponentials
% Extended for demonstration
N=20;
k=0:N;
T=1;
omega=2*pi*4/N/T;
f=exp(j*omega*k*T);
stem (k,real(f),'--o')
hold on
stem (k,imag(f),'--*r')
l=plot(1.7,0.8,'o');
set(l,'Color','b');
l=text(2.0,0.8,'Real part');
set(l,'Color','b');
l=plot(1.7,0.7,'*');
set(l,'Color','r');
l=text(2.0,0.7,'Imaginary part');
set(l,'Color','r');
xlabel('k')
hold off
% Print resultatet i EPS-format
%print -deps2 FigEx2_2.eps
pause
% 3-dimensional plot
plot3 (k,zeros(1,N+1),zeros(1,N+1),'k');
hold on
plot3 (k,real(f),zeros(1,N+1));
fill3([0 k(1:2) 1.25],[0 real(f(1:2)) 0],[0 0 0 0],'b')
fill3([1.25 k(3:4) 3.75],[0 real(f(3:4)) 0],[0 0 0 0],'b')
plot3 (k,zeros(1,N+1),imag(f),'r');
fill3([0 k(1:3) 2.5],[0 0 0 0 0],[0 imag(f(1:3)) 0],'r')
hold off
xlabel('k')
l=ylabel('Real part');
set(l,'Color','b');
l=zlabel('Imaginary part');
set(l,'Color','r');
