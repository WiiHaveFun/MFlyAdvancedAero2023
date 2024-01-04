%% MX-9 Sizing Plot

%% Aircraft Parameters and atmosphere

b = 3.0328; % m
sref = 1.5652; % m^2
AR = b^2 / sref;
rho = 1.14; % kg/m^3

%% BWB MX-9 CFD Polar

% -5 to 15 deg
polar_CFD_BWB = readtable("/Users/michaelchen/Documents/M-Fly/2023/CFD/Polars/Scaled/MX-9D_drag_polar_scaled.csv");
alpha_CFD_BWB = polar_CFD_BWB.alpha;
CD_CFD_BWB = polar_CFD_BWB.CD;
CL_CFD_BWB = polar_CFD_BWB.CL;

%% BWB AVL Polar with e
% No parasitic drag AVL file (No CDCL)

[alpha_AVL, CL_AVL, ~, e_AVL] = readPolarAndEFromFile( ...
    "/Users/michaelchen/Documents/M-Fly/2023/MX-9/PA_TipChordChangeAndStraightAileron/D1_polar/data.ft");

%% Splines for cruise velocity and MTOW
thrustCurve = @(v) (50.9 - 1.0 * v - 0.0344 * v.^2) * (rho / 1.254).^(1/3);
[cruiseVelSplineBWB, MTOWSplineBWB] = findMTOWCruiseVel(alpha_CFD_BWB, CL_CFD_BWB, CD_CFD_BWB, thrustCurve, rho, sref);

%% MX-9 Sizing

alpha = 5;

weights = 33 * 0.453592 * 9.81;
thrust = 50.9 * (rho / 1.254).^(1/3);

CL_CFD_BWB_spline = spline(alpha_CFD_BWB, CL_CFD_BWB);
CD_CFD_BWB_spline = spline(alpha_CFD_BWB, CD_CFD_BWB);

alphaStall = 13.2031; % From AVL No CLAF
% alphaStall = 17; % From AVL CLAF
CLMax = ppval(CL_CFD_BWB_spline, alphaStall);
CDStall = ppval(CD_CFD_BWB_spline, alphaStall);

vCruise = ppval(cruiseVelSplineBWB, alpha); % m/s

parasitic_CFD = readtable( ...
    "/Users/michaelchen/Documents/M-Fly/2023/CFD/Polars/Scaled/MX-9D_parasitic_drag_polar_scaled.csv");
alpha_parasitic_CFD = parasitic_CFD.alpha;
CDp_CFD = parasitic_CFD.CDp;

CDp_CFD_spline = spline(alpha_parasitic_CFD, CDp_CFD);
CD0 = ppval(CDp_CFD_spline, alpha);

e_AVL_spline = spline(CL_AVL, e_AVL);
e = ppval(e_AVL_spline, ppval(CL_CFD_BWB_spline, alpha));

dTO = 121.92; % m

sizingPlot(weights, thrust, 1.14, CLMax, CDStall, thrustCurve, sref, vCruise, CD0, AR, e, dTO, true);
title("MX-9 Sizing Plot")
% t=tiledlayout(2,3)

% for i = 1:length(alpha)
%     nexttile
%     % sizingPlot(weights(i), thrust, 1.14, CLMax, CDStall, thrustCurve, sref, vCruise(i), CD0(i), AR, e(i), dTO, true);
%     sizingPlot(weights, thrust, 1.14, CLMax, CDStall, thrustCurve, sref, vCruise(i), CD0(i), AR, e(i), dTO, true);
%     title(strcat([string(alpha(i)) + " deg, " + string(weights / 9.81 * 2.20462) + " lb, ", string(vCruise(i)), " m/s"]))
% end