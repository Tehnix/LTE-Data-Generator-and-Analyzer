% Example 3.1
% Simulation of random signals
% Uniform distribution 0 - 1 (actually [2^(-53), 1-2^(-53)])
x=rand(1,10)
mean_uni=mean(x)
% More values
x=rand(1,1000);
mean_uni1000=mean(x)
var_uni1000=var(x)
pause
% Uniform distribution -5 - 5 and more values
Delta=10;
x=Delta*(rand(1,100000)-0.5);
mean_uni2=mean(x)
var_uni2=var(x)
pause
% Extra: Distribution of sums
a=10*rand(11,100000);   % 11 seq. of real numbers 10*[2^(-53), 1-2^(-53)]
a=floor(a);             % 11 seq. of integers 0 to 9
mean0to9=mean(a,2)      % Mean of each sequence
meanall=sum(sum(a))/(11*100000) % Mean of all sequnces
mean10=mean(a);         % Mean of 11 numbers
stem([0:0.25:10],hist(mean10,[0:0.25:10]))
title('Distribution of means of 11 numbers')
pause
% Discrete distribution
% Independent +1/-1 variables from a with probability p for +1
p=1/4
x=rand(1,10);
a=sign(p-x)
pause
% Other distribution function
% Two-sided laplace
sigma=1;
x=rand(1,10000);
a=(x<0.5)*sigma.*log(2*x)/sqrt(2)...
 -(x>=0.5)*sigma.*log(2*(1-x))/sqrt(2);
stem([-10:0.1:10],hist(a,[-10:0.1:10]))
title('Simulated Laplace distribution')