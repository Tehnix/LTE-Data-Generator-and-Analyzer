% Figure with bandwidth limited pulse train
%clear all
set(0,'DefaultFigureColor','w');
set(0,'DefaultFigurePaperType','A4');
clf reset
cla reset

t=-4:0.01:4;
pulse=sin(pi*t)./(pi*t);
pulse(401)=1;
m=1/0.01;
data=[1 1 -1 1 -1 -1 1 -1 1 1];
x=[data(1:10);zeros(m-1,10)];
x=reshape(x,1,10*m);
y=conv(x,pulse);
t=0:0.01:9.99;
plot(t,y(401:1400));
set(gca,'YLim',[-2.5 2.5]);
set(gca,'Ytick',[-1:1:1]);
xlabel('Tid')
l=text(0.25,-1.5,'Analogt signal');
set(l,'Color','b');
pause
hold on
ts=0:0.25:9.99;
stem(ts,y(401:25:1400),'r');
l=text(1,1.5,'Tidsdiskret signal');
set(l,'Color','r');
set(gca,'Xtick',[0:0.25:9]);
set(gca,'XtickLabel','');
pause
q=y(401:25:1400);
q=round(2*q)/2;
stem(ts,q,'g')
l=text(2,2,'Digitalt signal: Kvantiseret tidsdiskret signal');
set(l,'Color','g');
hold off

