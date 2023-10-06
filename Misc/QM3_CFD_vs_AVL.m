%% AVL Polar
[alpha_AVL, CL_AVL, CD_AVL] = readPolarFromFile("/Users/michaelchen/Documents/M-Fly/2023/QM-3/PADA_Trade4/Polar/data.ft");
CD_AVL = CD_AVL * 2;
%% CFD Polar
polar = readtable("/Users/michaelchen/Documents/M-Fly/2023/CFD/Polars/CFD Polars for MX-9 and QM-3 - PADA.csv");
alpha_CFD = polar.alpha;
CD_CFD = polar.CD * 2;
CL_CFD = polar.CL;

%% Plot polars
figure(1);
plot(CD_AVL, CL_AVL, "o", CD_CFD, CL_CFD, "x", LineWidth=3);
legend("AVL", "CFD")
xlabel("C_{L}")
ylabel("C_{D}")
title("AVL vs CFD for early PADA design")
set(gca, "FontSize", 14);

%%
thrustCurve = @(v) 2.28 - 0.0335 * v - 2.53e-3 * v.^2;
[cruiseVelSpline, MTOWSpline] = findMTOWCruiseVel(alpha_AVL, CL_AVL, CD_AVL, thrustCurve, 1.14, 0.2865);
[cruiseVelSplineCFD, MTOWSplineCFD] = findMTOWCruiseVel(alpha_CFD, CL_CFD, CD_CFD, thrustCurve, 1.14, 0.2865);

a = linspace(-5, 20, 50);

figure(2);
yyaxis left
plot(a, ppval(cruiseVelSpline, a), LineWidth=2);
hold on;
plot(a, ppval(cruiseVelSplineCFD, a), LineWidth=2);

xlabel("Angle of attack (deg)");
ylabel("Cruise velocity (m/s)")

yyaxis right
plot(a, ppval(MTOWSpline, a) .* 2.20462, LineWidth=2);
plot(a, ppval(MTOWSplineCFD, a) .* 2.20462, LineWidth=2);
ylabel("MTOW (lb)")

legend("AVL", "CFD");

%%
figure(3);
plot(alpha_AVL, CL_AVL, "o", alpha_CFD, CL_CFD, "x", LineWidth=3);