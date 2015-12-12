function [abssum]=fsinusgraf(frekvens,begynd,trin,sidst);
% Tegner en graf for sinus med frekvensen 'frekvens'
% fra tid 'begynd' til 'sidst' med tidsopløsning 'trin'
% og udregner middelværdi af kvadratet
tid=begynd:trin:sidst;
y=sin(2*pi*frekvens*tid);
plot(tid,y,'r');
abssum=mean(y.^2);
return