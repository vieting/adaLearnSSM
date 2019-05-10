% Author: Peter Vieting

%% Apply Learning Techniques
parfor i=N_files
    rng(i);
    %% Load simulation
    data    = load([foldername,'Simulation/simulation_rng',num2str(i,'%03.f')]);
    t       = data.t(1:L);
    m_orig  = data.m_orig(1:L,:);
    u_orig  = data.u_orig(1:L-1,:);
    
    %% Add noise
    m = m_orig+sqrt(sigma)*randn(size(m_orig));

    %% Learning techniques
    % Gradient Descent with perfect knowledge
    [Ahat_GDF,e_GDFK] = GDFK_SPN(m,SPN,t,u_orig,mu);
    
    %% Extract relevant time points
    t = t(round(1:(L-1)/(N_points-1):end));
    Ahat_GDF = Ahat_GDF(:,:,round(1:(L-1)/(N_points-1):end));
    
    %% Save results
    parameters_GDFK  = ['_sigma',num2str(sigma),...
            '_mu',num2str(mu),...
            '_rng',num2str(i,'%03.f')];
    parameters_GDFK  = strrep(parameters_GDFK,'.',',');
    
    savelearning([foldername,'Results/EMSE_GDF',parameters_GDFK],'GDF',Ahat_GDF,t,e_GDFK);
%     save([foldername,'Results/EMSE_GDF',parameters_GDFK],'*_GDF');
end
