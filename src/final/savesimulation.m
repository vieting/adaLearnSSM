% Author: Peter Vieting

function [ ] = savesimulation( filename, SPN, sim, t, m_orig, u_orig )
%SAVESIMULATION Saves simulation variables during parfor execution

save(filename,'SPN','sim','t','m_orig','u_orig');

end
