%% MX-9C vs MX-9D

polar_CFD_C = readtable("/Users/michaelchen/Documents/M-Fly/2023/CFD/Polars/CFD Polars for MX-9 and QM-3 - MX-9.csv");
alpha_CFD_C = polar_CFD_C.alpha;
CD_CFD_C = polar_CFD_C.CD;
CL_CFD_C = polar_CFD_C.CL;

polar_CFD_D = readtable("/Users/michaelchen/Documents/M-Fly/2023/CFD/Polars/CFD Polars for MX-9 and QM-3 - MX-9D_partial.csv");
alpha_CFD_D = polar_CFD_D.alpha;
CD_CFD_D = polar_CFD_D.CD;
CL_CFD_D = polar_CFD_D.CL;

%% Plot

figure(1);
plot(CD_CFD_C, CL_CFD_C, "LineWidth", 3);
hold on
plot(CD_CFD_D, CL_CFD_D, "LineWidth", 3);

xlabel("CD");
ylabel("CL");
legend("MX-9C", "MX-9D");

figure(2);
plot(alpha_CFD_C, CL_CFD_C, "LineWidth", 3);
hold on
plot(alpha_CFD_D, CL_CFD_D, "LineWidth", 3);

figure(3);
plot(alpha_CFD_C, CD_CFD_C, "LineWidth", 3);
hold on
plot(alpha_CFD_D, CD_CFD_D, "LineWidth", 3);