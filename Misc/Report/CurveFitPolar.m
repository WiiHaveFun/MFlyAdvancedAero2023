%% Drag polar function
CDmin = 0.0849149;
K1 = 0.0552;
K2 = 0.295136;
CLmin = 0.775081;
CD = @(CL) CDmin + K1 .* CL.^2 + K2 .* (CL - CLmin).^2;

%% Drag polar
CLmax = 1.3805;
y = 0:0.01:1.3805;
x = CD(y);

%% Max CL/CD
LD = y ./ x;
[LDMax, I] = max(LD);

%% Cruise CL/CD
CLcruise = 0.8567;
CDcruise = CD(CLcruise);
LDcruise = CLcruise ./ CDcruise;

%% Plot
plot(x, y, LineWidth=3)
xlim([0,0.3])
ylim([0,1.4])
hold on;

scatter(x(I), y(I), 50, 'filled')
scatter(CDcruise, CLcruise, 50, 'filled')

%% Latex formatting
set(groot,'defaultLineLineWidth',0.5)
set(groot,'defaultTextInterpreter','latex')
set(groot,'defaultAxesTitleFontSize',1)
set(groot,'defaultAxesLabelFontSize',1)
set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultTextFontSize',14)
set(groot,'defaultAxesFontSize',14)
set(groot,'defaultLegendInterpreter','latex')

text(x(I)+0.03, y(I), "Max $C_{L}/C_{D}=6.73$", "HorizontalAlignment", "left", "VerticalAlignment", "bottom");
text(CDcruise+0.02, CLcruise, "Cruise $C_{L}/C_{D}=6.72$", "HorizontalAlignment", "left", "VerticalAlignment", "top");

% text(1.9533-0.4,0.336971,{'MTOW'; 'Design'; 'Point'},'HorizontalAlignment','right','VerticalAlignment','middle')
% hold on
% quiver(1.9533-0.35, 0.336971, 0.25, 0, 'off', 'filled', 'Color', 'k', 'ShowArrowHead', 'off', 'LineWidth', 1);

set(gcf, 'units', 'inches', 'position', [5 6 5 2.8]);