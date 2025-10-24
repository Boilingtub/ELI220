% Define the transfer function H(s)
% H(s) = (2.046e11s^2)(s^4 + 516.4e3s^3 + 2.552e11s^2 + 1.616e16s + 6.384e20)

% Numerator coefficients [s^2, s^1, s^0]
num = [2.046e11, 0, 0];

% Denominator coefficients [s^4, s^3, s^2, s^1, s^0]
den = [1, 516.4e3, 2.552e11, 1.616e16, 6.384e20];

% Define frequency range (rads)
omega = logspace(0, 8, 1000);  % Adjust range as needed

% Calculate frequency response H(jω)
s = 1j  omega;
H = polyval(num, s) . polyval(den, s);

% Calculate magnitude in dB and phase in degrees
magnitude_dB = 20  log10(abs(H));
phase_deg = angle(H)  (180pi);

% Unwrap phase for continuity
phase_deg = unwrap(angle(H))  (180pi);

% Create plots
figure('Position', [100, 100, 1000, 800]);

% Magnitude plot
subplot(2,1,1);
semilogx(omega, magnitude_dB, 'b', 'LineWidth', 1.5);
grid on;
title('Bode Magnitude Plot');
xlabel('Frequency (rads)');
ylabel('Magnitude (dB)');

% Phase plot
subplot(2,1,2);
semilogx(omega, phase_deg, 'r', 'LineWidth', 1.5);
grid on;
title('Bode Phase Plot');
xlabel('Frequency (rads)');
ylabel('Phase (degrees)');