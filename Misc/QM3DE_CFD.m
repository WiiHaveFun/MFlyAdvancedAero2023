%% Aircraft Parameters

b = 28 / 39.37; % m
S = 0.1043; % m^2
AR = b^2 / S;

%% QM-3D/E CFD Polar

% -5 to 15 deg
polar_CFD = readtable("/Users/michaelchen/Documents/M-Fly/2023/CFD/Polars/CFD Polars for MX-9 and QM-3 - QM-3D.csv");
alpha_CFD = polar_CFD.alpha;
CD_CFD = polar_CFD.CD;
CL_CFD = polar_CFD.CL;

%% QM-3Etest AVL Polar with e

[alpha_AVL, CL_AVL, CD_AVL, e_AVL] = AVLDragPolarAndE("/Users/michaelchen/Documents/M-Fly", ...
    "/Users/michaelchen/Documents/M-Fly/2023/QM-3/PADA_Trade5/QM-3Etest.avl", ...
    "/Users/michaelchen/Documents/M-Fly/2023/QM-3/PADA_Trade5/TestPolar", ...
    [""], ...
    -5, ...
    15, ...
    NaN);

%% Splines

e_from_CL_AVL_spline = spline(CL_AVL, e_AVL);

polar_CFD_spline = spline(CL_CFD, CD_CFD);

%% CDp scale factor

CD_windtunnel = 0.0825;
CL_windtunnel = 0.5971;

CLi_windtunnel = CL_windtunnel^2 / (pi * AR * ppval(e_from_CL_AVL_spline, CL_windtunnel));

CDp_windtunnel = CD_windtunnel - CLi_windtunnel;
CDp_CFD = ppval(polar_CFD_spline, CL_windtunnel) - CLi_windtunnel;

CDp_scale_factor = CDp_windtunnel / CDp_CFD;

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
scatter(CD_windtunnel, CL_windtunnel, "filled");

xlabel("CD");
ylabel("CL");
legend("CFD", "CFD Scaled", "AVL", "Wind Tunnel");