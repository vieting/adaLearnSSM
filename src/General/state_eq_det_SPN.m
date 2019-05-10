% Author: Peter Vieting

function [ m_1 ] = state_eq_det_SPN( m, u, Ahat )
%STATE_EQ_DET_SPN Deterministic calculation of next marking based on  
%current marking, control vector and SPN topology

% Find numbers of places and transitions
[~,T_S] = size(Ahat);

% Compose coincidence matrix A
v_S = ones(T_S,1);
A_S = Ahat*diag(v_S);
A   = A_S;

% Calculate marking in next step
m_1 = m + A*u;
end
