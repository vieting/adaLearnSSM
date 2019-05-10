% Author: Peter Vieting

function [ ratio ] = llr(m_k,m_k1,A,u,SIG)
%LLR Log likelihood ratio

if isempty(A)
    ratio = 0;
    return
end

m_delta = m_k-m_k1;
m_fire  = A*u;
ratio   = -0.5*((m_delta-m_fire).'*inv(SIG)*(m_delta-m_fire)-...
            m_delta.'*inv(SIG)*m_delta);
end
