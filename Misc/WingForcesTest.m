%%
[y1, L1] = getDistribution("/Users/michaelchen/Documents/M-Fly/2023/MX-9/PA_TipChordChangeAndStraightAileron/cruise_full.fs", 1, 1.14, 13.87, true);
hold on
[y2, L2] = getDistribution("/Users/michaelchen/Documents/M-Fly/2023/MX-9/PA_TipChordChangeAndStraightAileron/cruise_full.fs", 2, 1.14, 13.87, true);
[y3, L3] = getDistribution("/Users/michaelchen/Documents/M-Fly/2023/MX-9/PA_TipChordChangeAndStraightAileron/cruise_full.fs", 3, 1.14, 13.87, true);
[y4, L4] = getDistribution("/Users/michaelchen/Documents/M-Fly/2023/MX-9/PA_TipChordChangeAndStraightAileron/cruise_full.fs", 4, 1.14, 13.87, true);

% L = (sum(L1) + sum(L2) + sum(L3) + sum(L4) + sum(L5)) / 9.81;

yW = [flip(y2), y1];
LW = [flip(L2), L1];

yT = [flip(y4), y3];
LT = [flip(L4), L3];

[y1_cent, F1] = getPointForce(y1, L1);
[y2_cent, F2] = getPointForce(-y2, L2);
[y3_cent, F3] = getPointForce(y3, L3);
[y4_cent, F4] = getPointForce(-y4, L4);

[yW_cent, FW] = getPointForce(yW, LW);
[yT_cent, FT] = getPointForce(yT, LT);

L = (F1 + F2 + F3 + F4) / 9.81;

%%
originalVector = [1, 2, 3, 4, 5];
windowSize = 2;

% Use the buffer function to create the smaller vectors
resultMatrix = buffer(originalVector, windowSize, windowSize-1, 'nodelay');

% Transpose the result matrix to get the desired orientation
resultMatrix = resultMatrix';

% Display the result
disp(resultMatrix);

%%
[y1, L1] = getDistribution("/Users/michaelchen/Documents/M-Fly/2023/MX-9/PA_TipChordChangeAndStraightAileron/cruise_full.fs", 1, 1.14, 13.87, true);
hold on
[y2, L2] = getDistribution("/Users/michaelchen/Documents/M-Fly/2023/MX-9/PA_TipChordChangeAndStraightAileron/cruise_full.fs", 2, 1.14, 13.87, true);
[y3, L3] = getDistribution("/Users/michaelchen/Documents/M-Fly/2023/MX-9/PA_TipChordChangeAndStraightAileron/cruise_full.fs", 3, 1.14, 13.87, true);
[y4, L4] = getDistribution("/Users/michaelchen/Documents/M-Fly/2023/MX-9/PA_TipChordChangeAndStraightAileron/cruise_full.fs", 4, 1.14, 13.87, true);

yW = [flip(y2), y1];
LW = [flip(L2), L1];

yT = [flip(y4), y3];
LT = [flip(L4), L3];

[yW_cent, FW] = getPointForces(yW, LW);
[yT_cent, FT] = getPointForces(yT, LT);

yyaxis right

for i = 1:length(yW_cent)
    plot([yW_cent(i), yW_cent(i)], [0, FW(i)], "-k");
end

for i = 1:length(yT_cent)
    plot([yT_cent(i), yT_cent(i)], [0, FT(i)], "-k");
end