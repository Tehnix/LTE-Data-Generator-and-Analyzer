clear all
% Example 2.9 Energy and power
% Energy spectrum
T=1;
N=8;
f=[1 1 1 1 1 0 0 0];
% Parseval for finite energy f
energy_time=T*sum(f.^2)     % (2.15)
F=T*fft(f)                  % (2.3)
energy_spectrum=abs(F).^2   % (2.16)
energy_freq=sum(energy_spectrum)/N/T % (2.17 approx. 2.18)
pause
% Comparison with analytical expression (2.1)
oindex=0:N-1;
omega=oindex*2*pi/N/T;
F_anal=T*(f(1)+f(2)*exp(-j*omega*T)+f(3)*exp(-j*2*omega*T)+f(4)*exp(-j*3*omega*T)+f(5)*exp(-j*4*omega*T));
energy_anal=abs(F_anal.^2)  % (2.16)
pause
% Parseval for periodic f
power_time=sum(f.^2)/N      % (2.20)
F=fft(f)/N;                 % (2.2)
power_spectrum=abs(F).^2    % (2.21)
power_freq=sum(power_spectrum) % (2.22)
%
energy_spectrum/N/T/N/T
