% Define the frequency range
f = -40:0.01:40;

% Define the period T
T = 1; % seconds

% The impulse locations are at multiples of 1/T = 1 Hz
impulse_locations = -40:1:40;

% Create a figure with better default settings
figure;
hold on;

% Plot a zero line for visual reference
%plot(f, zeros(size(f)), 'k-', 'LineWidth', 0.5); 

% Plot vertical lines for the impulses
for k = 1:length(impulse_locations)
    x = impulse_locations(k);
    plot([x, x], [0, 1], 'k-', 'LineWidth', 2);
end

% Format the plot with specific font settings
xlabel('Frequency, f (Hz)', 'FontSize', 16);
ylabel('C(f)', 'FontSize', 16);
title('Fourier Transform of Impulse Train (\tau \rightarrow 0, T = 1s)', ...
      'FontSize', 16);

% Set axis limits with more space at the top
xlim([-41, 41]);
ylim([-0.05, 1.2]);

% Add grid and box
grid on;
box on;

% Adjust figure margins for better appearance
set(gca, 'Position', [0.1, 0.15, 0.85, 0.75]);

% Convert data coordinates to normalized figure coordinates for annotations
axPos = get(gca, 'Position');
xRange = xlim;
yRange = ylim;

% Add arrowheads using annotation (which uses normalized coordinates)
for k = 1:length(impulse_locations)
    x = impulse_locations(k);
    
    % Convert data coordinates to normalized figure coordinates
    xNorm = axPos(1) + (x - xRange(1)) / (xRange(2) - xRange(1)) * axPos(3);
    yNorm = axPos(2) + (1 - yRange(1)) / (yRange(2) - yRange(1)) * axPos(4);
    
    % Create arrowhead with shorter head length
    annotation('arrow', [xNorm, xNorm], [yNorm-0.02, yNorm], ...
               'HeadLength', 4, 'HeadWidth', 6, 'Color', 'k');
end