% Demonstration of simple CRC
% Hamming (15,11)
% G(x)= x^4+x+1
% Vectors start always with highest power
G=[1 0 0 1 1];
m=length(G)-1;  % Degree of G
K=[1 0 0 1 0 1 1 1 0 1 1]; % Information bits
N=length(K)+m;  % Length of codeword
% Get remainder R from division by G
[Q,R]=deconv([K zeros(1,m)],G);
% Create codeword
C=[K mod(R(end-m+1:end),2)]
% No errors should give syndrome 0000
[Q,R]=deconv(C,G);
syndrome=zeros(N+1,m);
syndrome(1,:)=mod(R(end-m+1:end),2);
% One error
for j=1:N
    err=zeros(1,N);
    err(j)=1;
    % Received sequence
    Y=xor(C,err);
    [Q,R]=deconv(Y,G);
    syndrome(j+1,:)=mod(R(end-m+1:end),2);
end
syndrome
pause
% Two errors
err(5)=1;
[Q,R]=deconv(xor(C,err),G);
syndrome2=mod(R(end-m+1:end),2)   % Just like an error in position 10
pause
% Extra x+1 factor in G, resulting in codewords with even # of ones
G2=mod(conv([1 0 0 1 1],[1 1]),2)
m=length(G2)-1;  % Degree of G2
K=[1 0 0 1 0 1 1 1 0 1]; % Information bits - one less
N=length(K)+m;  % Length of codeword
% Get remainder R from division by G
% Create codeword
[Q,R]=deconv([K zeros(1,m)],G2);
C=[K mod(R(end-m+1:end),2)]
% No errors should give syndrome 00000
[Q,R]=deconv(C,G2);
syndrome=zeros(N+1,m);
syndrome(1,:)=mod(R(end-m+1:end),2);
% One error
for j=1:N
    err=zeros(1,N);
    err(j)=1;
    % Received sequence
    Y=xor(C,err);
    [Q,R]=deconv(Y,G2);
    syndrome(j+1,:)=mod(R(end-m+1:end),2);
end
syndrome
pause
% Two errors
err(5)=1;
[Q,R]=deconv(xor(C,err),G2);
syndrome2=mod(R(end-m+1:end),2)  
% Syndrome not found among 1-error syndromes which all are with odd-weight
