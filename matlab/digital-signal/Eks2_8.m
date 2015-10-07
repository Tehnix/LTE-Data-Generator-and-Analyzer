% Example 2.8
% Demonstration of IIR system
T=1;
% 1st order system
% Various things could be demonstrated
% q=1/4 stable system, impulse response dies out
% q=1   unstable system, infinite impulse response 
% q=-1  unstable system, infinite impulse response
p=-1/2;               % FIR part (numerator)
q=1/4;                 % IIR part (denominator)
d=[1 zeros(1,1000)];  % Delta function for impulse response
h=zeros(1,length(d)); % Initialize output (and IIR-register)
h(1)=d(1);            % First output equals input
                      % since shift register assumed to be zero
for k=2:length(h)
    h(k)=-q*h(k-1)+d(k)+p*d(k-1); % (2.13)
end
% The impulse response:
h
return
pause
% more general system
T=1;
p=[1 2 1];                         % FIR part (numerator)
q=[1 -1 1/4];                      % IIR part (denominator)
d=[1 zeros(1,100000)];             % Delta function for impulse response
gi=conv(d,p);                      % Intermediate g
g=zeros(1,length(gi)+length(q)-1); %Initialize output (and IIR-register)
for k=length(q):length(g)
    a=conv(q,g(k-length(q)+1:k-1));       % (2.13)
    g(k)=-a(length(q))+gi(k-length(q)+1); % (2.13)
end
% The impulse response:
g(1:200)
% Various things could be demonstrated
% First order
% q=[1 -1] infinite output
% q=[1 1/2] output dies out
% q=[1 1] finite output
% Second order
% q=[1 0 1]       % oscillations
% abs(roots(q))
% q=[1 -1 1]      % oscillations
% abs(roots(q))
% q=[1 -2 1]      % unlimited output, instability
% abs(roots(q))
% q=[1 -1 1/4]    % output dies out in 30 samples
% abs(roots(q))
