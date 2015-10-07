% Example 3.3
clear all
% Creation of a sample
% a uniform distribution 0 to 1
a=rand(1,20);
p=input('Probability of +1-1? ');
% Independent +1/-1 variables from a for p
a=sign(p-a);
% Formation of +1-1 or -1+1 blocks
a(2,:)=-a(1,:)
x=reshape(a,1,2*20)
pause
% Experimental calculation of power spectrum from Ex. 3.2
T=1;
N=100;               % Block size gives frequency resolution
%p=0.5;
Nexp=input('# of experiments? ')
S_X=zeros(1,N);
for n=1:Nexp
    a=rand(1,N/2);
    a=sign(p-a);
    a(2,:)=-a(1,:);
    x=reshape(a,1,N);
    X=T*fft(x);
    S_X=S_X+abs(X).^2/(N*T);    % Contribution to average
end;
oindex=0:N-1;
omega=oindex*2*pi/(N*T);
stem(omega,S_X/Nexp);           % Experimental Power spectrum (averaged)
hold on
plot(omega,T*(1-cos(omega*T)),'r'); % Ex. 3.2 theory for p = 1/2
hold off
pause
% autocorrelation from experiment
R=ifft(S_X/Nexp)/T;
plot(fftshift(R))
