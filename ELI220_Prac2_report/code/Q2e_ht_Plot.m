% Define the time range (0 to 300 μs)
t = linspace(0, 300e-6, 10000); % 10000 points from 0 to 300 microseconds

% Calculate h(t) using your derived equation
h_t = 700247.3 * exp(-34000 * t) .* sin(43293.24 * t);

% Create the plot
figure;
plot(t * 1e6, h_t, 'k-', 'LineWidth', 2); % Convert time to microseconds for plotting
grid on;

% Set labels with Arial font, 11pt size
xlabel('Time (μs)', 'FontSize', 16);
ylabel('h(t)', 'FontSize', 16);
title('Impulse Response of RLC Circuit (R = 680Ω, C = 33nF, L = 10mH)', ...
       'FontSize', 14);

% Set axis limits
xlim([0 300]);
% ylim might need adjustment based on your calculated values

% Add grid
grid on;
box on;