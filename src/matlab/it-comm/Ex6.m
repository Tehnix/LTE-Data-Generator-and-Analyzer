% Øvelse 6
% Modtagelse af firkantpuls med støj
clear;
set(0,'DefaultFigureColor','w');
clf reset
cla reset
a(1,:)=sign(randn(1,10));
for i=2:10
    a(i,:)=a(1,:);
end
x=reshape(a,1,100);
plot(x)
set(gca,'Ylim',[-5 5]);
hold on
pause
sigma=3;
n=sigma*randn(1,length(x));
r=x+n;
plot(r,'r');
pause
% Her bruges antagelse om firkantpuls (med 10 1'er)
for i=1:10
    s(i)=sum(r((i-1)*10+1:i*10));
end
stem(10:10:100,s/10)
% Nogen fejl?
fejl=sum(sign(s)~=a(1:10:end))
hold off
pause
% Kontroller støj
hist(n,20)
title('Støjens fordeling')
pause
% Anden pulsform
g=[0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9];
a(1,:)=sign(randn(1,10));
a(2:10,:)=zeros(9,10);
x=reshape(a,1,100);
x=conv(x,g);
x=x(1:100);
stem(x)
set(gca,'Ylim',[-5 5]);
pause
hold on
r=x+n;
plot(r,'r');
pause
% Nu er det ikke en firkantpuls, men g
for i=1:10
    s(i)=sum(r((i-1)*10+1:i*10).*g);
end
stem(10:10:100,s/10,'g')
% Nogen fejl?
fejl=sum(sign(s)~=a(1:10:end))
hold off
SNRfirkant=sum(ones(1,10).^2)/sigma^2
SNRtrekant=sum(g.^2)/sigma^2
pause
% Ortogonale signaler
% a-signal
g=ones(1,10);
a(1,:)=sign(randn(1,10));
a(2:10,:)=zeros(9,10);
x=reshape(a,1,100);
x=conv(x,g);
% b-signal
g2=[1 1 1 1 1 -1 -1 -1 -1 -1];
b(1,:)=sign(randn(1,10));
b(2:10,:)=zeros(9,10);
y=reshape(b,1,100);
y=conv(y,g2);
r=x+y;
% Nu er der to modtagere
for i=1:10
    sa(i)=sum(r((i-1)*10+1:i*10).*g);
end
subplot(2,1,1)
stem(x,'b')
hold on
stem(10:10:100,sa/10,'g')
hold off
title('a-sekvens')
% b
for i=1:10
    sb(i)=sum(r((i-1)*10+1:i*10).*g2);
end
subplot(2,1,2)
stem(y,'r')
hold on
stem(10:10:100,sb/10,'k')
hold off
title('b-sekvens')
