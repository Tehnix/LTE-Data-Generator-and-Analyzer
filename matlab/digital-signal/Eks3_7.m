%% Ex 3.7 AMI
p = input('Probability for 1? : ');
Q=[1-p p;p 1-p]
% The MATLAB function eig finds the right column eigenvector
% but transposing before changes to left row eigenvector
[V,D]=eig(Q')
% The eigenvalues are found as the diagonal of D, and it is
% seen that eigenvalue 1 corresponds to column 2 of V
% The stationary distribution then becomes
pstat=V(:,2)'/sum(V(:,2))
X=[0 -1;1 0]
% x+, the average of the symbol after each state
% is found from the rows of Q
xplus=sum((Q.*X)')
% x-, the average of the symbol before each state
% is found from the columns of Q
xminus=(pstat*(Q.*X))./(pstat*Q)
% (3.24)
R0=pstat*diag(Q*X'.^2)
R=[];
for k=1:100;
% (3.25) for remaining R(k)
    R=[R; k (pstat.*xminus)*Q^(k-1)*xplus'];
end
R(1:8,:)
T=1;
SX=real(T*fft([R0 R(:,2)' fliplr(R(:,2)')]));
plot(fftshift(SX))