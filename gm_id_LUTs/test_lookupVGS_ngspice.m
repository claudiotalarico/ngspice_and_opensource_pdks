% File: test_lookupVGS_ngspice.m
% Usage examples for look_upVGS function

clearvars;
clc;
close all;

addpath('../class/gmidLUTs;../class/gmidTECHs')
addpath('../HspiceToolbox');

% load('180nch.mat')
load('nch130.mat')


%
% Example with unknown source voltage
%
gm_id = 15;
VGB = .9;
VDB = .7;

% find VGS and VS
VGS = look_upVGS(nch, 'GM_ID', gm_id, 'VDB', VDB, 'VGB', VGB)
VSB = VGB - VGS

% check to make sure the same gm/id comes out from forward inerpolation
gmID = look_up(nch, 'GM_ID', 'VGS', VGS, 'VDS', VDB-VSB, 'VSB', VSB)

%
% Example with vector input for L
%
gm_id = 15;
Lvec = min(nch.L):0.1:0.5;
VGS = look_upVGS(nch, 'GM_ID', gm_id, 'L', Lvec)

%
% Example with vector input for gm/id
%
gm_id = 5:10;
VGS = look_upVGS(nch, 'GM_ID', gm_id, 'L', 0.25)

%
% Example with ID_W as input
%
gm_id = 10:12;
id_w = look_up(nch, 'ID_W','GM_ID',gm_id)
VGS = look_upVGS(nch,'GM_ID',gm_id)
VGS = look_upVGS(nch, 'ID_W', id_w)

%
% Example with known and positive VSB
% The issue is that gm/ID drops again for VGS near 0 and the function
% may then catch the wrong intercept.
% To fix this, the function looks only to the right of the maximum value 
% for gm/ID
%
VSB = 0.8;
VDS = 0.2;
gm_id = look_up(nch, 'GM_ID', 'VGS', nch.VGS, 'VSB', VSB', 'VDS', VDS);
gmid = max(gm_id) - 0.5 % use a value smaller than max
VGS = look_upVGS(nch,'GM_ID', gmid, 'VSB', VSB, 'VDS', VDS)
display('Plot Figure 1')
plot(nch.VGS, gm_id, VGS, gmid, 'o')
xlabel('VGS (v)');
ylabel('gm/ID (A/S)')

%
% mode 2 - Example with vector inpit for L
%
VSB = 0.8;
VDS = 0.2;
Lvec = min(nch.L):0.1:0.2;
VGS = look_upVGS(nch, 'GM_ID', gmid, 'VSB', VSB, 'VDS', VDS, 'L', Lvec)

%
% mode 2 - Example with vector input for VDS
%
VSB = 0.8;
VDS_vec = 0.2:0.1:0.5;
VGS = look_upVGS(nch, 'GM_ID', gmid, 'VSB', VSB, 'VDS', VDS_vec)

%
% Example with value deliberately exceeding maximum
%
gm_id = 50
VGS = look_upVGS(nch, 'GM_ID', gm_id, 'L', 0.25)

