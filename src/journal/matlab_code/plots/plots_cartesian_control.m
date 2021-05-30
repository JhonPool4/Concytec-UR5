% journal plots

clc, clear all, close all

Path = '/home/utec/catkin_ws/src/journal/src/Data/SMCi/circular_traj/';
%file = 'cartesian_lambda_10.0_alpha_0.0001_gamma_1.0v2.csv';
%file = 'radio_10_mm.csv';
file = 'radio_20_mm.csv';
data = readtable(fullfile(Path, file),'PreserveVariableNames',true);
time = 0:1/100:60;


%% time ranges
t_start = 5000;
t_step  = 1;
t_end   = 6000;

x    = 1000*data.e_x;
dx   = 1000*data.de_x;
ddx  = 1000*data.dde_x;
dddx = 1000*data.dde_x;

[l1_x ,l1_dx, l1_ddx, l1_dddx, l2_x ,l2_dx, l2_ddx, l2_dddx] = normas(x, dx, ddx, dddx, t_start, t_step, t_end);


%% joints
close all
figure(1), grid on, hold on, box on,
            subplot(2,3,1)
            plot(time(t_start:t_step:t_end), data.q1(t_start:t_step:t_end)*180/pi, '-k', 'linewidth', 3)
            
%figure(2), grid on, hold on, box on
            subplot(2,3,2)
            plot(time(t_start:t_step:t_end), data.q2(t_start:t_step:t_end)*180/pi, '-k', 'linewidth', 3)
            
%figure(3), grid on, hold on, box on
            subplot(2,3,3)
            plot(time(t_start:t_step:t_end), data.q3(t_start:t_step:t_end)*180/pi, '-k', 'linewidth', 3)

%figure(4), grid on, hold on, box on
            subplot(2,3,4)
            plot(time(t_start:t_step:t_end), data.q4(t_start:t_step:t_end)*180/pi, '-k', 'linewidth', 3)
            
%figure(5), grid on, hold on, box on
            subplot(2,3,5)
            plot(time(t_start:t_step:t_end), data.q5(t_start:t_step:t_end)*180/pi, '-k', 'linewidth', 3)            

%figure(6), grid on, hold on, box on
            subplot(2,3,6)
            plot(time(t_start:t_step:t_end), data.q6(t_start:t_step:t_end)*180/pi, '-k', 'linewidth', 3)



%            plot(time(t_start:t_step:t_end), data.e_x(t_start:t_step:t_end), '-k', 'linewidth', 3)


























%% plot settings
color2 = [0 0 0];
color1 = [0.4660 0.6740 0.1880];
color3 = [1 0 0];



name = 'vel_xyz_data_3';


%% Position error
close all
figure(1), hold on, grid on, box on
            plot( time(t_start:t_step:t_end), 1000*data.e_x(t_start:t_step:t_end) ,'color', color2, 'linestyle', '-', 'linewidth',  3)
            plot( time(t_start:t_step:t_end), 1000*data.e_y(t_start:t_step:t_end) ,'color', color1, 'linestyle', '-', 'linewidth', 3)
            plot( time(t_start:t_step:t_end), 1000*data.e_z(t_start:t_step:t_end) ,'color', color3, 'linestyle', '--', 'linewidth', 3)
    
            leg=legend({'$x$', '$y$', '$z$'}, ...
                        'interpreter', 'latex', 'Fontsize', 20);
            title(leg,'Eje')
            
            xlabel('Tiempo (s)', 'interpreter', 'latex')
            %ylabel('$\mathrm{e}_\mathrm{jerk}$ $(\frac{\mathrm{mm}}{s^3})$', 'interpreter', 'latex')
            ylabel('$\mathrm{e}_\mathrm{posicion}$ $(\mathrm{mm})$', 'interpreter', 'latex')
            ax = gca; % current axes
            ax.FontSize = 25;
            ax.TickDir = 'out';
            ax.TickLength = [0.01 0.01];
            %axis()
            
            set(gcf,'units','pixel','position',[200,200,1200,800])
            
            % Save image
            %SavePath     = '/home/utec/catkin_ws/src/journal/src/Data/SMCi/circular_traj/';
            %FileName     = strcat(SavePath, name);
            %saveas(gcf,FileName,'epsc')   

            
%% Jerk error           
figure(2), hold on, grid on, box on
            plot( time(t_start:t_step:t_end), 1000*data.ddde_x(t_start:t_step:t_end) ,'color', color2, 'linestyle', '-', 'linewidth',  3)
            plot( time(t_start:t_step:t_end), 1000*data.ddde_y(t_start:t_step:t_end) ,'color', color1, 'linestyle', '-', 'linewidth', 3)
            plot( time(t_start:t_step:t_end), 1000*data.ddde_z(t_start:t_step:t_end) ,'color', color3, 'linestyle', '--', 'linewidth', 3)
    
            leg=legend({'$x$', '$y$', '$z$'}, ...
                        'interpreter', 'latex', 'Fontsize', 20);
            title(leg,'Eje')
            
            xlabel('Tiempo (s)', 'interpreter', 'latex')
            ylabel('$\mathrm{e}_\mathrm{jerk}$ $(\frac{\mathrm{mm}}{s^3})$', 'interpreter', 'latex')
            %ylabel('$\mathrm{e}_\mathrm{posicion}$ $(\mathrm{mm})$', 'interpreter', 'latex')
            ax = gca; % current axes
            ax.FontSize = 25;
            ax.TickDir = 'out';
            ax.TickLength = [0.01 0.01];
            %axis()
            
            set(gcf,'units','pixel','position',[200,200,1200,800])
            
            % Save image
            %SavePath     = '/home/utec/catkin_ws/src/journal/src/Data/SMCi/circular_traj/';
            %FileName     = strcat(SavePath, name);
            %saveas(gcf,FileName,'epsc')   
            
%% Position tracking

close all
figure(3), hold on, grid on, box on
            plot( time(t_start:t_step:t_end), 1000*data.y_des(t_start:t_step:t_end) ,'color', color1, 'linestyle', '-', 'linewidth', 3)
            plot( time(t_start:t_step:t_end), 1000*data.y(t_start:t_step:t_end)     ,'color', color2, 'linestyle', '--', 'linewidth', 3)
            
            legend({'deseado', 'medido'}, 'interpreter', 'latex', 'Fontsize', 20);
            
            xlabel('Tiempo (s)', 'interpreter', 'latex')
            ylabel('Posición (mm)', 'interpreter', 'latex')
            ax = gca; % current axes
            ax.FontSize = 25;
            ax.TickDir = 'out';
            ax.TickLength = [0.01 0.01];
            %xticks(time(t_start+1):10: time(t_end+1))
            %axis([time(t_start+1) time(t_end+1) 450 550])
            
            set(gcf,'units','pixel','position',[200,200,1200,800])
            
            % Save image
            %SavePath     = '/home/utec/catkin_ws/src/journal/src/Data/SMCi/circular_traj/';
            %FileName     = strcat(SavePath, name);
            %saveas(gcf,FileName,'epsc')   

 
%% Jerk tracking
close all
figure(4), hold on, grid on, box on
            plot( time(t_start:t_step:t_end), 1000*data.dddx_des(t_start:t_step:t_end) ,'color', color1, 'linestyle', '-', 'linewidth', 3)
            plot( time(t_start:t_step:t_end), 1000*data.dddx(t_start:t_step:t_end)     ,'color', color2, 'linestyle', '--', 'linewidth', 3)
            
            legend({'deseado', 'medido'}, 'interpreter', 'latex', 'Fontsize', 20);
            
            xlabel('Tiempo (s)', 'interpreter', 'latex')
            ylabel('Posición (mm)', 'interpreter', 'latex')
            ax = gca; % current axes
            ax.FontSize = 25;
            ax.TickDir = 'out';
            ax.TickLength = [0.01 0.01];
            %xticks(time(t_start+1):10: time(t_end+1))
            %axis([time(t_start+1) time(t_end+1) 450 550])
            
            set(gcf,'units','pixel','position',[200,200,1200,800])
            
            % Save image
            %SavePath     = '/home/utec/catkin_ws/src/journal/src/Data/SMCi/circular_traj/';
            %FileName     = strcat(SavePath, name);
            %saveas(gcf,FileName,'epsc')   

