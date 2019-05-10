% Author: Peter Vieting

function [ A, e ] = GDFK_SPN_MUeff( m, SPN, t, u, mu )
%GDFK_SPN_MUEFF implements the GDFK approach but uses mu=1 for the first
%firing of each transition to allow a fair comparison to the DAAGD
%algorithms

%% Parameters
% wb          = waitbar(0,'GDFK SPN Progress');
iterations  = length(t);
[~,T_S]     = size(SPN.Pre);
m_hat       = zeros(size(m));
m_hat(1,:)  = m(1,:);%[SPN.m0].';
A           = zeros([size(SPN.Pre),iterations]); % Implicitly: A0 = 0;
e           = zeros(size(m));

%% Iterative Learning
mu_eff      = [ones(T_S,1);mu]; % Initially, mu_eff is 1
for k = 2:iterations
    m_hat(k,:)  = state_eq_det_SPN(m(k-1,:).',u(k-1,:).',A(:,:,k-1)).';
    e(k,:)      = (m_hat(k,:)-m(k,:));
    A_delta     = e(k,:).'*u(k-1,1:T_S);
    if any(u(k-1,:)) % Find transition that fired
        tau = find(u(k-1,:));
    else
        tau = T_S+1; % If no firing, value of mu_eff does not matter
    end
    A(:,:,k)    = A(:,:,k-1)-max(mu_eff(tau))*A_delta;
    if any(u(k-1,:)); mu_eff(tau) = mu; end % Switch mu_eff to mu after firing
%     waitbar(k/iterations,wb);
end
% close(wb);

e = e(2:end,:);

end
