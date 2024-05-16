%% MX-9 Sizing Plot

%% Aircraft Parameters and atmosphere

b = 3.0328; % m
sref = 1.4976; % m^2
AR = b^2 / sref;
rho = 1.14; % kg/m^3

%% BWB MX-9 CFD Polar

% -5 to 15 deg
% polar_CFD_BWB = readtable("/Users/michaelchen/Documents/M-Fly/2023/CFD/Polars/Scaled/BWB/BWB_drag_polar_scaled.csv");
polar_CFD_BWB = readtable("/Users/michaelchen/Documents/M-Fly/2023/CFD/Polars/Scaled/10prism/BWB/BWB_drag_polar_scaled.csv");
alpha_CFD_BWB = polar_CFD_BWB.alpha;
CD_CFD_BWB = polar_CFD_BWB.CD;
CL_CFD_BWB = polar_CFD_BWB.CL;

%% BWB AVL Polar with e
% No parasitic drag AVL file (No CDCL)

[alpha_AVL, CL_AVL, ~, e_AVL] = readPolarAndEFromFile( ...
    "/Users/michaelchen/Documents/M-Fly/2023/MX-9/PA_Trade3/PolarNoParasitic/data.ft");

%% Splines for cruise velocity and MTOW
thrustCurve = @(v) (50.9 - 1.0 * v - 0.0344 * v.^2) * (rho / 1.254).^(1/3);
[cruiseVelSplineBWB, MTOWSplineBWB] = findMTOWCruiseVel(alpha_CFD_BWB, CL_CFD_BWB, CD_CFD_BWB, thrustCurve, rho, sref);

%% BWB MX-9 Sizing

alpha = 5;

weights = 40.0954372 * 0.453592 * 9.81;
thrust = 50.9 * (rho / 1.254).^(1/3);

CL_CFD_BWB_spline = spline(alpha_CFD_BWB, CL_CFD_BWB);
CD_CFD_BWB_spline = spline(alpha_CFD_BWB, CD_CFD_BWB);

alphaStall = 12.5781; % From AVL No CLAF
% alphaStall = 17; % From AVL with CLAF
CLMax = ppval(CL_CFD_BWB_spline, alphaStall);
CDStall = ppval(CD_CFD_BWB_spline, alphaStall);

vCruise = ppval(cruiseVelSplineBWB, alpha); % m/s

% parasitic_CFD = readtable( ...
%     "/Users/michaelchen/Documents/M-Fly/2023/CFD/Polars/Scaled/BWB/BWB_parasitic_drag_polar_scaled.csv");
parasitic_CFD = readtable( ...
    "/Users/michaelchen/Documents/M-Fly/2023/CFD/Polars/Scaled/10prism/BWB/BWB_parasitic_drag_polar_scaled.csv");
alpha_parasitic_CFD = parasitic_CFD.alpha;
CDp_CFD = parasitic_CFD.CDp;

CDp_CFD_spline = spline(alpha_parasitic_CFD, CDp_CFD);
CD0 = ppval(CDp_CFD_spline, alpha);

e_AVL_spline = spline(CL_AVL, e_AVL);
e = ppval(e_AVL_spline, ppval(CL_CFD_BWB_spline, alpha));

dTO = 121.92; % m

figure(1);
sizingPlot(weights, thrust, 1.14, CLMax, CDStall, thrustCurve, sref, vCruise, CD0, AR, e, dTO, true);
title("MX-9 Sizing Plot")

%%
%% Formatting for Latex

set(groot,'defaultLineLineWidth',0.5)
set(groot,'defaultTextInterpreter','latex')
set(groot,'defaultAxesTitleFontSize',1)
set(groot,'defaultAxesLabelFontSize',1)
set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultTextFontSize',14)
set(groot,'defaultAxesFontSize',14)
set(groot,'defaultLegendInterpreter','latex')

text(1.3,0.4,{'Feasible'; 'Region'},'HorizontalAlignment','center','VerticalAlignment','middle')
text(4,0.075,'Infeasible Region','HorizontalAlignment','center','VerticalAlignment','middle')
% text(1.9533-0.4,0.336971,{'MTOW'; 'Design'; 'Point'},'HorizontalAlignment','right','VerticalAlignment','middle')
% hold on
% quiver(1.9533-0.35, 0.336971, 0.25, 0, 'off', 'filled', 'Color', 'k', 'ShowArrowHead', 'off', 'LineWidth', 1);

set(gcf, 'units', 'inches', 'position', [5 6 5 3.5]);

title('')
xlabel('W/S [$lb/in^{2}$]');
ylabel('T/W');
% legend('Stall', 'Takeoff', '$40^{\circ}$ Banked Turn', 'Cruise', '$5^{\circ}$ Climb', 'MTOW Design Point', 'Location', 'best', 'FontSize', 8);
legend('off')

% t=tiledlayout(2,3)

% for i = 1:length(alpha)
%     nexttile
%     % sizingPlot(weights(i), thrust, 1.14, CLMax, CDStall, thrustCurve, sref, vCruise(i), CD0(i), AR, e(i), dTO, true);
%     sizingPlot(weights, thrust, 1.14, CLMax, CDStall, thrustCurve, sref, vCruise(i), CD0(i), AR, e(i), dTO, true);
%     title(strcat([string(alpha(i)) + " deg, " + string(weights / 9.81 * 2.20462) + " lb, ", string(vCruise(i)), " m/s"]))
% end

%% Box-and-wing Sizing Plot

%% Aircraft Parameters and atmosphere

b = 3.0328; % m
sref = 1.5646; % m^2
AR = b^2 / sref;
rho = 1.14; % kg/m^3

%% Box MX-9 CFD Polar

% -5 to 15 deg
polar_CFD_Box = readtable("/Users/michaelchen/Documents/M-Fly/2023/CFD/Polars/Scaled/10prism/Box/Box_drag_polar_scaled.csv");
alpha_CFD_Box = polar_CFD_Box.alpha;
CD_CFD_Box = polar_CFD_Box.CD;
CL_CFD_Box = polar_CFD_Box.CL;

%% Box AVL Polar with e
% No parasitic drag AVL file (No CDCL)

[alpha_AVL, CL_AVL, ~, e_AVL] = readPolarAndEFromFile( ...
    "/Users/michaelchen/Documents/M-Fly/2023/CFD/Polars/BoxWingPolarNoParasitic/data.ft");

%% Splines for cruise velocity and MTOW
thrustCurve = @(v) (50.9 - 1.0 * v - 0.0344 * v.^2) * (rho / 1.254).^(1/3);
[cruiseVelSplineBox, MTOWSplineBox] = findMTOWCruiseVel(alpha_CFD_Box, CL_CFD_Box, CD_CFD_Box, thrustCurve, rho, sref);

%% Box Sizing

alpha = 5;

weights = 32.8846468 * 0.453592 * 9.81;
thrust = 50.9 * (rho / 1.254).^(1/3);

CL_CFD_Box_spline = spline(alpha_CFD_Box, CL_CFD_Box);
CD_CFD_Box_spline = spline(alpha_CFD_Box, CD_CFD_Box);

alphaStall = 14.2969; % From AVL No CLAF
% alphaStall = 17.6837; % AVL with CLAF
CLMax = ppval(CL_CFD_Box_spline, alphaStall);
CDStall = ppval(CD_CFD_Box_spline, alphaStall);

vCruise = ppval(cruiseVelSplineBox, alpha); % m/s

parasitic_CFD = readtable( ...
    "/Users/michaelchen/Documents/M-Fly/2023/CFD/Polars/Scaled/10prism/Box/Box_parasitic_drag_polar_scaled.csv");
alpha_parasitic_CFD = parasitic_CFD.alpha;
CDp_CFD = parasitic_CFD.CDp;

CDp_CFD_spline = spline(alpha_parasitic_CFD, CDp_CFD);
CD0 = ppval(CDp_CFD_spline, alpha);

e_AVL_spline = spline(CL_AVL, e_AVL);
e = ppval(e_AVL_spline, ppval(CL_CFD_Box_spline, alpha));

dTO = 121.92; % m

figure(2);
sizingPlot(weights, thrust, 1.14, CLMax, CDStall, thrustCurve, sref, vCruise, CD0, AR, e, dTO, true);
title("Box-and-wing Sizing Plot")

%% Formatting for Latex

set(groot,'defaultLineLineWidth',0.5)
set(groot,'defaultTextInterpreter','latex')
set(groot,'defaultAxesTitleFontSize',1)
set(groot,'defaultAxesLabelFontSize',1)
set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultTextFontSize',14)
set(groot,'defaultAxesFontSize',14)
set(groot,'defaultLegendInterpreter','latex')

text(1.3,0.4,{'Feasible'; 'Region'},'HorizontalAlignment','center','VerticalAlignment','middle')
text(4,0.075,'Infeasible Region','HorizontalAlignment','center','VerticalAlignment','middle')
% text(1.9533-0.4,0.336971,{'MTOW'; 'Design'; 'Point'},'HorizontalAlignment','right','VerticalAlignment','middle')
% hold on
% quiver(1.9533-0.35, 0.336971, 0.25, 0, 'off', 'filled', 'Color', 'k', 'ShowArrowHead', 'off', 'LineWidth', 1);

set(gcf, 'units', 'inches', 'position', [5 6 5 3.5]);

title('')
xlabel('W/S [$lb/in^{2}$]');
ylabel('T/W');
legend('Stall', 'Takeoff', '$40^{\circ}$ Banked Turn', 'Cruise', '$5^{\circ}$ Climb', 'MTOW Design Point', 'FontSize', 11);
legend('boxoff');

% t=tiledlayout(2,3)

% for i = 1:length(alpha)
%     nexttile
%     % sizingPlot(weights(i), thrust, 1.14, CLMax, CDStall, thrustCurve, sref, vCruise(i), CD0(i), AR, e(i), dTO, true);
%     sizingPlot(weights, thrust, 1.14, CLMax, CDStall, thrustCurve, sref, vCruise(i), CD0(i), AR, e(i), dTO, true);
%     title(strcat([string(alpha(i)) + " deg, " + string(weights / 9.81 * 2.20462) + " lb, ", string(vCruise(i)), " m/s"]))
% end