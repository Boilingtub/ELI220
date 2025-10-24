% Parameters for question 2e
f = logspace(0, 6, 1000); % Frequency from 1 Hz to 1 MHz (log scale)

% Calculate magnitude response
H_mag = 1 ./ sqrt((1 - 3.95e-9 * f.^2).^2 + (19.88e-9 * f).^2);

% Convert to dB
H_dB = 20*log10(H_mag);

% Create the plot
figure;
semilogx(f, H_dB, 'k-', 'LineWidth', 2.5);
grid on;
set(gca, 'FontSize', 12);
xlabel('Frequency (f, Hz)', 'FontSize', 14);
ylabel('|H(f)| (dB)', 'FontSize', 14);
title('Magnitude Response of RLC Circuit (R = 680Ω, C = 33nF, L = 10mH)', 'FontSize', 16);
xlim([1 1e6]); % Set x-axis limits from 1 Hz to 1 MHz

% Add reference lines for better visualization
hold on;
semilogx([1 1e6], [-3 -3], 'k--', 'LineWidth', 1); % -3 dB line
legend('Magnitude Response', '-3 dB point', 'Location', 'best');
hold off;