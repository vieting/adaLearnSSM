% Author: Peter Vieting

%% Plot results

%% Load data
parameters = ['_sigma',num2str(sigma),...
        '_mu',num2str(mu),...
        '_eth',num2str(e_th),...
        '_alpha',num2str(alpha)];
parameters = strrep(parameters,'.',',');
load([foldername,'Results/Comparison',parameters]);
t_plot  = 0:(L-1)/(N_points-1):L;

%% Coefficient error plot
figure;
semilogy(t_plot,MSE_dA_GDF,'-o','Linewidth',1.5); hold on;
ax = gca; ax.ColorOrderIndex = 7;
semilogy(t_plot,MSE_dA_GDI,'-d','Linewidth',1.5);
ax = gca; ax.ColorOrderIndex = 2;
semilogy(t_plot,MSE_dA_DGD,'-^','Linewidth',1.5);
semilogy(t_plot,MSE_dA_VSS,'-v','Linewidth',1.5);
legend('GDFK','GDIK','DAAGD','VSS-DAAGD');
xlabel('Time instant'); ylabel('Coefficient MSE'); grid on;
