% Author: Peter Vieting

%% Clean up
rmpath(genpath('../../'));
clear; clc; close all force;
addpath(genpath('../General'));

%% Parameters
SPN_Model_pure

L           = (sim.tend-sim.t0)/sim.tstep+1;
[P,T]       = size(SPN.Pre);
mu          = 0.01;
sigma       = 0.03;
SIG         = max(sigma,1E-10)*eye(numel(SPN.P));
N_files     = 1:50;
N_points    = 21;
N_firing_min= 10000;

foldername  = '/path/to/folder/';
assert(logical(exist(foldername)), 'Please specify a correct path')

%% Simple execution
SPN_Comparison_data;
SPN_EMSE_learning;
SPN_EMSE_results;
SPN_EMSE_totalplot;
