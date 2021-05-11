% journal plots

clc, clear all, close all

Path = '/home/utec/catkin_ws/src/journal/src/Data/SMCi/circular_traj/';
file = 'prueba_kalman.csv';
data = readtable(fullfile(Path, file),'PreserveVariableNames',true);
time = 0:1/100:60;

color2 = [0 0 0];
color1 = [0.4660 0.6740 0.1880];
color3 = [1 0 0];

%% time ranges
t_start = 1000;
t_step  = 1;
t_end   = 1200;

%%
close all
figure(1), grid on, hold on, box on,
            %plot(time(t_start:t_step:t_end), data.ddq1(t_start:t_step:t_end), '-r', 'linewidth',1   )
            plot(time(t_start:t_step:t_end), data.ddq1_k(t_start:t_step:t_end), '--k', 'linewidth',1      )
            legend('euler', 'kalman')
            
            %%
close all            
figure(2), hold on, grid on, box on
            plot( time(t_start:t_step:t_end), 1000*data.dddx(t_start:t_step:t_end) ,'color', color2, 'linestyle', '-', 'linewidth',  2)
            plot( time(t_start:t_step:t_end), 1000*data.dddx_k(t_start:t_step:t_end) ,'color', color1, 'linestyle', '--', 'linewidth',  2)
            %plot( time(t_start:t_step:t_end), 1000*data.dddz_k(t_start:t_step:t_end) ,'color', color3, 'linestyle', '--', 'linewidth', 2)
    
            %leg=legend({'$x$', '$y$', '$z$'}, ...
            %            'interpreter', 'latex', 'Fontsize', 20);
            %title(leg,'Eje')
            
            xlabel('Tiempo (s)', 'interpreter', 'latex')
            ylabel('$\mathrm{e}_\mathrm{jerk}$ $(\frac{\mathrm{mm}}{s^3})$', 'interpreter', 'latex')
            ax = gca; % current axes<
            
            ax.FontSize = 25;
            ax.TickDir = 'out';
            ax.TickLength = [0.01 0.01];
            %axis()
            
            set(gcf,'units','pixel','position',[200,200,1200,800])