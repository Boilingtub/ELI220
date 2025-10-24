% Parameters
T = 1;          % Period (seconds)
tau = 0.5;      % Pulse width (seconds) - assuming τ = T/2
num_periods = 3; % Number of periods to display

% Time vector
t = linspace(-T, 2*T, 3000); % Time range from -T to 2T

% Create the pulse train function
c_t = zeros(size(t));
for n = -1:2 % Cover multiple periods
    % Create rectangular pulse centered at nT
    pulse = double((t >= (n*T - tau/2)) & (t <= (n*T + tau/2)));
    c_t = c_t + pulse;
end

% Plot the signal
figure;
plot(t, c_t, 'k-', 'LineWidth', 2);
grid on;

% Set labels with Arial font, 11pt size
xlabel('Time, t (s)', 'FontName', 'Arial', 'FontSize', 16);
ylabel('c(t)', 'FontName', 'Arial', 'FontSize', 16);
title('Pulse Train Signal c(t)', 'FontName', 'Arial', 'FontSize', 18);

% Set axis limits and ticks
xlim([-T, 2*T]);
ylim([-0.2, 1.2]);

xticks(sort([-tau/2, tau/2, 0, T, 2*T])); % Use sort() to arrange in increasing order
yticks([0, 1]);

% Add the annotations
text(-tau/2, -0.1, '-\tau/2', 'HorizontalAlignment', 'center', 'FontSize', 16);
text(tau/2, -0.1, '\tau/2', 'HorizontalAlignment', 'center', 'FontSize', 16);
text(0, -0.1, '0', 'HorizontalAlignment', 'center', 'FontSize', 16);
text(T, -0.1, 'T', 'HorizontalAlignment', 'center', 'FontSize', 16);
text(2*T, -0.1, '2T', 'HorizontalAlignment', 'center', 'FontSize', 16);

% Add arrow at the end of time axis
text(2*T*1.05, -0.1, 't →', 'FontSize', 16);

% Make the plot look clean
box on;
set(gca, 'FontName', 'Arial', 'FontSize', 16);