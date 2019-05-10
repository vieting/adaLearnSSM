% Author: Peter Vieting

%% Load data
parameters = ['_sigma',num2str(sigma),'_mu',num2str(mu)];
parameters = strrep(parameters,'.',',');
load([foldername,'Results/EMSE_convergence',parameters]);

%% EMSE theory vs. simulation plot
figure;
idx = 1:5:size(MSE_GDFK,1);
plot(idx,MSE_GDFK(idx),'Linewidth',1.5); hold on;
plot(xlim(),[MSE_ss_thy MSE_ss_thy],'k--','Linewidth',1.5);
xlabel('Firing time instant'); ylabel('Prediction MSE');
ylim([0 4]); grid on;
legend('Simulation','Theory (steady state)');
