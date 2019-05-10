% Author: Peter Vieting

function [ A_S, MSE, trig_t, u_hat, mu_k ] = DAAGD_SPN_VSS( m, SPN, t, mu, alpha, SIG, e_th, u_orig )
%% Parameters
% wb          = waitbar(0,'DAAGD SPN Progress');
iterations  = length(t);
[P_S,~]     = size(SPN.Pre);
T_S         = 0;
T_S_max     = 30;
A_S         = zeros([P_S,T_S_max,iterations]);
mu_k        = zeros(iterations-1,1);
MSE         = zeros(iterations-1,1);
u_hat       = zeros(iterations,T_S_max);
trig_t      = [];

%% Iterative Learning
for k = 2:iterations
    % Current incidence matrix estimation
    A           = A_S(:,1:T_S,k-1);
    
    % Firing MLE
    u_all       = [zeros(T_S,1),eye(T_S)]; % Simplification: max one firing
    LLR         = zeros(size(u_all,2),1);
    for tau=1:size(u_all,2)
        LLR(tau)  = llr(m(k,:).',m(k-1,:).',A,u_all(:,tau),SIG);
    end
    [LLR_val,tau] = max(LLR);
    u_pos   = u_all(:,tau);
    
    % Prediction
    m_pos   = m(k-1,:).'+A*u_pos;
    e_pos   = m(k,:).'-m_pos;
    
    % Event-Triggered Firing Detection
    MSE(k-1)= mean(e_pos.^2);
    if mean(e_pos.^2)>e_th
        if T_S<T_S_max
            T_S     = T_S + 1;
            trig_t(T_S) = k-1;
            u_pos   = [zeros(T_S-1,1);1];
            m_pos   = m(k-1,:).';
            e_pos   = m(k,:).'-m_pos;
            A_S(:,1:T_S,k) = A_S(:,1:T_S,k-1)+1*e_pos*u_pos.';
        else
            warning(['Maximum number of transitions exceeded. ',...
                'No update of weights in this step.']);
            A_S(:,1:T_S,k) = A_S(:,1:T_S,k-1);
        end
    else
%         A_S(:,1:T_S,k) = A_S(:,1:T_S,k-1)+mu*e_pos*u_pos.';
        A_S(:,1:T_S,k) = A_S(:,1:T_S,k-1)+f_VSS(mu,LLR_val,alpha)*e_pos*u_pos.';
    end
    u_hat(k,1:T_S)  = u_pos;
    mu_k(k)         = (1-exp(-2*alpha*LLR_val));
%     waitbar(k/iterations,wb);
end
% close(wb);

% Pruning
A_S = A_S(:,1:T_S,:);
u_hat = u_hat(2:end,1:T_S);

end

function [ mu_k ] = f_VSS( mu, LLR_val, alpha )
    mu_k = mu*(1-exp(-2*alpha*LLR_val));
end
