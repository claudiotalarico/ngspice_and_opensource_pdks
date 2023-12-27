% File: test_lookup_ngspice.m
% Test script for function "look_up"
clearvars;
close all;

addpath('../class/gmidLUTs/;../class/gmidTECHs/')

%-------------------------------------------%
% sky130 nMOS (characterized using ngspice) %
%-------------------------------------------%
load('nch130.mat')
%load('180nch.mat')
%load('180nch_e.mat')
display(nch)
device = nch;
L = device.L;

% Plot ID vs. VDS
vds = device.VDS;
vgs = 0.7:0.1:0.9;
ID = look_up(device, 'ID', 'VDS', vds, 'VGS', vgs, 'VSB', 1);
figure;
plot(vds, ID*1e6, 'linewidth',2);
ylabel('I_D (\muA)');
xlabel('V_D_S (V)');
str1 = sprintf('I_D_n vs. V_D_S_n for L = %.2f um (nMOS)', L(1));
title(str1,'Fontsize',14);

warning('off','all'); % turn  off warnings due to legend

[m,n] = size(vgs);
for i=1:n
  legstr{i} = ['vgs = ',num2str(vgs(1,i)), ' V']; 
end
H = legend(legstr,'Location','best')
H.FontSize = 12;
legend boxoff;
% grid;

% Plot ft vs. gm_id for different L
gm_id = 5:0.1:20;
Lvec = min(L):0.05:0.3;
ft = look_up(device, 'GM_CGG', 'GM_ID', gm_id, 'L', Lvec)/2/pi;
figure;
plot(gm_id, ft*1e-9, 'linewidth',2);
xlabel('G_m/I_D (S/A)')
ylabel('f_T (Ghz)')
str1 = sprintf('f_T vs. G_m/I_D for different L (nMOS)');
title(str1,'Fontsize',14);
n = length(Lvec);
for i=1:n
  legstr{i} = ['L = ',num2str(Lvec(i)), ' \mum']; 
end
H = legend(legstr,'Location','best')
H.FontSize = 12;
legend boxoff;

% Plot gm/gds vs. gm/ID at minimum L and default VDS (=VDD/2)
gm_id = 5:0.1:20;
gm_gds = look_up(device, 'GM_GDS', 'GM_ID', gm_id);
figure;
plot(gm_id, gm_gds, 'linewidth', 2);
xlabel('G_m/I_D (S/A)')
ylabel('G_m/G_D_S (V/V)')
str1 = sprintf('intrinsic gain (G_m/G_d_s) vs. G_m/I_D at minimum L and V_D_S=0.9V (nMOS)');
title(str1,'Fontsize',14);

% Plot JD vs. gm_id for different L
gm_id = 5:0.1:20;
Lvec = min(L):0.05:0.3;
JD = look_up(device, 'ID_W', 'GM_ID', gm_id, 'L', Lvec);
figure;
semilogy(gm_id, JD, 'linewidth',2);
xlabel('G_m/I_D (S/A)')
ylabel('I_D / W (A/m)')
str1 = sprintf('Current Density (I_D/W) vs. G_m/I_D for different L (nMOS)');
title(str1,'Fontsize',14);
n = length(Lvec);
for i=1:n
  legstr{i} = ['L = ',num2str(Lvec(i)), ' \mum']; 
end
H = legend(legstr,'Location','best')
H.FontSize = 12;
legend boxoff;

% Plot JD vs. gm_id for different VDS at minimum L
gm_id = 5:0.1:20;
JD = look_up(device, 'ID_W', 'GM_ID', gm_id, 'VDS', [0.8 1.0 1.2]);
figure;
semilogy(gm_id, JD, 'linewidth',2);
xlabel('G_m/I_D (S/A)')
ylabel('I_D / W (A/m)')
str1 = sprintf('Current Density (I_D/W) vs. G_m/I_D for V_D_S at minimum L (nMOS)');
title(str1,'Fontsize',14);
H = legend ('VDS = 0.8V', 'VDS = 1.0V', 'VDS = 1.2V', 'location', 'best')
H.FontSize = 12;
legend boxoff;

% plot VT vs. L
vt = look_up(device, 'VT', 'VGS', 0.9, 'L', L);
figure;
plot(L,vt, 'linewidth',2);
ylabel('V_T (v)')
xlabel('L (\mum)')
title('Threshold Voltage vs. L at V_D_S=0.9V and V_G_S= 0.9V (nmos)','Fontsize',14);


%-------------------------------------------%
% sky130 pMOS (characterized using ngspice) %
%-------------------------------------------%
load('pch130.mat')
% load('180pch.mat')
%load('180pch_e.mat')
device = pch;
L = device.L;

% Plot ID vs. VDS
vds = device.VDS;
vsb = device.VSB;
vgs = 0.7:0.1:0.9;
%vgs = 0.9
ID = look_up(device, 'ID', 'VDS', vds, 'VGS', vgs, 'VSB',1);
figure;
plot(vds, ID*1e6, 'linewidth',2);
ylabel('I_D (\muA)')
xlabel('V_D_S (V)');
str1 = sprintf('I_D_p vs. V_D_S_p for L = %.2f um (pMOS)', L(1));
title(str1,'Fontsize',14);
for i=1:length(vgs)
  legstr{i} = ['vgs = ',num2str(vgs(1,i)), ' V']; 
end
H = legend(legstr,'Location','best')
H.FontSize = 12;
legend boxoff;

% Plot ft vs. gm_id for different L
% gm_id = 5:0.1:20; % above gm/id 13.5 the pmos goes crazy
gm_id = 5:0.1:13.5;
Lvec = min(L):0.05:0.3;
ft = look_up(device, 'GM_CGG', 'GM_ID', gm_id, 'L', Lvec)/2/pi;
figure;
plot(gm_id, ft*1e-9, 'linewidth',2);
xlabel('G_m/I_D (S/A)')
ylabel('f_T (Ghz)')
str1 = sprintf('f_T vs. G_m/I_D for different L (pMOS)');
title(str1,'Fontsize',14);
n = length(Lvec);
for i=1:n
    legstr{i} = ['L = ',num2str(Lvec(i)), ' \mum']; 
end
H = legend(legstr,'Location','best')
H.FontSize = 12;
legend boxoff;

% Plot gm/gds vs. gm/ID at minimum L and default VDS (=VDD/2)
% gm_id = 5:0.1:20; % above gm/id 13.5 the pmos goes crazy !
gm_id = 5:0.1:13.5;
gm_gds = look_up(device, 'GM_GDS', 'GM_ID', gm_id);
figure;
plot(gm_id, gm_gds, 'linewidth', 2);
xlabel('G_m/I_D (S/A)')
ylabel('G_m/G_D_S (V/V)')
str1 = sprintf('intrinsic gain (G_m/G_d_s) vs. G_m/I_D at minimum L and V_D_S=0.9V (pMOS)');
title(str1,'Fontsize',14);

% Plot JD vs. gm_id for different L
% gm_id = 5:0.1:20; % above gm/id 13.5 the pmos goes crazy !
gm_id = 5:0.1:13.5;
Lvec = min(L):0.05:0.3;
JD = look_up(device, 'ID_W', 'GM_ID', gm_id, 'L', Lvec);
figure;
semilogy(gm_id, JD, 'linewidth',2);
xlabel('G_m/I_D (S/A)')
ylabel('I_D / W (A/m)')
str1 = sprintf('Current Density (I_D/W) vs. G_m/I_D for different L (pMOS)');
title(str1,'Fontsize',14);
n = length(Lvec);
for i=1:n
  legstr{i} = ['L = ',num2str(Lvec(i)), ' \mum']; 
end
H = legend(legstr,'Location','best')
H.FontSize = 12;
legend boxoff;

% Plot JD vs. gm_id for different VDS at minimum L
% gm_id = 5:0.1:20; % above gm_is 13.5 the pmos goes crazy
gm_id = 5:0.1:13.5;
JD = look_up(device, 'ID_W', 'GM_ID', gm_id, 'VDS', [0.8 1.0 1.2]);
figure;
semilogy(gm_id, JD, 'linewidth',2);
xlabel('G_m/I_D (S/A)')
ylabel('I_D / W (A/m)')
str1 = sprintf('Current Density (I_D/W) vs. G_m/I_D for different V_D_S at minimum L (pMOS)');
title(str1,'Fontsize',14);
H = legend ('VDS = 0.8V', 'VDS = 1.0V', 'VDS = 1.2V', 'location', 'best')
H.FontSize = 12;
legend boxoff;

% plot VT vs. L
vt = look_up(device, 'VT', 'VGS', 0.9, 'L', L);
figure;
plot(L,vt, 'linewidth',2);
ylabel('V_T (v)')
xlabel('L (\mum)')
title('Threshold Voltage vs. L at V_D_S=0.9V and V_G_S= 0.9V (pmos)','Fontsize',14);