% Parameters
fc = 8e3;  % Cutoff frequency 8 kHz

% Create frequency vector (logarithmically spaced)
f = logspace(1, 6, 1000);  % 10 Hz to 1 MHz

% Initialize transfer function
H = zeros(size(f));

% Calculate transfer function at each frequency using s = jω
for i = 1:length(f)
    s = 1j * 2 * pi * f(i);  % s = j*omega
    
    % Numerator: 2*s^3
    num = 2 * s^3;
    
    % Denominator: s^3 + 100530.96*s^2 + 5.06e9*s + 1.27e14
    den = s^3 + 100530.96*s^2 + 5.06e9*s + 1.27e14;
    
    H(i) = num / den;
end

% Calculate magnitude in dB and phase in degrees
mag_dB = 20 * log10(abs(H));
phase_deg = unwrap(angle(H)) * 180 / pi;

% Create figure with subplots
figure;

% Magnitude plot (top subplot)
subplot(2,1,1);
semilogx(f, mag_dB, 'k', 'LineWidth', 2);
hold on;
grid on;
title('Bode plot of H(f) of the Butterworth High-Pass Filter');
ylabel('Magnitude (dB)');

% Find exact -3dB point relative to passband (6 dB - 3 dB = 3 dB)
[~, idx_fc] = min(abs(mag_dB - 3));
fc_exact = f(idx_fc);

% Plot horizontal line at 3dB (which is -3dB relative to passband)
yline(3, '--r', 'LineWidth', 1.5, ...
    'Label', '-3 dB (relative to passband)', ...
    'LabelHorizontalAlignment', 'right', ...
    'LabelVerticalAlignment', 'bottom');

% Plot vertical line from 3dB point to frequency axis
xline(fc_exact, '--r', 'LineWidth', 1.5, ...
    'Label', sprintf('fc = %.1f kHz', fc_exact/1000), ...
    'LabelVerticalAlignment', 'middle', ...
    'LabelHorizontalAlignment', 'right');

% Add decay rate indication (60 dB/decade between two specific decades)
f1 = 800;    % Start frequency
f2 = 8000;   % End frequency (one decade higher)

% Find the magnitude at f1 from the actual response
[~, idx_f1] = min(abs(f - f1));
mag_ref = mag_dB(idx_f1);

% Create the 60 dB/decade slope line
f_slope = logspace(log10(f1), log10(f2), 50);
mag_slope = mag_ref + 60 * log10(f_slope/f1);

% Plot horizontal reference lines at the decade points
yline(mag_slope(1), '--k', 'LineWidth', 0.5, 'Alpha', 0.7);
yline(mag_slope(end), '--k', 'LineWidth', 0.5, 'Alpha', 0.7);

% Add text annotations for the dB values at the decade points
vertical_offset = 3; 
horizontal_position = 20;

text(horizontal_position, mag_slope(1) + vertical_offset, ...
     sprintf('%.1f dB', mag_slope(1)), ...  
     'HorizontalAlignment', 'left', 'FontSize', 8);

text(horizontal_position, mag_slope(end) + vertical_offset, ...
     sprintf('%.1f dB', mag_slope(end)), ... 
     'HorizontalAlignment', 'left', 'FontSize', 8);

% Adjust plot limits
xlim([10, 1e6]);
ylim([-65, 15]);

% Phase plot (bottom subplot)
subplot(2,1,2);
semilogx(f, phase_deg, 'k', 'LineWidth', 2);
grid on;
ylabel('Phase (degrees)');
xlabel('Frequency (Hz)');
xlim([10, 1e6]);
ylim([-390, -60]);

% Add grid lines at common phase angles
yticks(-360:45:-90);

% Display additional information
fprintf('High-frequency Gain: %.2f dB\n', 20*log10(2));
fprintf('Exact -3dB point (relative to passband): %.1f Hz (%.2f kHz)\n', fc_exact, fc_exact/1000);
fprintf('Magnitude at fc: %.2f dB\n', mag_dB(idx_fc));
fprintf('Phase at fc: %.1f degrees\n', phase_deg(idx_fc));
fprintf('DC Gain: %.2f dB\n', 20*log10(abs(2*0^3/(0^3 + 100530.96*0^2 + 5.06e9*0 + 1.27e14))));
fprintf('Decay rate verification:\n');
fprintf('  At %.0f Hz: %.1f dB\n', f1, mag_slope(1));
fprintf('  At %.0f Hz: %.1f dB\n', f2, mag_slope(end));
fprintf('  Actual slope: %.1f dB/decade\n', (mag_slope(end) - mag_slope(1)));