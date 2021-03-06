% Author: Peter Vieting

function [ t, m, u ] = Simulator_SPN_multi( SPN, sim )
%SIMULATOR Simulates given SPN allowing multiple firings per time instant

%% Extract variables from structs
names = fieldnames(SPN);
for i=1:length(names)
    eval(['SPN_' names{i} '=SPN.' names{i} ';']);
end
names = fieldnames(sim);
for i=1:length(names)
    eval([names{i} '=sim.' names{i} ';']);
end

%% Initialization
[P_S,T_S]   = size(SPN_Pre);    % T_S = # of trans. in SPN; P_S = # of places in SPN

m       = SPN_m0.';             % Overall marking matrix
t_reac  = t0;                   % Time
k       = 1;                    % Simulation step
t       = t0;                   % Time vector
u       = [];                   % Control vector
A       = SPN_Post.'-SPN_Pre;   % Stoichiometric matrix of SPN

u_aux   = zeros(T_S,1);
mul_re  = 0;                    % Number of multi reactions (>1 reactions in one sim. step)

wb      = waitbar(0,'Simulation Progress');

%% Main Loop
while t_reac(end) < tend
    % Determine time for next reaction event
    dt          = 0;
    react       = 1;
    m_dt        = m(end,1:P_S).';
    tau         = zeros(T_S,1);
    while react
        v_S         = MassActionSto(SPN_x,m_dt,SPN_Pre,sim.MAK);
        v           = [v_S,[]];
        dt          = dt + get_t_next(v,tstep);
    
        % Determine next reaction with probability pi:
        tau_k       = get_tau_firing(v);
        tau(tau_k)  = tau(tau_k) + 1;
        
        % Update marking
        m_dt        = m_dt + A(:,tau_k);
        
        react       = dt<tstep; if react; mul_re = mul_re + 1; end
    end
    Dt          = dt-mod(dt,tstep);
    t_reac(k+1) = min(t_reac(k)+Dt,tend+tstep);
    tnext       = t_reac(k):tstep:t_reac(k+1); % time steps until next reaction
    
    % Update markings and steps
    m       = [m;repmat(m(end,1:P_S),numel(tnext)-1,1)];
    t       = [t;tnext(2:end).'];
    u       = [u;repmat(u_aux,1,numel(tnext)-1).'];
    u(end,:)= tau;
    m(end,:)= m_dt;

    k       = k+1;
    waitbar(t(end)/tend,wb);
end

t = t(1:end-1);
m = m(1:end-1,:);
u = u(1:end-1,:);

close(wb);
display(['Number of multiple reactions in single time step: ',num2str(mul_re)]);
end

%% Additional functions
function [ t ] = get_t_next(v,tstep)
%GET_T_NEXT Get time until next stochastic reaction event
v_sum   = sum(v);
if v_sum > 0
    t   = -log(rand)/v_sum;         % holding time
%     t   = t-mod(t,tstep)+tstep;     % WATCH OUT: adapt to simulation's time steps
%     if t==0; error('No firing can occur after 0s.'); end
else % No transition is enabled
    t   = inf;
end
end
function [ tau ] = get_tau_firing(v)
% GET_TAU_FIRING Determine next reaction with probability pi:
if sum(v)==0
    disp('No stochastic transition enabled');
    tau = 0;
    return
end
pi      = v/sum(v);
a       = rand;
tau     = 0;
for i=1:numel(v)
    tau = tau+i*(sum(pi(1:i-1))<=a & a<sum(pi(1:i)));
end
end
