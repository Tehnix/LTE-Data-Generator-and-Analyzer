% Uniform Quantization
% Initialiseringer for sort/hvid tegninger
clear
set(0,'DefaultFigureColor','w');
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
pause
cla
clf
% Basic Figure 4.6
axis([-4.5 4.5 -4.5 4.5]);
axis square
axis off
% Akser
x=[-4.5 4.5];
y=[0 0];
l=line(x,y);
set(l,'color','k');
x=[0 0];
y=[-4.5 4.5];
l=line(x,y);
set(l,'color','k');
% Kvantiseringsniveauer
for j=0:7
    x=[-4+j -3+j];
    y=[-3.5+j -3.5+j];
    l=line(x,y);
    set(l,'color','k');
    set(l,'Linewidth',3)
    x=[-3+j 0];
    y=[-3.5+j -3.5+j];
    l=line(x,y);
    set(l,'color','k');
    set(l,'LineStyle',':')
    x=[-4+j -4+j];
    if (j > 4)|(j==0)
        y=[0 -3.5+j];
    else
        y=[0 -3.5+j-1];
    end
    l=line(x,y);
    set(l,'color','k');
    set(l,'LineStyle',':');
end
j=8;
x=[-4+j -4+j];
y=[0 -3.5+7];
l=line(x,y);
set(l,'color','k');
set(l,'LineStyle',':');
% Tekster
l=text(-4.2,0.7,'-x_{max}');
l=text(-4.1,0.3,'a_0'); 
l=text(0.1,-3.6,'x''_0'); 
l=text(-3.1,0.3,'a_1'); 
l=text(0.1,-2.6,'x''_1'); 
l=text(-2.1,0.3,'a_2'); 
l=text(0.1,-1.6,'x''_2'); 
l=text(-1.1,0.3,'a_3'); 
l=text(0.1,-0.6,'x''_3'); 
l=text(-0.18,0.22,'\rightarrow'); set(l,'Rotation',-45);
l=text(-0.5,0.3,'a_4'); 
l=text(-0.4,0.5,'x''_4'); 
l=text(0.9,-0.3,'a_5'); 
l=text(-0.4,1.5,'x''_5'); 
l=text(1.9,-0.3,'a_6'); 
l=text(-0.4,2.5,'x''_6'); 
l=text(2.9,-0.3,'a_7'); 
l=text(-0.4,3.5,'x''_7'); 
l=text(3.9,-0.3,'a_8'); 
l=text(3.9,-0.7,0,'x_{max}');
l=text(0.1,4.2,'Kvantiseret værdi'); 
l=text(3.5,0.2,'Signal x'); 
l=title('Lineær kvantisering');
set(l,'Fontsize',12);
set(l,'Color','b');
pause
% Example of quantization
x=[2.8 2.8];
y=[-0.1 2.7];
l=line(x,y);
set(l,'color','k');
set(l,'LineWidth',0.5);
l=text(2.7,-0.2,'x'); 
x=[2.5 2.5];
y=[-0.3 2.7];
l=line(x,y);
set(l,'color','k');
set(l,'LineWidth',0.5);
l=text(2.4,-0.5,'x''_6'); 
l=line([2.5 2.8],[2.6 2.6]);
set(l,'color','r');
set(l,'Linewidth',3)
l=text(2.6,2.8,'Kvantiseringsfejl'); 
set(l,'color','r');
pause
cla
clf
% Non-linear logarithmic quantization
axis([-4.5 4.5 -4.5 4.5]);
axis square
axis off
% Akser
x=[-4.5 4.5];
y=[0 0];
l=line(x,y);
set(l,'color','k');
x=[0 0];
y=[-4.5 4.5];
l=line(x,y);
set(l,'color','k');
% Kvantiseringsniveauer
a=4*[1/8 1/4 1/2 1];
a=[-fliplr(a) 0 a];
for j=0:7
    x=[a(j+1) a(j+2)];
    y=[(a(j+1)+a(j+2))/2 (a(j+1)+a(j+2))/2];
    if x(1)==0
        x(1)=x(2)/2;
        l=line([0 x(1)],y);
        set(l,'color','k');
        set(l,'Linewidth',2);
        set(l,'LineStyle',':')
    end;
    if x(2)==0
        x(2)=x(1)/2;
        l=line([x(2) 0],y);
        set(l,'color','k');
        set(l,'Linewidth',2);
        set(l,'LineStyle',':')
    end;
    l=line(x,y);
    set(l,'color','k');
    set(l,'Linewidth',3)
    x=[a(j+2) 0];
    l=line(x,y);
    set(l,'color','k');
    set(l,'LineStyle',':')
    x=[a(j+1) a(j+1)];
    if (j > 4)|(j==0)
        y=[0 (a(j+1)+a(j+2))/2];
    else
        y=[0 (a(j)+a(j+1))/2];
    end
    l=line(x,y);
    set(l,'color','k');
    set(l,'LineStyle',':');
end
j=8;
x=[a(j+1) a(j+1)];
y=[0 (a(j)+a(j+1))/2];
l=line(x,y);
set(l,'color','k');
set(l,'LineStyle',':');
% Tekster
l=text(-4.2,0.7,'-x_{max}');
l=text(-4.1,0.3,'a_0'); 
l=text(0.1,-3.1,'x''_0'); 
l=text(-2.1,0.3,'a_1'); 
l=text(0.1,-1.6,'x''_1'); 
l=text(-1.1,0.3,'a_2'); 
l=text(0.1,-0.85,'x''_2'); 
l=text(0.1,-0.3,'x''_3'); 
l=text(-0.4,0.3,'x''_4'); 
l=text(-0.4,0.75,'x''_5'); 
l=text(0.9,-0.3,'a_6'); 
l=text(-0.4,1.5,'x''_6'); 
l=text(1.9,-0.3,'a_7'); 
l=text(-0.4,3,'x''_7'); 
l=text(3.9,-0.3,'a_8'); 
l=text(3.9,-0.7,0,'x_{max}');
l=text(0.1,4.2,'Kvantiseret værdi'); 
l=text(3.5,0.2,'Signal x'); 
l=title('Ulineær (logaritmisk) kvantisering');
set(l,'Fontsize',12);
set(l,'Color','b');
