% Author: Peter Vieting

%% Evaluate Results
% Allocation
MSE_dA_GDF  = zeros(N_points,1);
MSE_dA_GDI  = zeros(N_points,1);
MSE_dA_DGD  = zeros(N_points,1);
MSE_dA_VSS  = zeros(N_points,1);
u_sum = zeros(L-1,T);
% Filenames
parameters_GDFK  = ['_sigma',num2str(sigma),...
        '_mu',num2str(mu)];
parameters_GDIK  = ['_sigma',num2str(sigma),...
            '_mu',num2str(mu),...
            '_BER',num2str(BER_u)];
parameters_DAAGD = ['_sigma',num2str(sigma),...
        '_mu',num2str(mu),...
        '_eth',num2str(e_th),...
        '_alpha',num2str(alpha)];
parameters_D_VSS = ['_sigma',num2str(sigma),...
        '_mu',num2str(mu),...
        '_eth',num2str(e_th),...
        '_alpha',num2str(alpha_VSS)];
parameters_GDFK  = strrep(parameters_GDFK,'.',',');
parameters_GDIK  = strrep(parameters_GDIK,'.',',');
parameters_DAAGD = strrep(parameters_DAAGD,'.',',');
parameters_D_VSS = strrep(parameters_D_VSS,'.',',');

for i=N_files
    rng(i);
    %% Load learning results
    data = load([foldername,'Simulation/simulation_rng',num2str(i,'%03.f')],'u_orig');
    u_orig = data.u_orig(1:L-1,:);
    load([foldername,'Results/GDF',parameters_GDFK,'_rng',num2str(i,'%03.f')],'*_GDF');
    load([foldername,'Results/GDI',parameters_GDIK,'_rng',num2str(i,'%03.f')],'*_GDI');
    load([foldername,'Results/DGD',parameters_DAAGD,'_rng',num2str(i,'%03.f')],'*_DGD');
    load([foldername,'Results/VSS',parameters_D_VSS,'_rng',num2str(i,'%03.f')],'*_VSS');
    
    %% Compute error measure of adaptive techniques
    A           = SPN.Post.'-SPN.Pre;
    A_0         = [zeros(P,1),A];
    u           = u_orig*[1:T].';
    idx_DGD     = u(trig_t_DGD)+1; % Indices of true firing at detection
    idx_VSS     = u(trig_t_VSS)+1;
    mis_DGD     = setdiff(1:T,idx_DGD-1);% Missing (undetected) transitions
    mis_VSS     = setdiff(1:T,idx_VSS-1);
    dA_GDF      = Ahat_GDF  - repmat(A,1,1,N_points); % Error of each weight
    dA_GDI      = Ahat_GDI  - repmat(A,1,1,N_points);
    dA_DGD      = [Ahat_DGD,zeros(P,numel(mis_DGD),N_points)] - repmat([A_0(:,idx_DGD),A(:,mis_DGD)],1,1,N_points);
    dA_VSS      = [Ahat_VSS,zeros(P,numel(mis_VSS),N_points)] - repmat([A_0(:,idx_VSS),A(:,mis_VSS)],1,1,N_points);
    MSE_dA_GDF  = MSE_dA_GDF + squeeze(mean(mean(dA_GDF.^2)))./numel(N_files); % MSE
    MSE_dA_GDI  = MSE_dA_GDI + squeeze(mean(mean(dA_GDI.^2)))./numel(N_files);
    MSE_dA_DGD  = MSE_dA_DGD + squeeze(mean(mean(dA_DGD.^2)))./numel(N_files);
    MSE_dA_VSS  = MSE_dA_VSS + squeeze(mean(mean(dA_VSS.^2)))./numel(N_files);
    
    u_sum       = u_sum + u_orig;
end

%% Save results
parameters = ['_sigma',num2str(sigma),...
        '_mu',num2str(mu),...
        '_eth',num2str(e_th),...
        '_alpha',num2str(alpha)];
parameters = strrep(parameters,'.',',');

save([foldername,'Results/Comparison',parameters],'MSE_*','L');
