% Matlab script for technology characterization
% C. Talarico
% Gonzaga University
% 2023/11/26
% 
% adapted from Boris Murmann script
% Stanford University
% September 12, 2017


clearvars;
clc;
close all;

% run once the configuration script on "empty" stomach just to get the 
% dimension of the sweeps 
c = techsweep_cfg_bsim4_sky130_ngspice(0,0);

disp(sprintf('number of length values: %d', c.nL));
disp(sprintf('number of VSB values: %d', c.nVSB));

% Path to HSPICE toolbox
addpath('../HspiceToolbox');

tic;
% Simulation loop
for i = 1:length(c.LENGTH)
    str=sprintf('------- L = %2.2f --------', c.LENGTH(i));
    disp(str);
    
    for j = 1:length(c.VSB)    
        % Write simulation parameters
        fid=fopen('techsweep_params.sp', 'w');
        fprintf(fid,'.param length = %d\n', c.LENGTH(i));
        fprintf(fid,'.param sb = %d\n', c.VSB(j));
        fclose(fid);
        
        % create netlist for simulation (i,j)
        c = techsweep_cfg_bsim4_sky130_ngspice(i,j)
        
        % Run simulator
        disp(sprintf('simulation for L=%d VSB=%d', c.LENGTH(i), c.VSB(j)));
        [status,result] = system(c.simcmd);
        if(status)
            disp('Simulation did not run properly. Check techsweep.out.')
            return;
        end
        
        %Read and store results 
        hn = loadsig(c.outfile_n);
        hp = loadsig(c.outfile_p); 
        for n = 1: length(c.outvars)
             nch.(c.outvars{n})(i,:,:,j)  = evalsig(hn, c.nvars{n});  
             pch.(c.outvars{n})(i,:,:,j)  = evalsig(hp, c.pvars{n}); 
         end
    end
end

% Include sweep info
nch.INFO   = c.modelinfo; 
nch.CORNER = c.corner; 
nch.TEMP   = c.temp; 
nch.VGS    = c.VGS';
nch.VDS    = c.VDS';
nch.VSB    = c.VSB';
nch.L      = c.LENGTH';
nch.W      = c.WIDTH;
nch.NFING  = c.NFING;

pch.INFO   = c.modelinfo;
pch.CORNER = c.corner; 
pch.TEMP   = c.temp; 
pch.VGS    = c.VGS';
pch.VDS    = c.VDS';
pch.VSB    = c.VSB';
pch.L      = c.LENGTH';
pch.W      = c.WIDTH;
pch.NFING  = c.NFING;

save(c.savefilen,'nch');
save(c.savefilep,'pch');
toc
