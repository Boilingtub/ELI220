% Define the time range (0 to 300 μs)
t = linspace(0, 3e-3, 10000); % 10000 points from 0 to 300 microseconds

% Calculate h(t) using your derived equation
h_t = 3048.8 * exp(-3039.54 * t) - 3048.8 * exp(-996960.5 * t);

% Create the plot
figure;
plot(t * 1000, h_t, 'k-', 'LineWidth', 2); % Convert time to microseconds for plotting
grid on;

xlabel('Time (ms)', 'FontName', 'Arial', 'FontSize', 16);
ylabel('h(t)', 'FontName', 'Arial', 'FontSize', 16);
title('Impulse Response of RLC Circuit (R = 10kΩ, C = 33nF, L = 10mH)', ...
      'FontName', 'Arial', 'FontSize', 14);

% Set axis limits
xlim([-0.05 3]);
ylim([0 3100]);

% Add grid
grid on;
box on;