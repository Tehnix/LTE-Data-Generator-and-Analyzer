% Example 2.14
S=[eye(7);zeros(1,7)];
% Connections g1,g2,g3...,g7,1 in Figure 2.8
f=[0 0 0 1 1 1 0 1]';
S=[f S]
% The shift register is initialized with 1s
s=ones(1,8);
% a is input sequence
a=[0 1 1 0 0 1 0 1];
% Calculations of output
for i=1:length(a)
   % Calculation of next contents of shift register assuming zero input
   % The first column of S gives the feedback part of the sum to go
   % into s(1). The "eye(7)" moves the contents of all shift register
   % cells one position to the right.
   s=mod(s*S,2);
   % s(1) is modified with the current input
   s(1)=mod(s(1)+a(i),2);
   % s(1) is also the output of the scrambler
   y(i)=s(1);
   % Formatted display of i followed by s
   fprintf(1,'%2i: ',i);
   fprintf(1,' %1i',s);
   fprintf(1,'  output: %1i\n',y(i));
end   
% Recovery of the data from y again, Figure 2.9 
% The shift register is initialized with ones
s=ones(1,8);
% Calculations of data
for i=1:length(y)
   p=s*f;
   % Shift 1 position to the right
   % s(1) is modified with the current input
   s=[y(i) s(1:7)];
   % Output data
   aa(i)=mod(y(i)+p,2);
end
aa
