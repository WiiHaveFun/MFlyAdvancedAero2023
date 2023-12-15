% Drag Polar using Lee Nicolai's White Paper

%% CH10 data Re=413842

polar_file = "/Users/michaelchen/Documents/M-Fly/2023/Airfoils/Analysis/For_Nicolai_White_Paper/CH10 (smoothed) 200_T1_Re0.414_M0.00_N9.0.csv";
polar_sec = readtable(polar_file, "Delimiter", ",");

alpha_sec = [polar_sec.alpha];
Cl_sec = [polar_sec.CL];
Cd_sec = [polar_sec.CD];

% Plot drag polar
figure(1);
plot(Cd_sec, Cl_sec, "-k", "LineWidth", 3);

% Plot CL vs. alpha
figure(2);
plot(alpha_sec, Cl_sec, "-k", "LineWidth", 3);

%% Estimate zero lift alpha

p = polyfit(alpha_sec(69:113), Cl_sec(69:113), 1);

fun = @(x) p(1) * x + p(2);
a0 = fzero(fun, 0);

x = a0:0.1:alpha_sec(69);
hold on
plot(x, polyval(p, x), "--b", "LineWidth", 3);

%% Calculate CLa (wing) (dCL/da, lift curve slope) from Cla (sectional/airfoil)

Cla = p(1) * 180/pi; % Convert to rad^-1

b = 3.0328; % Wing span (m)
S = (24 + 12) / 39.37 * 1.387; % Wing planform area (m^2) Excludes the blended fuselage
AR = b^2 / S;

CLa = Cla * AR / (2 + (4 + AR^2)^0.5);

%% Calculate CLmax from Clmax
Clmax = max(Cl_sec);
CLmax = 0.9 * Clmax;

yline(Clmax, "-k");
yline(CLmax, "-k");

%% Update plots

% Estimate stall angle (where CLmax occurs)
fun = @(x) (x - a0 * pi/180) * CLa - CLmax;
aCLmax = fzero(fun, 0) * 180/pi;

x = a0:aCLmax-1;
plot(x, (x - a0) * CLa * pi/180, "-r", "LineWidth", 3);

%% Calculate CLmin and CDmin from Clmin and Cdmin
Cdmin = min(Cd_sec);
Clmin = Cl_sec(Cd_sec == Cdmin);

CLmin = Clmin;
CDmin = Cdmin;

%% Calculate K''

Cl_minus_Clmin_squared = (Cl_sec(116:168) - Clmin).^2;

p2 = polyfit(Cl_minus_Clmin_squared, Cd_sec(116:168), 1);

K2 = p2(1);

figure(3);
plot(Cl_minus_Clmin_squared, Cd_sec(116:168), "-k", "LineWidth", 3);

%% Swet
Sref = 1.5652 * 39.37 * 39.37; % Reference area including the wing and fuselage. This is so reference area is same between polars
%% Fuselage
Re_fuselage = 1200000; % Assume turbulent BL

FR = 54 / 10; % Fineness ratio is uses a 10" diameter, an overestimate
FF_fuselage = 1 + 60 / FR^3 + 0.0025 * FR;

Cf_fuselage = 0.074 / Re_fuselage ^ 0.2;

Swet_fuselage = 1161.799; % in^2
% Sref_fuselage = 460.203; % in^2

CDmin_fuselage = FF_fuselage * Cf_fuselage * Swet_fuselage / Sref;

%% Wing
Re_wing = 410000;

FF_wing = (1 + 1.2 * 0.1284 + 100 * 0.1284^4) * 1.05;

Cf_wing = 0.074 / Re_wing^0.2;

Swet_wing = 2058.137 * 2; % in^2

CDmin_wing = FF_wing * Cf_wing * Swet_wing / Sref;

% Closely matches Cdmin from drag polar so
CDmin_wing = CDmin;

%% Horizontal Tail
Re_htail = 200000;

FF_htail = (1 + 2.0 * 0.12 + 100 * 0.12^4) * 1.05;

% Assume laminar
Cf_htail = 1.328 / Re_htail ^ 0.5;

Swet_htail = 874.907; % in^2

CDmin_htail = FF_htail * Cf_htail * Swet_htail / Sref;

%% Vertical Tail
Re_vtail = 200000;

FF_vtail = (1 + 2.0 * 0.12 + 100 * 0.12^4) * 1.05;

% Assume laminar
Cf_vtail = 1.328 / Re_htail ^ 0.5;

Swet_vtail = 409.844; % in^2

CDmin_vtail = FF_vtail * Cf_vtail * Swet_vtail / Sref;

%% Tail Boom
Re_boom = 1938000;

Cf_boom = 0.074 / Re_boom ^ 0.2;

Swet_boom = 155.179 + 314.569; % in^2

CDmin_boom = 1.05 * Cf_boom * Swet_boom / Sref;

%% Landing Gear

CDmin_gear = 2 * 1.01 * 2 / Sref;

%% Total CDmin

CDmin_tot = CDmin_fuselage + CDmin_wing + CDmin_htail + CDmin_vtail + CDmin_boom + CDmin_gear;

AR = 3.0328^2 / 1.5652; % Using fuselage and wing as reference area to match with other polars
K1 = 1 / (pi * AR * 0.956);
CDpolar = @(CL) CDmin_tot + K1 .* CL.^2 + K2 .* (CL - CLmin).^2;

figure(1);

plot(CDpolar(0:0.1:1.8), 0:0.1:1.8, "-k", "LineWidth", 3);