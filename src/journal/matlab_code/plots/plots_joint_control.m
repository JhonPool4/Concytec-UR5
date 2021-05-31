% plots - joint space
clc, clear all, close all;

Path = '/home/utec/catkin_ws/src/journal/src/Data/SMCi/circular_traj/';
%file = 'articular_lambda_0.5_alpha_0.1_gamma_1.0.csv';
%file = 'articular_lambda_0.5_alpha_0.15_gamma_1.0.csv';
%file = 'articular_lambda_0.5_alpha_0.2_gamma_1.0.csv';
file = 'borrar_test';
data = readtable(fullfile(Path, file),'PreserveVariableNames',true);
time = 0:1/100:60;


t_start = 5000;
t_step  = 1;
t_end   = 6000;

len = (t_end - t_start)/t_step + 1;

pos_med= (180/pi)*[data.q1(t_start:t_step:t_end), data.q2(t_start:t_step:t_end), data.q3(t_start:t_step:t_end), ...
                   data.q4(t_start:t_step:t_end), data.q5(t_start:t_step:t_end), data.q6(t_start:t_step:t_end)];
      
pos_des= (180/pi)*[data.q1_des(t_start:t_step:t_end), data.q2_des(t_start:t_step:t_end), data.q3_des(t_start:t_step:t_end), ...
                   data.q4_des(t_start:t_step:t_end), data.q5_des(t_start:t_step:t_end), data.q6_des(t_start:t_step:t_end)];  
               
pos_xyz_med = 1000*[data.x(t_start:t_step:t_end), data.y(t_start:t_step:t_end), data.z(t_start:t_step:t_end)];

pos_xyz_des = 1000*[data.x_des(t_start:t_step:t_end), data.y_des(t_start:t_step:t_end), data.z_des(t_start:t_step:t_end)];

               
%% joint position
clc, close all;

figure(1), hold on, grid on, box on;
    screen = get(0, 'ScreenSize');    
    set(gcf,'units','pixel','position',[screen(3)*0.05, screen(4)*0.1, screen(3)*0.9, screen(4)*0.8])

for i=1:6
    plot_name = strcat('q',num2str(i),' (°)');
    subplot(2, 3, i),
    plot(time(t_start:t_step:t_end), pos_des(:, i), '-r', 'linewidth', 1), hold on, grid on, box on,
    plot(time(t_start:t_step:t_end), pos_med(:, i), '--k', 'linewidth', 1)
    title(plot_name)
    [y_max, y_min, y_ticks]= get_axis(pos_des(:,i), pos_med(:,i), 4);
    yticks(y_ticks)
    axis([time(t_start) time(t_end+1), y_min y_max]);
    ax = gca; % current axes
    ax.FontSize = 12;
end         
    
    sgtitle('Joint Position', 'interpreter', 'latex', 'FontSize', 20)
    
%% cartesian position
clc, close all;

figure(2), hold on, grid on, box on;
    screen = get(0, 'ScreenSize');    
    set(gcf,'units','pixel','position',[screen(3)*0.1, screen(4)*0.1, screen(3)*0.8, screen(4)*0.8])

axis_name = ['x', 'y', 'z'];

for i=1:3
    plot_name = strcat(axis_name(i), ' (mm)');
    subplot(3, 1, i),
    plot(time(t_start:t_step:t_end), pos_xyz_des(:, i), '-r', 'linewidth', 1), hold on, grid on, box on,
    plot(time(t_start:t_step:t_end), pos_xyz_med(:, i), '--k', 'linewidth', 1)
    title(plot_name)
    [y_max, y_min, y_ticks]= get_axis(pos_xyz_des(:,i), pos_xyz_med(:,i), 4);
    yticks(round(y_ticks,1))
    axis([time(t_start) time(t_end+1), y_min y_max]);
    ax = gca; % current axes
    ax.FontSize = 12;
end         
    
    sgtitle('Cartesian Position', 'interpreter', 'latex', 'FontSize', 20)    
    
%% Lambda
clc, close all;
t_start = 1;
t_step  = 1;
t_end   = 6000;

lambda = [data.L1(t_start:t_step:t_end), data.L2(t_start:t_step:t_end), data.L3(t_start:t_step:t_end), ...
          data.L4(t_start:t_step:t_end), data.L5(t_start:t_step:t_end), data.L6(t_start:t_step:t_end)];

      
figure(1), hold on, grid on, box on;
    screen = get(0, 'ScreenSize');    
    set(gcf,'units','pixel','position',[screen(3)*0.05, screen(4)*0.1, screen(3)*0.9, screen(4)*0.8])

for i=1:6
    plot_name = strcat('$\lambda$',num2str(i));
    subplot(2, 3, i),
    plot(time(t_start:t_step:t_end), lambda(:, i), '-r', 'linewidth', 1), grid on, box on,
    [y_max, y_min, y_ticks]= get_axis(lambda(:,i), lambda(:,i), 4);
    yticks(y_ticks)
    axis([time(t_start) time(t_end+1), y_min y_max]);
    ax = gca; % current axes
    ax.FontSize = 12;
    title(plot_name, 'interpreter', 'latex','FontSize', 18)
   
end         
    
    sgtitle('Gradient descent', 'interpreter', 'latex', 'FontSize', 20)

    