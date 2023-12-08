% Configuration for techsweep_ngspice_run.m
% Claudio Talarico
% Gonzaga University
% 2023-11-21
% adapted from B. Murmann

% input netlist a quite a bit modified to match ngspice syntax (vs. hspice)

function c = techsweep_cfg_bsim4_sky130_ngspice(i,j)

% Model info and file paths
% macOS desktops:
c.modelfile = '/Users/talarico/share/pdk/sky130A/libs.tech/ngspice/sky130.lib.spice tt';
% macOS laptop:
% c.modelfile = '/Users/claudio/cad/PDKs/sky130A/libs.tech/ngspice/sky130.lib.spice tt';
c.modelinfo = 'Sky130 model, 130nm CMOS';
c.corner = 'tt';
c.temp = 300;
c.modeln = 'nch';
c.modelp = 'pch';
c.savefilen = 'nch130.mat';
c.savefilep = 'pch130.mat';
% macOS desktop:
c.simcmd = '/Users/talarico/opt/ngspice/bin/ngspice -b -o techsweep.out techsweep.sp';
% macOS laptop:
% c.simcmd = '/Users/claudio/opt/ngspice/bin/ngspice -b -o techsweep.out techsweep.sp';

% Sweep parameters
c.VGS_step = 25e-3;
c.VDS_step = 25e-3;
c.VSB_step = 100e-3;
c.VGS_max = 1.8;
c.VDS_max = 1.8;
c.VSB_max = 1.0;
c.VGS = 0:c.VGS_step:c.VGS_max;
c.VDS = 0:c.VDS_step:c.VDS_max;
c.VSB = 0:c.VSB_step:c.VSB_max;
c.LENGTH = [(0.15:0.02:0.5) (0.6:0.1:2.0)];
c.WIDTH = 10;
c.NFING = 1;

% Variable definitions
c.nvars = {'i_id_n','vth_n','gm_n','gmbs_n','gds_n','cgg_n','cgs_n','cgd_n','cgb_n','cdd_n','css_n'}; 
c.pvars = {'i_id_p','vth_p','gm_p','gmbs_p','gds_p','cgg_p','cgs_p','cgd_p','cgb_p','cdd_p','css_p'}; 
c.outvars = {'ID', 'VT', 'GM', 'GMBS', 'GDS', 'CGG', 'CGS', 'CGD', 'CGB', 'CDD', 'CSS'};

% dimension of the sweeps
c.nVGS  = length(c.VGS);
c.nVDS  = length(c.VDS);
c.nL    = length(c.LENGTH);
c.nVSB  = length(c.VSB);  

% output files
str_n = sprintf('./spiceout/nmos_%d_%d_sky130.raw',i,j);
str_p = sprintf('./spiceout/pmos_%d_%d_sky130.raw',i,j);
c.outfile_n = str_n;
c.outfile_p = str_p;


% The number of simulations to run is c.nL*c.nVBS 
% so neither i nor j can be 0
% 
if (i==0 || j==0)
    disp(sprintf('\nThe number of simulation to run cannot be 0'));
    disp(sprintf('Use the value of c.nL for i and c.nVBS for j\n'));
    return	
end	


% Simulation netlist
fid=fopen('techsweep.sp', 'w');
fprintf(fid,'techsweep.sp\n');
fprintf(fid,'.options nomod delmax=5p relv=1e-6 method=gear\n');
fprintf(fid,'.options ngbehavior=hsa\n');
fprintf(fid,'\n'); 
fprintf(fid,'.lib %s\n',c.modelfile);
fprintf(fid,'.temp %d\n',c.temp-273);
fprintf(fid,'\n');
fprintf(fid,'.global gnd\n');
fprintf(fid,'.param gs=1 ds=1\n');
fprintf(fid,'.inc techsweep_params.sp\n');
fprintf(fid,'.param mc_mm_switch=0\n');
fprintf(fid,'.param mc_pr_switch=1\n');
fprintf(fid,'\n');
fprintf(fid,'vnoi  vx  gnd  dc 0  ac 1 \n');
fprintf(fid,'vdsn  vdn vx   dc ''ds''  \n');
fprintf(fid,'vgsn  vgn gnd  dc ''gs''  \n');
fprintf(fid,'vbsn  vbn gnd  dc ''-sb'' \n');
fprintf(fid,'vsdp  vx  vdp  dc ''ds'' \n');   
fprintf(fid,'vsgp  gnd vgp  dc ''gs'' \n');   
fprintf(fid,'vsbp  gnd vbp  dc ''-sb''  \n');
fprintf(fid,'h1  vn  gnd  ccvs  vnoi  1 \n');
fprintf(fid,'r1  vn  gnd  100T noisy=0 \n');
fprintf(fid,'\n');
fprintf(fid,'xmn vdn vgn gnd vbn sky130_fd_pr__nfet_01v8 \n');
fprintf(fid,'+ L=''length'' W=10 nf=1 \n');
fprintf(fid,'+ ad=''int((nf+1)/2) * W/nf * 0.29'' \n');
fprintf(fid,'+ as=''int((nf+2)/2) * W/nf * 0.29'' \n');
fprintf(fid,'+ pd=''2*int((nf+1)/2) * (W/nf + 0.29)'' \n');
fprintf(fid,'+ ps=''2*int((nf+2)/2) * (W/nf + 0.29)'' \n');
fprintf(fid,'+ nrd=''0.29 / W'' nrs=''0.29 / W'' \n');
fprintf(fid,'+ sa=0 sb=0 sd=0 mult=1 m=1 \n');
fprintf(fid,'\n');
fprintf(fid,'xmp vdp vgp gnd vbp sky130_fd_pr__pfet_01v8 \n');
fprintf(fid,'+ L=''length'' W=10 nf=1 \n');
fprintf(fid,'+ ad=''int((nf+1)/2) * W/nf * 0.29'' \n');
fprintf(fid,'+ as=''int((nf+2)/2) * W/nf * 0.29'' \n');
fprintf(fid,'+ pd=''2*int((nf+1)/2) * (W/nf + 0.29)'' \n');
fprintf(fid,'+ ps=''2*int((nf+2)/2) * (W/nf + 0.29)'' \n');
fprintf(fid,'+ nrd=''0.29 / W'' nrs=''0.29 / W'' \n');
fprintf(fid,'+ sa=0 sb=0 sd=0 mult=1 m=1 \n');
fprintf(fid,'\n');
fprintf(fid,'.op ; needed to run ngspice in batch mode \n');
fprintf(fid,'\n');
fprintf(fid,'.control \n');
fprintf(fid,'save dc \n'); 
fprintf(fid,'+ v(vgn) v(vdn) \n');
fprintf(fid,'+ dc @m.xmn.msky130_fd_pr__nfet_01v8[vbs]\n');
fprintf(fid,'+ dc @m.xmn.msky130_fd_pr__nfet_01v8[vth]\n');
fprintf(fid,'+ dc @m.xmn.msky130_fd_pr__nfet_01v8[id]\n');
fprintf(fid,'+ dc @m.xmn.msky130_fd_pr__nfet_01v8[gm]\n');
fprintf(fid,'+ dc @m.xmn.msky130_fd_pr__nfet_01v8[gmbs]\n');
fprintf(fid,'+ dc @m.xmn.msky130_fd_pr__nfet_01v8[gds]\n');
fprintf(fid,'+ dc @m.xmn.msky130_fd_pr__nfet_01v8[cgg]\n');
fprintf(fid,'+ dc @m.xmn.msky130_fd_pr__nfet_01v8[cgs] \n');
fprintf(fid,'+ dc @m.xmn.msky130_fd_pr__nfet_01v8[csg] \n');
fprintf(fid,'+ dc @m.xmn.msky130_fd_pr__nfet_01v8[cgd] \n');
fprintf(fid,'+ dc @m.xmn.msky130_fd_pr__nfet_01v8[cdg] \n');
fprintf(fid,'+ dc @m.xmn.msky130_fd_pr__nfet_01v8[cgb] \n');
fprintf(fid,'+ dc @m.xmn.msky130_fd_pr__nfet_01v8[cbg] \n');
fprintf(fid,'+ dc @m.xmn.msky130_fd_pr__nfet_01v8[cds] \n');
fprintf(fid,'+ dc @m.xmn.msky130_fd_pr__nfet_01v8[cdb] \n');
fprintf(fid,'+ dc @m.xmn.msky130_fd_pr__nfet_01v8[cdd] \n');
fprintf(fid,'+ dc @m.xmn.msky130_fd_pr__nfet_01v8[css] \n');
fprintf(fid,'\n');
fprintf(fid,'run \n');
fprintf(fid,'dc vgsn 0 %0.1f %0.3f vdsn 0 %0.1f %0.3f \n', ...
    c.VGS_max,c.VGS_step,c.VDS_max,c.VDS_step);
fprintf(fid,'let vd_n=v(vdn) \n');
fprintf(fid,'let vg_n=v(vgn) \n');
fprintf(fid,'let vb_n=@m.xmn.msky130_fd_pr__nfet_01v8[vbs] \n');
fprintf(fid,'let vth_n=@m.xmn.msky130_fd_pr__nfet_01v8[vth] \n');
fprintf(fid,'let id_n=@m.xmn.msky130_fd_pr__nfet_01v8[id] \n');
fprintf(fid,'let gm_n=@m.xmn.msky130_fd_pr__nfet_01v8[gm] \n');
fprintf(fid,'let gmbs_n=@m.xmn.msky130_fd_pr__nfet_01v8[gmbs]\n');
fprintf(fid,'let gds_n=@m.xmn.msky130_fd_pr__nfet_01v8[gds] \n');
fprintf(fid,'let cgg_n=@m.xmn.msky130_fd_pr__nfet_01v8[cgg] \n');
fprintf(fid,'let cgs_n=-@m.xmn.msky130_fd_pr__nfet_01v8[csg] ;flip nodes\n');
fprintf(fid,'let cgd_n=-@m.xmn.msky130_fd_pr__nfet_01v8[cdg] ;flip nodes\n');
fprintf(fid,'let cgb_n=-@m.xmn.msky130_fd_pr__nfet_01v8[cbg] ;flip nodes\n');
fprintf(fid,'let cds_n=@m.xmn.msky130_fd_pr__nfet_01v8[cds] \n');
fprintf(fid,'let cdb_n=@m.xmn.msky130_fd_pr__nfet_01v8[cdb] \n');
fprintf(fid,'let cdd_n=cds_n - cdb_n + cgd_n \n');
fprintf(fid,'let css_n=@m.xmn.msky130_fd_pr__nfet_01v8[css] \n');
fprintf(fid,'\n');
fprintf(fid,'write ./spiceout/nmos_%d_%d_sky130.raw \n',i,j); 
fprintf(fid,'+ vd_n vg_n vb_n \n');
fprintf(fid,'+ vth_n id_n gm_n gmbs_n gds_n cgg_n cgs_n cgd_n cgb_n \n');
fprintf(fid,'+ cdd_n css_n \n');
fprintf(fid,'\n');
fprintf(fid,'reset \n');
fprintf(fid,'\n');
fprintf(fid,'save dc \n')
fprintf(fid,'+ v(vgp) v(vdp) \n');
fprintf(fid,'+ dc @m.xmp.msky130_fd_pr__pfet_01v8[vbs]\n');
fprintf(fid,'+ dc @m.xmp.msky130_fd_pr__pfet_01v8[vth]\n');
fprintf(fid,'+ dc @m.xmp.msky130_fd_pr__pfet_01v8[id]\n');
fprintf(fid,'+ dc @m.xmp.msky130_fd_pr__pfet_01v8[gm]\n');
fprintf(fid,'+ dc @m.xmp.msky130_fd_pr__pfet_01v8[gmbs]\n');
fprintf(fid,'+ dc @m.xmp.msky130_fd_pr__pfet_01v8[gds]\n');
fprintf(fid,'+ dc @m.xmp.msky130_fd_pr__pfet_01v8[cgg]\n');
fprintf(fid,'+ dc @m.xmp.msky130_fd_pr__pfet_01v8[cgs]\n');
fprintf(fid,'+ dc @m.xmn.msky130_fd_pr__nfet_01v8[cbg] \n');
fprintf(fid,'+ dc @m.xmp.msky130_fd_pr__pfet_01v8[cgd]\n');
fprintf(fid,'+ dc @m.xmp.msky130_fd_pr__pfet_01v8[cdg]\n');
fprintf(fid,'+ dc @m.xmp.msky130_fd_pr__pfet_01v8[cgb]\n');
fprintf(fid,'+ dc @m.xmp.msky130_fd_pr__pfet_01v8[cbg]\n');
fprintf(fid,'+ dc @m.xmp.msky130_fd_pr__pfet_01v8[cdd]\n');
fprintf(fid,'+ dc @m.xmp.msky130_fd_pr__pfet_01v8[cds]\n');
fprintf(fid,'+ dc @m.xmp.msky130_fd_pr__pfet_01v8[cdb]\n');
fprintf(fid,'+ dc @m.xmp.msky130_fd_pr__pfet_01v8[css]\n');
fprintf(fid,'\n');
fprintf(fid,'run \n');
fprintf(fid,'dc vsgp 0 %0.1f %0.3f vsdp 0 %0.1f %0.3f \n',...
    c.VGS_max,c.VGS_step,c.VDS_max,c.VDS_step);
fprintf(fid,'let vd_p=v(vdp) \n');
fprintf(fid,'let vg_p=v(vgp) \n');
fprintf(fid,'let vb_p=@m.xmp.msky130_fd_pr__pfet_01v8[vbs] \n');
fprintf(fid,'let vth_p=-@m.xmp.msky130_fd_pr__pfet_01v8[vth] \n');
fprintf(fid,'let id_p=@m.xmp.msky130_fd_pr__pfet_01v8[id] \n');
fprintf(fid,'let gm_p=@m.xmp.msky130_fd_pr__pfet_01v8[gm] \n');
fprintf(fid,'let gmbs_p=@m.xmp.msky130_fd_pr__pfet_01v8[gmbs]\n');
fprintf(fid,'let gds_p=@m.xmp.msky130_fd_pr__pfet_01v8[gds] \n');
fprintf(fid,'let cgg_p=@m.xmp.msky130_fd_pr__pfet_01v8[cgg] \n');
fprintf(fid,'let cgs_p=-@m.xmp.msky130_fd_pr__pfet_01v8[csg] ;flip nodes\n');
fprintf(fid,'let cgd_p=-@m.xmp.msky130_fd_pr__pfet_01v8[cdg] ;flip nodes\n');
fprintf(fid,'let cgb_p=-@m.xmp.msky130_fd_pr__pfet_01v8[cbg] ;flip nodes\n');
fprintf(fid,'let cdb_p=@m.xmp.msky130_fd_pr__pfet_01v8[cdb]\n');
fprintf(fid,'let cds_p=@m.xmp.msky130_fd_pr__pfet_01v8[cds]\n');
fprintf(fid,'let cdd_p= cds_p - cdb_p + cgd_p\n');
fprintf(fid,'let css_p=@m.xmp.msky130_fd_pr__pfet_01v8[css] \n');
fprintf(fid,'\n');
fprintf(fid,'write ./spiceout/pmos_%d_%d_sky130.raw \n',i,j); 
fprintf(fid,'+ vd_p vg_p vb_p \n');
fprintf(fid,'+ vth_p id_p gm_p gmbs_p gds_p cgg_p cgs_p cgd_p cgb_p \n');
fprintf(fid,'+ cdd_p css_p \n');
fprintf(fid,'.endc \n');
fprintf(fid,'.end\n');
fprintf(fid,'\n');
fclose(fid);
return
