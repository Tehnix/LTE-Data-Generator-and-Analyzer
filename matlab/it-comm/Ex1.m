% Øvelse 1 MATLAB træning
% Punkt 1
% Prøv nogle af operationerne i Afsnit 2.1
% Læg f.eks. mærke til
%       - udtagning af visse elementer
%       - ones, zeros, eye
%       - funktioner som giver matrixstørrelse

% Punkt 2
% Prøv nogle af regneoperationerne i Afsnit 2.2
% Læg mærke til
%       - anvendelsen af . for elementvis operation kontra matrixoperation

% Punkt 3
% Lineært ligningssystem A*xyz=h, xyz er den ubekendte søjlevektor [x y z]'
A=[1 2 3;2 0 3;1 1 2]
h=[1 2 3]'
xyz=A^-1*h
pause
% Anden skriveform for dette "Left matrix divide"
xyz=A\h
pause
xyz=linsolve(A,h) % Forældet (symbolsk)
pause
% Sammensætning af A og h
C=[A h]
% Gauss-elimination (row reduced echelon form)
C=rref(C)
xyz=C(:,4)
pause
% Punkt 4
A=[1 3 7 11 19;2 4 8 12 20;-2 -8 -1 0 21;1 2 3 4 22]
fortegn=sign(A)
pause
soejlesum=sum(A)
middel=mean(A)
pause
[M,Mix]=min(A)
pause
[Minimum,ix]=min(M);
Minimum
rindex=Mix(ix)
sindex=ix
pause
% Punkt 5
% tid 2 sek
t=0:0.01:1.99;
% To perioder af sin
v=sin(2*pi*t);
plot(t,v,'g');
title('Sinus')
xlabel('Tid')
ylabel('Spænding')
pause
hold on
v=sin(2*pi*t+pi/2);
plot(t,v,'r');
hold off
pause
% Punkt 6
% En approximation til integralet er under/oversummen
step=0.02;
t=0:step:1-step; % NB! Sidste delareal skal ende i 1
v=cos(2*pi*t);
v2=v.^2;
plot(t,v2)
title('Cosinus kvadreret')
% uosum ligger et sted i mellem over- og undersummen
uosum=sum(v2*step)
% Effekt, Effektiv spænding
Veff=sqrt(uosum)
pause
% Punkt 7
% tid 8 sek
t=0:0.1:7.9;
% Nogle perioder af cos
v=cos(2*pi*t);
plot(t,v);
pause
h1=0.5:0.001:1.5;
error=zeros(1,length(h1));
for n=1:length(h1)
    vp=v(1:end-1)*h1(n);
    error(n)=sum((vp-v(2:end)).^2);
end    
plot(h1,error)
xlabel('h')
ylabel('Fejlkvadrat')
[minerror,h1index]=min(error);
h1min=h1(h1index)
pause
% To konstanter:
h1=1.5:0.001:1.8;
h2=-1.6:0.01:0.5;
error=zeros(length(h1),length(h2));
for n=1:length(h1)
for m=1:length(h2)
    vp=v(2:end-1)*h1(n)+v(1:end-2)*h2(m);
    error(n,m)=sum((vp-v(3:end)).^2);
end    
end
mesh(h2,h1,error)
xlabel('h2')
ylabel('h1')
zlabel('Fejlkvadrat')
[h2min,h1index]=min(error);
[minerror,h2index]=min(h2min);
h1min=h1(h1index(h2index))
h2min=h2(h2index)
kvadfejk=error(h1index(h2index),h2index)
return
% Overføringsfunktion, Kapitel 5
H=h1min*exp(-j*2*pi/10)+h2min*exp(-j*2*pi*2/10)
abs(H)
% Skulle gerne blive 1!
