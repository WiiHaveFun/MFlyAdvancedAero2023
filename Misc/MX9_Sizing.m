%% MX-9 Sizing Plot
t = tiledlayout(1,2);
nexttile
%% BWB MX-9 CFD Polar

% -5 to 15 deg
polar_CFD_BWB = readtable("/Users/michaelchen/Documents/M-Fly/2023/CFD/Polars/CFD Polars for MX-9 and QM-3 - MX-9.csv");
alpha_CFD_BWB = polar_CFD_BWB.alpha;
CD_CFD_BWB = polar_CFD_BWB.CD * 2; % Double
CL_CFD_BWB = polar_CFD_BWB.CL;

%% BWB AVL Polar with e
% No parasitic drag AVL file (No CDCL)

[alpha_AVL, CL_AVL, CDi_AVL, e_AVL] = AVLDragPolarAndE("/Users/michaelchen/Documents/M-Fly", ...
    "/Users/michaelchen/Documents/M-Fly/2023/MX-9/PA_Trade3/MX-9C_NOCDCL.avl", ...
    "/Users/michaelchen/Documents/M-Fly/2023/MX-9/PA_Trade3/PolarNoParasitic", ...
    [""], ...
    -5, ...
    15, ...
    NaN);

%% Splines for cruise velocity and MTOW
% thrustCurve = @(v) 52.6 - 1.71 .* v;
thrustCurve = @(v) 48.9304 - 1.71 .* v;
[cruiseVelSplineBWB, MTOWSplineBWB] = findMTOWCruiseVel(alpha_CFD_BWB, CL_CFD_BWB, CD_CFD_BWB, thrustCurve, 1.14, 1.4976);

%% MX-9 Sizing

alpha = 5;

% weights = ppval(MTOWSplineBWB, alpha) * 9.81 - (4 * 0.453592 * 9.81); % Subtract some mass
weights = 33 * 0.453592 * 9.81;
thrust = 48.9304;

rho = 1.14; % kg/m^3

alphaStall = 12.5781; % From AVL No CLAF
CLMax = 1.7394; % From AVL No CLAF

CD_CFD_BWB_spline = spline(alpha_CFD_BWB, CD_CFD_BWB);
CDStall = ppval(CD_CFD_BWB_spline, alphaStall);

sref = 1.4976; % m^2

vCruise = ppval(cruiseVelSplineBWB, alpha); % m/s

CDi_AVL_spline = spline(alpha_AVL, CDi_AVL);
CD0 = ppval(CD_CFD_BWB_spline, alpha) - ppval(CDi_AVL_spline, alpha);

AR = 6.14;

e_AVL_spline = spline(alpha_AVL, e_AVL);
e = ppval(e_AVL_spline, alpha);

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

%% Box Wing Sizing

%% Box CFD Polar

%% Box Wing CFD Polar

% -5 to 15 deg
polar_CFD_Box = readtable("/Users/michaelchen/Documents/M-Fly/2023/CFD/Polars/CFD Polars for MX-9 and QM-3 - Fixed Box Wing w_ PADA.csv");
alpha_CFD_Box = polar_CFD_Box.alpha;
CD_CFD_Box = polar_CFD_Box.CD * 2;
CL_CFD_Box = polar_CFD_Box.CL;

%% Box Wing AVL Polar with e
% No parasitic drag AVL file (No CDCL)

[alpha_AVL_box, CL_AVL_box, CDi_AVL_box, e_AVL_box] = AVLDragPolarAndE("/Users/michaelchen/Documents/M-Fly", ...
    "/Users/michaelchen/Documents/M-Fly/2023/CFD/Polars/BoxWing.avl", ...
    "/Users/michaelchen/Documents/M-Fly/2023/CFD/Polars/BoxWingPolarNoParasitic", ...
    [""], ...
    -5, ...
    15, ...
    NaN);

%% Splines for cruise velocity and MTOW
% thrustCurve = @(v) 52.6 - 1.71 .* v;
thrustCurve = @(v) 48.9304 - 1.71 .* v;
[cruiseVelSplineBox, MTOWSplineBox] = findMTOWCruiseVel(alpha_CFD_Box, CL_CFD_Box, CD_CFD_Box, thrustCurve, 1.14, 1.5646);

%% Box Wing Sizing

alpha = 5;

% weights = ppval(MTOWSplineBox, alpha) * 9.81 - (9 * 0.453592 * 9.81); % Subtract some mass;
weights = 26 * 0.453592 * 9.81;
thrust = 48.9304;

rho = 1.14; % kg/m^3

alphaStall = 14.2969; % From AVL No CLAF
CLMax = 1.9837; % From AVL No CLAF

CD_CFD_Box_spline = spline(alpha_CFD_Box, CD_CFD_Box);
CDStall = ppval(CD_CFD_Box_spline, alphaStall);

sref = 1.5646; % m^2

vCruise = ppval(cruiseVelSplineBox, alpha); % m/s

CDi_AVL_box_spline = spline(alpha_AVL_box, CDi_AVL_box);
CD0 = ppval(CD_CFD_Box_spline, alpha) - ppval(CDi_AVL_box_spline, alpha);

AR = 5.87;

e_AVL_box_spline = spline(alpha_AVL_box, e_AVL_box);
e = ppval(e_AVL_box_spline, alpha);

dTO = 121.92; % m

sizingPlot(weights, thrust, 1.14, CLMax, CDStall, thrustCurve, sref, vCruise, CD0, AR, e, dTO, true);
title("Box-and-Wing Sizing Plot")
% t=tiledlayout(2,3)

% for i = 1:length(alpha)
%     nexttile
%     % sizingPlot(weights(i), thrust, 1.14, CLMax, CDStall, thrustCurve, sref, vCruise(i), CD0(i), AR, e(i), dTO, true);
%     sizingPlot(weights, thrust, 1.14, CLMax, CDStall, thrustCurve, sref, vCruise(i), CD0(i), AR, e(i), dTO, true);
%     title(strcat([string(alpha(i)) + " deg, " + string(weights() / 9.81 * 2.20462) + " lb, ", string(vCruise(i)), " m/s"]))
% end