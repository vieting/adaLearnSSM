% Author: Peter Vieting

%% Simulate model
parfor i=N_files
    rng(i);
    [t,m_orig,u_orig] = Simulator_SPN(SPN,sim,'NoOutput');
    filename = [foldername,'Simulation/',...
            'simulation_rng',num2str(i,'%03.f')];
    savesimulation(filename,SPN,sim,t,m_orig,u_orig); %save(filename);
end
