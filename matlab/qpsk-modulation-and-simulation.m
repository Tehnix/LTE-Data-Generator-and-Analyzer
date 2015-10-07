clear all
clc
close all

%% Opgave 1

T = 1;
m = 8;
Ts = T / m ;
ti = -4* T : Ts :4* T ;
%Vi benytter cosinus roll off i forhold til ti
g = (cos ((3* pi* ti ) /(2* T ) ) + ( T ./(2* ti ) ) .* sin(pi* ti /(2* T ) ) ) ...
./ (1 -(2* ti / T ) .^2) ;
g (29) = 0.9085;
g (33) = 1.7854;
g (37) = 0.9085;

figure
plot ( ti , g ) ;
title ('Cosinus -roll -off som tidsfunktion g(t)') ;
xlabel ('Tid ') ;
ylabel ('Puls ') ;
legend ('g(t)','best ') ;

g_out = conv (g , g ) ;

figure
stem ( -8* T : Ts :8* T , g_out ) ;
title ('Cosinus -roll -off sampling over tid ') ;
xlabel ('Tid ') ;
ylabel ('Puls ') ;

hold on
stem ( -8* T : Ts * m :8* T , g_out (1: m :end ) ,'r') ;


%% Opgave 2

a = zeros (8 ,1000) ;
b = a ;

a (1 , 1: end) = sign ( randn (1 ,1000) ) ;
b (1 , 1: end) = sign ( randn (1 ,1000) ) ;

a = reshape (a ,1 ,8000) ;
b = reshape (b ,1 ,8000) ;

a0 = conv (a , g ) ;
b0 = conv (b , g ) ;

t = (1: length ( a0 ) ) * Ts ;
f_c = 2/ T ;

a0 = a0 .*( sqrt (2) * cos (2* pi* f_c * t ) ) ;
b0 = b0 .*( sqrt (2) * sin (2* pi* f_c * t ) ) ;

v = a0 + b0 ;

figure
plot ( t (1:120) ,v (1:120) ) ;
title ('Tilfældigt signal sendt gennem bærebølgen ') ;
xlabel ('Tid ') ;
ylabel ('Frekvens ') ;
legend ('v(t)','best ') ;

%% Opgave 3

x = v .*( sqrt (2) *cos (2* pi* f_c * t ) ) ;
y = v .*( sqrt (2) *sin (2* pi* f_c * t ) ) ;

I = conv (g , x ) ;
Q = conv (g , y ) ;

figure
cla reset
hold on
for j =1:1000
    plot ( Q (65+( j -1) * m ) ,I (65+( j -1) * m ) ,'*')
end
hold off
%set (gca , 'XLim ', [ -25 ,25]) ;
%set (gca , 'YLim ', [ -25 ,25]) ;

title (' Kvadraturdemodulation af indgangsignalet ') ;
xlabel ('In - phase (I)') ;
ylabel ('Quadrature (Q)') ;
legend ('Symboler ') ;

%% Opgave 4

sigma = sqrt (3) ;

v = a0 + b0 ;

v = v + sigma * randn (1 , length ( v ) ) ;



x = v .*( sqrt (2) *cos (2* pi* f_c * t ) ) ;
y = v .*( sqrt (2) *sin (2* pi* f_c * t ) ) ;

I = conv (g , x ) ;
Q = conv (g , y ) ;

figure
cla reset
hold on
for j =1:1000
    if ( a (1+( j -1) * m ) == sign ( I (65+( j -1) * m ) ) && ...
    b (1+( j -1) * m ) == sign ( Q (65+( j -1) * m ) ) )
        success = plot ( I (65+( j -1) * m ) ,Q (65+( j -1) * m ) ,'b*') ;
    else
        errors = plot ( I (65+( j -1) * m ) ,Q (65+( j -1) * m ) ,'r*') ;
    end
end
hold off
%set (gca , 'XLim ', [ -50 ,50]) ;
%set (gca , 'YLim ', [ -50 ,50]) ;

title (' Kvadraturdemodulation af indgangsignalet ') ;
xlabel ('In - phase (I)') ;
ylabel ('Quadrature (Q)') ;
legend ([ success , errors ] ,'Rigtige symboler ', 'Fejl symboler ', 'best ') ;

%% Opgave 5

sigma = 1.5:0.01:4;

errors = zeros (1 , length ( sigma ) ) ;

for i = 1: length ( sigma ) ;

    v = a0 + b0 ;
    v = v + sigma ( i ) * randn (1 , length ( v ) ) ;

    x = v .*( sqrt (2) *cos (2* pi* f_c * t ) ) ;
    y = v .*( sqrt (2) *sin (2* pi* f_c * t ) ) ;

    I = conv (g , x ) ;
    Q = conv (g , y ) ;

    for j =1:1000
        if ( a (1+( j -1) * m ) ~= sign ( I (65+( j -1) * m ) ) )
            errors ( i ) = errors ( i ) +1;
        end


        if ( b (1+( j -1) * m ) ~= sign ( Q (65+( j -1) * m ) ) )
            errors ( i ) = errors ( i ) +1;
        end
    end
end

% For at hyppigheden , tager vi og dividerer med 2000 , der angiver det
% samlede antal symboler i de to kanaler .

errors = errors /2000;

figure
plot ( sigma , errors ) ;
title (' Fejlhyppighed i forhold til støj ') ;
ylabel ('Fejl (%) ') ;
xlabel ('Støjforhold (\sigma)') ;
legend (' Fejlhyppighed ') ;


%% Opgave 6

E = sum( g .^2* Ts ) %#ok <NOPTS >
%## OUTPUT : E = 2.4669

Pe = qfunc ( sqrt ( E ./( Ts * sigma .^2) ) ) ;

SNRdb = 10* log10 ( E ./(2* Ts * sigma .^2) ) ;

figure
semilogy ( SNRdb , errors ,'b') ;
hold on
semilogy ( SNRdb , Pe , 'r') ;
title (' Fejlsandssynlighed som funktion af signal / støjforhold ') ;
ylabel ('P_e ') ;
xlabel ('Signal / støjforhold (SNR ) (dB)') ;
legend ('Simuleret ','Teoretisk ') ;
