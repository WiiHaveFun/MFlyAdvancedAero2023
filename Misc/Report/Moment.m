%% Moment dat
alpha = [-8.3722, -7:1:20];
CM = [0.0528, 0.0377, 0.0259, 0.0135, 0.0004, -0.0131, -0.0271, -0.0414, -0.0560, -0.0709, -0.0859, -0.1009, -0.1158, -0.1305, -0.1452, -0.1596, -0.1740, -0.1881, -0.2021, -0.2158, -0.2294, -0.2427, -0.2557, -0.2685, -0.2811, -0.2936, -0.3060, -0.3183, -0.3307];

%% Plot
plot(alpha, CM, LineWidth=3)
xlim([-8.3722, 20])
ylim([-0.34, 0.1])
%% Latex formatting
set(groot,'defaultLineLineWidth',0.5)
set(groot,'defaultTextInterpreter','latex')
set(groot,'defaultAxesTitleFontSize',1)
set(groot,'defaultAxesLabelFontSize',1)
set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultTextFontSize',14)
set(groot,'defaultAxesFontSize',14)
set(groot,'defaultLegendInterpreter','latex')

text(10, 0, "$C_{M_{\alpha},avg}=-0.0135$ deg$^{-1}$", "HorizontalAlignment", "center", "VerticalAlignment", "middle");

% text(1.9533-0.4,0.336971,{'MTOW'; 'Design'; 'Point'},'HorizontalAlignment','right','VerticalAlignment','middle')
% hold on
% quiver(1.9533-0.35, 0.336971, 0.25, 0, 'off', 'filled', 'Color', 'k', 'ShowArrowHead', 'off', 'LineWidth', 1);

set(gcf, 'units', 'inches', 'position', [5 6 5 2.8]);