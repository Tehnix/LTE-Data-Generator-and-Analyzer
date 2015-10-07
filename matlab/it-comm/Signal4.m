% Kompleks harmonisk funktioner
% Initialiseringer for sort/hvid tegninger
clear
set(0,'DefaultFigureColor','w');
t=-1:0.01:1;
f=3;
y=exp(j*2*pi*f*t);
plot(t,real(y));
hold on
plot(t,imag(y),'r');
l=text(-0.925,0.4,'Realdel: cos 2{\pi}ft');
set(l,'Color','b');
l=text(-0.68,-0.5,'Imaginærdel: sin 2{\pi}ft');
set(l,'Color','r');
title('Kompleks harmonisk funktion')
hold off
pause
compass(y)
title('Kompleks harmonisk funktion, Viserdiagram')
