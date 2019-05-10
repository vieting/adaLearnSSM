% Author: Peter Vieting

%% SPN_Model Running Example
% Initializes the SPN model based on the running example from [1]
% where read arcs are avoided by conversion into pure SPN
%
% [1] M. Blätke, M. Heiner, and W. Marwan, “Biomodel engineering with
% Petri nets,” in Algebraic and Discrete Mathematical Methods for Modern
% Biology. Elsevier, 2015, pp. 141–192.

%% Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Constants %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
alpha_A0    = 50;
alpha_A1    = 500;
alpha_R0    = 0.01;
alpha_R1    = 50;
beta_A      = 50;
beta_R      = 5;
gamma_A     = 1;
gamma_AR    = 2;
gamma_R     = 1;
delta_AM    = 10;
delta_RM    = 0.5;
delta_A     = 1;
delta_R     = 0.2;
theta_A     = 50;
theta_R     = 100;
c_aux       = 1000;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SPN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set of places in SPN
SPN.P       = { 'A','R','A_R','mrnaA','mrnaR','geneA','geneA_A','geneR','geneR_A',...
                'dummyP_1','dummyP_2','dummyP_3','dummyP_4','dummyP_5','dummyP_6'}.';
% Set of transitions in SPN
SPN.T       = { 'r1','r2','r3','r4','r5','r6','r7','r8','r9','r10','r11','r12','r13','r14','r15','r16',...
                'dummyT_1','dummyT_2','dummyT_3','dummyT_4','dummyT_5','dummyT_6'}.';
% Firing rates of SPN transitions
SPN.x       = [ gamma_A,theta_A,alpha_A0,alpha_A1,beta_A,delta_AM,...
                delta_A,gamma_AR,gamma_R,theta_R,alpha_R0,alpha_R1,...
                beta_R,delta_RM,delta_R,delta_A,...
                c_aux,c_aux,c_aux,c_aux,c_aux,c_aux].';
% Pre(i,j): place i to transition j
SPN.Pre     = [ 1,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,    0,0,0,0,0,0;
                0,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,    0,0,0,0,0,0;
                0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,    0,0,0,0,0,0;
                0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,    0,0,0,0,0,0;
                0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,    0,0,0,0,0,0;
                1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,    0,0,0,0,0,0;
                0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,    0,0,0,0,0,0;
                0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,    0,0,0,0,0,0;
                0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,    0,0,0,0,0,0;
                
                0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,    1,0,0,0,0,0;
                0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,    0,1,0,0,0,0;
                0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,    0,0,1,0,0,0;
                0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,    0,0,0,1,0,0;
                0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,    0,0,0,0,1,0;
                0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,    0,0,0,0,0,1];
% Post(j,i): transition j to place i
SPN.Post    = [ 0,0,0,0,0,0,1,0,0,  0,0,0,0,0,0;
                1,0,0,0,0,1,0,0,0,  0,0,0,0,0,0;
                0,0,0,1,0,0,0,0,0,  0,0,1,0,0,0;
                0,0,0,1,0,0,0,0,0,  0,0,0,1,0,0;
                1,0,0,0,0,0,0,0,0,  1,0,0,0,0,0;
                0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0;
                0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0;
                0,0,1,0,0,0,0,0,0,  0,0,0,0,0,0;
                0,0,0,0,0,0,0,0,1,  0,0,0,0,0,0;
                1,0,0,0,0,0,0,1,0,  0,0,0,0,0,0;
                0,0,0,0,1,0,0,0,0,  0,0,0,0,1,0;
                0,0,0,0,1,0,0,0,0,  0,0,0,0,0,1;
                0,1,0,0,0,0,0,0,0,  0,1,0,0,0,0;
                0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0;
                0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0;
                0,1,0,0,0,0,0,0,0,  0,0,0,0,0,0;
                
                0,0,0,1,0,0,0,0,0,  0,0,0,0,0,0;
                0,0,0,0,1,0,0,0,0,  0,0,0,0,0,0;
                0,0,0,0,0,1,0,0,0,  0,0,0,0,0,0;
                0,0,0,0,0,0,1,0,0,  0,0,0,0,0,0;
                0,0,0,0,0,0,0,1,0,  0,0,0,0,0,0;
                0,0,0,0,0,0,0,0,1,  0,0,0,0,0,0];
% Initial marking of SPN
SPN.m0      = [ 0,0,0,0,0,1,0,1,0,  0,0,0,0,0,0].';

%%%%%%%%%%%%%%%%%%%%%%%%%% Simulation parameters %%%%%%%%%%%%%%%%%%%%%%%%%%
sim.t0      = 0;            % Start time
sim.tend    = 5;            % End time
sim.tstep   = 1e-4;         % Time step for CPN simulation
sim.MAK     = 'simplified'; % Mass-action kinetics

clearvars alpha_* beta_* gamma_* delta_* theta_* c_aux *_S* *_C* *_I*
