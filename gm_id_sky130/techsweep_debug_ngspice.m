% Claudio Talarico
% Gonzaga University
% 2023/11/26
% adapated from B. Murmann script
% Stanford University
% September 12, 2017

clearvars;
clc;
close all;

% Load configuration on "empty stomach" just to check the dimension of 
% the sweeps
c = techsweep_cfg_bsim4_sky130_ngspice(0,0);

disp(sprintf('values of L: %d',c.nL))
disp(sprintf('values of VSB %d',c.nVSB))


% Path to HSPICE toolbox
addpath('../HspiceToolbox')

% Write simulation parameters
fid=fopen('techsweep_params.sp', 'w');
fprintf(fid,'.param length = %d\n', c.LENGTH(1));

% The default value of c.VSB(1) = 0
disp(sprintf('\ndefault VBS = %.2f\n', c.VSB(1)));
fprintf(fid,'.param sb = %d\n', c.VSB(1));
fclose(fid);

% create netlist for simulation 
c = techsweep_cfg_bsim4_sky130_ngspice(1,1);
c.VSB(1) = 1; % overwrite the default VSB 
disp(sprintf('simulation for L=%d VSB=%d', c.LENGTH(1), c.VSB(1)));

tic;
% Run simulator
[status,result] = system(c.simcmd);
if(status)
    disp('Simulation did not run properly. Check techsweep.out.');
    return;
end
disp(c.outfile_n)
disp(c.outfile_p)
toc;


% Read and display results 
hn = loadsig(c.outfile_n);
lssig(hn)
hp = loadsig(c.outfile_p);
lssig(hp)

% Display data for middle of sweep
idx1 = round(length(c.VGS)/2)
idx2 = round(length(c.VDS)/2)
s = sprintf('Data for VGS = %d, VDS = %d, VSB = %d, L = %d', ...
    c.VGS(idx1), c.VDS(idx2), c.VSB(1), c.LENGTH(1));

% Read and display raw parameters and created output
for k = 1:length(c.nvars)
    values = evalsig(hn, c.nvars{k}); % original line
    s = sprintf('%s = %d', c.nvars{k}, values(idx1, idx2));
    disp(s);
    nch.(c.outvars{k}) = values(idx1, idx2);
end

disp(nch);

for k = 1:length(c.pvars)
    values = evalsig(hp, c.pvars{k});
    s = sprintf('%s = %d', c.pvars{k}, values(idx1, idx2));
    disp(s);
    pch.(c.outvars{k}) = values(idx1, idx2);
end

disp(pch);


%
% NMOS
%

% gm/id Plot for NMOS
vgn = evalsig(hn, 'vg_n');
gm = evalsig(hn, 'gm_n');
id = evalsig(hn, 'i_id_n');
vt = evalsig(hn, 'vth_n');
figure;
plot(vgn, gm./id,'linewidth',2);
title('GM/ID vs. VGS - Sky130 NMOS','Fontsize',14);

figure;
plot(vgn, id,'linewidth',2);
title('ID vs. VGS - Sky130 NMOS','Fontsize',14);

% print VTH
disp(sprintf('at VGS = 0.9 and VDS = 0.9, VTH_n = %.3e (V)\n', vt(37,37)));

%
% PMOS
%

% gm/id Plot for PMOS
vgp = -evalsig(hp, 'vg_p'); % must change orientation
VGP = vgp(:,1);
gm = evalsig(hp, 'gm_p');
id = evalsig(hp, 'i_id_p');
vt = evalsig(hp, 'vth_p');

figure;
plot(VGP, gm./id, 'linewidth',2); %
title('GM/ID vs. VGS - Sky130 PMOS','Fontsize',14);

figure;
plot(VGP, id, 'linewidth',2);     %
title('ID vs. VGS - Sky130 PMOS','Fontsize',14);

% print VTH
disp(sprintf('at VSG = 0.9 and VSD = 0.9, VTH_p = %.3e (V)\n', vt(37,37)));
