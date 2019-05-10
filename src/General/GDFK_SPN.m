% Author: Peter Vieting

function [ A, e ] = GDFK_SPN( m, SPN, t, u, mu )
%% Parameters
% wb          = waitbar(0,'GDFK SPN Progress');
iterations  = length(t);
[~,T_S]     = size(SPN.Pre);
m_hat       = zeros(size(m));
m_hat(1,:)  = m(1,:);%[SPN.m0].';
A           = zeros([size(SPN.Pre),iterations]); % Implicitly: A0 = 0;
e           = zeros(size(m));

%% Iterative Learning
for k = 2:iterations
    m_hat(k,:)  = state_eq_det_SPN(m(k-1,:).',u(k-1,:).',A(:,:,k-1)).';
    e(k,:)      = (m_hat(k,:)-m(k,:));
    A_delta     = e(k,:).'*u(k-1,1:T_S);
    A(:,:,k)    = A(:,:,k-1)-mu*A_delta;
%     waitbar(k/iterations,wb);
end
% close(wb);

e = e(2:end,:);

end
