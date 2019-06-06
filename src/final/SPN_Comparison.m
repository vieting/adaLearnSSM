% Author: Peter Vieting

%% Clean up
rmpath(genpath('../../'));
clearvars; clc; close all force;
addpath(genpath('../General'));

%% Parameters
SPN_Model_pure

L           = (sim.tend-sim.t0)/sim.tstep;
[P,T]       = size(SPN.Pre);
mu          = 0.1;
noise_set   = 1:2;
sigma_set   = [0.01;0.03];
e_th_set    = [0.08;0.23];
alpha       = 0.01;
BER_u       = 0.001;
N_files     = 1:50;
N_points    = 11;

foldername  = '/path/to/folder/';
assert(logical(exist(foldername)), 'Please specify a correct path')
for path={[foldername,'Simulation'], [foldername,'Results']}
    if ~logical(exist(path{1})); mkdir(path{1}); end
end

%% Multiple executions
SPN_Comparison_data;
for noise = noise_set
    sigma       = sigma_set(noise);
    e_th        = e_th_set(noise);
    SIG         = max(sigma,1E-10)*eye(numel(SPN.P));
    SPN_Comparison_learning;
    SPN_Comparison_results;
    SPN_Comparison_totalplot;
end
