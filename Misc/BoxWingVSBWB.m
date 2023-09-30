%% AVL Polar MX-9

[alpha_AVL, CL_AVL, CD_AVL] = AVLDragPolar("/Users/michaelchen/Documents/M-Fly", ...
    "/Users/michaelchen/Documents/M-Fly/2023/MX-9/PA_Trade2_refinement/MX-9B1.avl", ...
    "/Users/michaelchen/Documents/M-Fly/2023/MX-9/PA_Trade2_refinement/Polar", ...
    [""], ...
    -5, ...
    15, ...
    NaN);

%% Box Wing CFD Polar

polar_CFD_Box = readtable("/Users/michaelchen/Documents/M-Fly/2023/CFD/Polars/CFD Polars for MX-9 and QM-3 - Box Wing w_ PADA.csv");
alpha_CFD_Box = polar_CFD_Box.alpha;
CD_CFD_Box = polar_CFD_Box.CD * 2;
CL_CFD_Box = polar_CFD_Box.CL;

%% BWB MX-9 CFD Polar

polar_CFD_BWB = readtable("/Users/michaelchen/Documents/M-Fly/2023/CFD/Polars/CFD Polars for MX-9 and QM-3 - MX-9.csv");
alpha_CFD_BWB = polar_CFD_BWB.alpha;
CD_CFD_BWB = polar_CFD_BWB.CD * 2;
CL_CFD_BWB = polar_CFD_BWB.CL;

%% Plot polars
figure(1);
plot(CD_CFD_Box, CL_CFD_Box, "o", CD_CFD_BWB, CL_CFD_BWB, "x", LineWidth=3);
legend("Box Wing w/ PADA", "BWB")

%% Plot polars BWB
figure(1);
plot(CD_AVL, CD_AVL, "o", CD_CFD_BWB, CL_CFD_BWB, "x", LineWidth=3);
legend("Box Wing w/ PADA", "BWB")
%%
thrustCurve = @(v) 52.6 - 1.71 .* v;
[cruiseVelSplineBox, MTOWSplineBox] = findMTOWCruiseVel(alpha_CFD_Box, CL_CFD_Box, CD_CFD_Box, thrustCurve, 1.14, 1.6802);
[cruiseVelSplineBWB, MTOWSplineBWB] = findMTOWCruiseVel(alpha_CFD_BWB, CL_CFD_BWB, CD_CFD_BWB, thrustCurve, 1.14, 1.4976);

a = linspace(-5, 15, 50);

figure(2);
yyaxis left
plot(a, ppval(cruiseVelSplineBox, a), LineWidth=2);
hold on;
plot(a, ppval(cruiseVelSplineBWB, a), LineWidth=2);

xlabel("Angle of attack (deg)");
ylabel("Cruise velocity (m/s)")

yyaxis right
plot(a, ppval(MTOWSplineBox, a) .* 2.20462, LineWidth=2);
plot(a, ppval(MTOWSplineBWB, a) .* 2.20462, LineWidth=2);
ylabel("MTOW (lb)")

legend("Box Wing w/ PADA", "BWB");

yline(30);

%% Difference in MTOW and Velocity
cruiseVel_Box = ppval(cruiseVelSplineBox, a);
cruiseVel_BWB = ppval(cruiseVelSplineBWB, a);

MTOW_Box = ppval(MTOWSplineBox, a);
MTOW_BWB = ppval(MTOWSplineBWB, a);

MTOW_diff_percent = MTOW_BWB ./ MTOW_Box;
disp(max(MTOW_diff_percent));

%% Plot force polar 13 m/s
D_Box = 0.5 * CD_CFD_Box * 1.14 * 13^2 * 1.6802;
L_Box = 0.5 * CL_CFD_Box * 1.14 * 13^2 * 1.6802;

D_BWB = 0.5 * CD_CFD_BWB * 1.14 * 13^2 * 1.4976;
L_BWB = 0.5 * CL_CFD_BWB * 1.14 * 13^2 * 1.4976;

figure(3);
plot(D_Box, L_Box, "o", D_BWB, L_BWB, "x", LineWidth=3);
legend("Box Wing w/ PADA", "BWB");
xlabel("Drag (N)");
ylabel("Lift (N)");