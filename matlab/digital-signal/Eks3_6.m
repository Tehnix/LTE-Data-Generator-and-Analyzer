% Ex 3.6
Q=[.5  0 .5  0;...
   .5  0 .5  0;...
    0 .5  0 .5;...
    0 .5  0 .5];
% The MATLAB function eig finds the right column eigenvector
% but transposing before changes to left row eigenvector
[V,D]=eig(Q')
% The eigenvalues are found as the diagonal of D, and it is
% seen that eigenvalue 1 corresponds to column 3 of V
pause
% The stationary distribution then becomes
p=V(:,3)'/sum(V(:,3))
pause
% The output matrix is X. Some of the 0-elements are irrelevant
% since the corresponding transition is not found 
X=[ 0  0 -1  0;...
   -1  0 -1  0;...
    0  1  0  1;...
    0  1  0  0];
% (3.23)
R0=p*sum(Q.*X.^2,2)
% x+, the average of the symbol after each state
% is found from the rows of Q
Xplus=sum(Q.*X,2)'
% x-, the average of the symbol before each state
% is found from the columns of Q
Xminus=(p*(Q.*X))./p
pause
% (3.24)
for j=1:6
   Rj(j,:)=[j (p.*Xminus)*Q^(j-1)*Xplus'];
end
Rj
% Power spectrum with 16 points
R=[R0 Rj(:,2)' zeros(1,16-1-2*6) fliplr(Rj(:,2)')];
T=1;
Sw=T*fft(R);
%
f=(-16/2:16/2-1)/(16*T);
plot(f,fftshift(Sw))
pause
SwTh=T*(3/4-3/4*cos(2*pi*f*T)+1/8*cos(2*pi*2*f*T));
hold on
plot(f,SwTh,'r')
hold off