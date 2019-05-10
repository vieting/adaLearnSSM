% Author: Peter Vieting

%% Evaluate Results
% Allocation
MSE_GDFK    = zeros(N_firing_min,1);
% Filenames
parameters_GDFK  = ['_sigma',num2str(sigma),...
        '_mu',num2str(mu)];
parameters_GDFK  = strrep(parameters_GDFK,'.',',');

for i=N_files
    rng(i);
    %% Load learning results
    data = load([foldername,'Simulation/simulation_rng',num2str(i,'%03.f')],'u_orig');
    u_orig = data.u_orig(1:L-1,:);
    load([foldername,'Results/EMSE_GDF',parameters_GDFK,'_rng',num2str(i,'%03.f')],'*_GDF*');
    
    idx         = find(sum(u_orig,2));
    MSE_GDFK    = MSE_GDFK + sum(e_GDF(idx(1:N_firing_min),:).^2,2)./numel(N_files);
end

% Theoretical SSE expression
MSE_ss_thy  = 2*trace(SIG) + 2*mu/(2-mu)*trace(SIG);
    
%% Save results
save([foldername,'Results/EMSE_convergence',parameters_GDFK],'MSE_*');
