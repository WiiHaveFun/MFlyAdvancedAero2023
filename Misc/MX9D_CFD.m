%% Aircraft Parameters

b = 3.0328; % m
S = 1.5652; % m^2
AR = b^2 / S;

%% QM-3D/E CFD Polar

% -5 to 15 deg
polar_CFD = readtable("/Users/michaelchen/Documents/M-Fly/2023/CFD/Polars/CFD Polars for MX-9 and QM-3 - MX-9D.csv");
alpha_CFD = polar_CFD.alpha;
CD_CFD = polar_CFD.CD;
CL_CFD = polar_CFD.CL;

%% QM-3Etest AVL Polar with e

% [alpha_AVL, CL_AVL, CD_AVL, e_AVL] = AVLDragPolarAndE("/Users/michaelchen/Documents/M-Fly", ...
%     "/Users/michaelchen/Documents/M-Fly/2023/MX-9/PA_TipChordChangeAndStraightAileron/MX-9D1.avl", ...
%     "/Users/michaelchen/Documents/M-Fly/2023/MX-9/PA_TipChordChangeAndStraightAileron/D1_polar", ...
%     [""], ...
%     -5, ...
%     15, ...
%     NaN);

[alpha_AVL, CL_AVL, CD_AVL, e_AVL] = readPolarAndEFromFile( ...
    "/Users/michaelchen/Documents/M-Fly/2023/MX-9/PA_TipChordChangeAndStraightAileron/D1_polar/data.ft");

%% Splines

e_from_CL_AVL_spline = spline(CL_AVL, e_AVL);

polar_CFD_spline = spline(CL_CFD, CD_CFD);

%% CDp scale factor

% CD_windtunnel = 0.0825;
% CL_windtunnel = 0.5971;
% 
% CLi_windtunnel = CL_windtunnel^2 / (pi * AR * ppval(e_from_CL_AVL_spline, CL_windtunnel));
% 
% CDp_windtunnel = CD_windtunnel - CLi_windtunnel;
% CDp_CFD = ppval(polar_CFD_spline, CL_windtunnel) - CLi_windtunnel;
% 
% CDp_scale_factor = CDp_windtunnel / CDp_CFD;

CDp_scale_factor = 2.5;

%% Scale CFD data

CDi_CFD = CL_CFD.^2 ./ (pi * AR * ppval(e_from_CL_AVL_spline, CL_CFD));

CDp_CFD_scaled = (CD_CFD - CDi_CFD) .* CDp_scale_factor;
CD_CFD_scaled = CDp_CFD_scaled + CDi_CFD;

%% Plot polars

figure(1);
plot(CD_CFD, CL_CFD, "LineWidth", 3);
hold on
plot(CD_CFD_scaled, CL_CFD, "LineWidth", 3);
plot(CD_AVL, CL_AVL, "LineWidth", 3);
% scatter(CD_windtunnel, CL_windtunnel, "filled");

title("MX-9 Drag Polars")
xlabel("C_{D}", "FontSize", 14);
ylabel("C_{L}", "FontSize", 14);
legend("CFD", "CFD Scaled", "AVL", Location="southeast");
xlim([0,0.5])
set(gca, "FontSize", 14);

figure(3);
plot(CD_CFD_scaled, CL_CFD, "LineWidth", 3);
hold on

pp = spline(CL_CFD, CD_CFD_scaled);
scatter(ppval(pp, 0.86), 0.86, 100, "filled");

r1 = 0.213:0.001:1.441;

% plot(ppval(pp, r1), r1, "LineWidth", 3);

LD = r1 ./ ppval(pp, r1);

[M, I] = max(LD);

scatter(ppval(pp, r1(I)), r1(I), 100, "filled");
% plot([0,0.4],[0,0.4*max(LD)], "LineWidth", 1, "Color", "k");


title("MX-9 Drag Polar")
xlabel("C_{D}");
ylabel("C_{L}");
xlim([0,0.5])
ylim([0,1.6])

legend("Polar", "Cruise Point", "Max L/D")
set(gca, "FontSize", 14);

%% Save scale polar to CSV
output = round([alpha_CFD, CL_CFD, CD_CFD_scaled], 4);
T = array2table(output);
T.Properties.VariableNames = ["alpha", "CL", "CD"];
writetable(T, 'MX-9D_drag_polar_scaled.csv');

output = round([alpha_CFD, CL_CFD, CDp_CFD_scaled], 4);
T = array2table(output);
T.Properties.VariableNames = ["alpha", "CL", "CDp"];
writetable(T, 'MX-9D_parasitic_drag_polar_scaled.csv');

%% [Extra stuff]
%% Thrust curve

throttle = 1.0; % Probably not very accurate
T = @(v) (50.9 - 1.0 * v - 0.0344 * v.^2) * (1.14 / 1.254).^(1/3) * throttle; % Thrust in N, velcity in m/s

%% Flight Test Parameters

W = 33; % lb

% p = 29.34 * 3386.39; % Station pressure in inHg converted to Pa. Barometric pressure of 30.10 inHg
% Temp = (46 - 32) * 5 / 9 + 273.15; % Temperature in deg F to K

% rho = p / (287 * Temp);

rho = 1.14;

%% Cruise velocity prediction

[ppCruiseVel, ppMTOW] = findMTOWCruiseVel(alpha_CFD, CL_CFD, CD_CFD_scaled, T, rho, S);

a = linspace(-5, 15, 50);

figure(2);
yyaxis left
plot(a, ppval(ppCruiseVel, a), LineWidth=2);
hold on;

xlabel("Angle of attack (deg)");
ylabel("Cruise velocity (m/s)");

yyaxis right
plot(a, ppval(ppMTOW, a) * 2.20462, LineWidth=2);
ylabel("MTOW (lb)")

yline(W);

%% Calculate cruise velocity

cruise_alpha = fzero(@(a) ppval(ppMTOW, a) * 2.20462 - W, 0);
cruise_velocity = ppval(ppCruiseVel, cruise_alpha);

disp("Cruise angle of attack (deg)");
disp(cruise_alpha);
disp("Cruise velocity (m/s)");
disp(cruise_velocity);