% Demonstration af MATLAB scripts og funktioner
% Tegn sinusgraf ved m-fil
f=1; % Frekvens
start=-1;
step=0.01;
slut=3;
sinusgraf
t(1:4)
pause
% Tegn sinusgraf ved funktion i m-fil
help fsinusgraf
pause
figure
s=fsinusgraf(2,0,1e-3,3)
%frekvens
% Løkker
y=1:10;
z=0.5*y(1:9)+3*y(2:10)
for i=1:9
    zf(i)=0.5*y(i)+3*y(i+1);
end
zf
pause
i=1;
while i<9
    i=i+1
end
pause
tal=input('Skriv et tal her: ');
if tal > 10
    display('tallet er større end 10')
else
    display('tallet er højst 10')
end