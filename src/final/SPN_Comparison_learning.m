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
    Ahat_GDF = GDFK_SPN_MUeff(m,SPN,t,u_orig,mu);
    % Gradient Descent with imperfect knowledge
    u_imp = mod(u_orig+(rand(L-1,T)<BER_u),2);
    Ahat_GDI = GDFK_SPN_MUeff(m,SPN,t,u_imp,mu);
    % DAAGD without knowledge
    [Ahat_DGD,~,trig_t_DGD,~] = DAAGD_SPN(m,SPN,t,mu,SIG,e_th,u_orig);
    % VSS-DAAGD without knowledge
    [Ahat_VSS,~,trig_t_VSS,~] = DAAGD_SPN_VSS(m,SPN,t,mu,alpha,SIG,e_th,u_orig);
    
    %% Extract relevant time points
    t = t(round(1:(L-1)/(N_points-1):end));
    Ahat_GDF = Ahat_GDF(:,:,round(1:(L-1)/(N_points-1):end));
    Ahat_GDI = Ahat_GDI(:,:,round(1:(L-1)/(N_points-1):end));
    Ahat_DGD = Ahat_DGD(:,:,round(1:(L-1)/(N_points-1):end));
    Ahat_VSS = Ahat_VSS(:,:,round(1:(L-1)/(N_points-1):end));
    
    %% Save results
    parameters_GDFK  = ['_sigma',num2str(sigma),...
            '_mu',num2str(mu),...
            '_rng',num2str(i,'%03.f')];
    parameters_GDIK  = ['_sigma',num2str(sigma),...
            '_mu',num2str(mu),...
            '_BER',num2str(BER_u),...
            '_rng',num2str(i,'%03.f')];
    parameters_DAAGD = ['_sigma',num2str(sigma),...
            '_mu',num2str(mu),...
            '_eth',num2str(e_th),...
            '_alpha',num2str(alpha),...
            '_rng',num2str(i,'%03.f')];
    parameters_GDFK  = strrep(parameters_GDFK,'.',',');
    parameters_GDIK  = strrep(parameters_GDIK,'.',',');
    parameters_DAAGD = strrep(parameters_DAAGD,'.',',');
    
    savelearning([foldername,'Results/GDF',parameters_GDFK],'GDF',Ahat_GDF,t);
    savelearning([foldername,'Results/GDI',parameters_GDIK],'GDI',Ahat_GDI,t);
    savelearning([foldername,'Results/DGD',parameters_DAAGD],'DGD',Ahat_DGD,t,trig_t_DGD);
    savelearning([foldername,'Results/VSS',parameters_DAAGD],'VSS',Ahat_VSS,t,trig_t_VSS);
end
