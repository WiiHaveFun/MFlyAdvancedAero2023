%% Drag/Thrust Required vs Velocity
polar_CFD_MX = readtable("/Users/michaelchen/Documents/M-Fly/2023/CFD/Polars/Scaled/MX-9D_drag_polar_scaled.csv");
alpha_CFD_MX = polar_CFD_MX.alpha;
CD_CFD_MX = polar_CFD_MX.CD;
CL_CFD_MX = polar_CFD_MX.CL;

%% Aircraft Parameters and Atmosphere
S = 1.5652; % m^2
W = 33 * 4.44822; % lbf to N

rho = 1.14; % kg/m^3

%%
Vmph = 24:36; % mph
Vmps = Vmph * 0.44704; % m/s

CL = 2 * W ./ (rho * Vmps.^2 * S);

CDfromCL_spline = spline(CL_CFD_MX, CD_CFD_MX);

CD = ppval(CDfromCL_spline, CL);

D = 0.5 * rho * Vmps.^2 .* CD * S;

%% Plots
ThrustCurve = @(v) (50.9 - 1.0 * v - 0.0344 * v.^2) * (1.14 / 1.254).^(1/3);

plot(Vmph, D ./ 4.44822);
hold on
plot(Vmph, ThrustCurve(Vmps) ./ 4.44822);

legend("Drag vs. Cruise Velocity", "Thrust Curve");
xlabel("Cruise Velocity (mph)");
ylabel("Drag (lbf)");
set(gca, "FontSize", 14);

%% Save
output = round([Vmph; D ./ 4.44822], 4);
T = array2table(output');
T.Properties.VariableNames = ["Cruise Velocity (mph)", "Drag (lbf)"];
writetable(T, 'MX-9D_Drag_vs_Cruise.csv');

%% PADA

%% Drag/Thrust Required vs Velocity
polar_CFD_QM = readtable("/Users/michaelchen/Documents/M-Fly/2023/CFD/Polars/Scaled/QM-3D_drag_polar_scaled.csv");
alpha_CFD_QM = polar_CFD_QM.alpha;
CD_CFD_QM = polar_CFD_QM.CD;
CL_CFD_QM = polar_CFD_QM.CL;

%% Aircraft Parameters and Atmosphere
S = 0.1043; % m^2
W = 1 * 4.44822; % lbf to N

rho = 1.14; % kg/m^3

%%
Vmph = 21:52; % mph
Vmps = Vmph * 0.44704; % m/s

CL = 2 * W ./ (rho * Vmps.^2 * S);

CDfromCL_spline = makima(CL_CFD_QM, CD_CFD_QM);

CD = ppval(CDfromCL_spline, CL);

D = 0.5 * rho * Vmps.^2 .* CD * S;

%% Plots
ThrustCurve = @(v) (3.63 - 0.0694 * v - 5.11e-4 * v.^2);

plot(Vmph, D ./ 4.44822 .* 16);
hold on
plot(Vmph, ThrustCurve(Vmps) ./ 4.44822 .* 16);

legend("Drag vs. Cruise Velocity", "Thrust Curve");
xlabel("Cruise Velocity (mph)");
ylabel("Drag (ozf)");
set(gca, "FontSize", 14);

%% Save
output = round([Vmph; D ./ 4.44822 .* 16], 4);
T = array2table(output');
T.Properties.VariableNames = ["Cruise Velocity (mph)", "Drag (ozf)"];
writetable(T, 'QM-3D_Drag_vs_Cruise.csv');