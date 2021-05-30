% compare plots with different parameters

clc, clear all, close all;

Path = '/home/utec/catkin_ws/src/journal/src/Data/SMCi/circular_traj/';

file1 = 'articular_lambda_0.5_alpha_0.1_beta_0.001_gamma_1.0.csv';
file2 = 'articular_lambda_0.5_alpha_0.7_beta_0.001_gamma_1.0.csv';

data1 = readtable(fullfile(Path, file1),'PreserveVariableNames',true);
data2 = readtable(fullfile(Path, file2),'PreserveVariableNames',true);

time = 0:1/100:60;

t_start = 5000;
t_step  = 1;
t_end   = 6000;

len = (t_end - t_start)/t_step + 1;



% Desired 
pos_xyz_des = 1000*[data1.x_des(t_start:t_step:t_end), data1.y_des(t_start:t_step:t_end), data1.z_des(t_start:t_step:t_end)];

vel_xyz_des = 1000*[data1.dx_des(t_start:t_step:t_end), data1.dy_des(t_start:t_step:t_end), data1.dz_des(t_start:t_step:t_end)];

pos_des = (180/pi)*[data1.q1_des(t_start:t_step:t_end), data1.q2_des(t_start:t_step:t_end), data1.q3_des(t_start:t_step:t_end), ...
                    data1.q4_des(t_start:t_step:t_end), data1.q5_des(t_start:t_step:t_end), data1.q6_des(t_start:t_step:t_end)];

vel_des = (180/pi)*[data1.dq1_des(t_start:t_step:t_end), data1.dq2_des(t_start:t_step:t_end), data1.dq3_des(t_start:t_step:t_end), ...
                    data1.dq4_des(t_start:t_step:t_end), data1.dq5_des(t_start:t_step:t_end), data1.dq6_des(t_start:t_step:t_end)];
                
% DATA 1: measured
pos_med_1 = (180/pi)*[data1.q1(t_start:t_step:t_end), data1.q2(t_start:t_step:t_end), data1.q3(t_start:t_step:t_end), ...
                      data1.q4(t_start:t_step:t_end), data1.q5(t_start:t_step:t_end), data1.q6(t_start:t_step:t_end)];

vel_med_1 = (180/pi)*[data1.dq1(t_start:t_step:t_end), data1.dq2(t_start:t_step:t_end), data1.dq3(t_start:t_step:t_end), ...
                      data1.dq4(t_start:t_step:t_end), data1.dq5(t_start:t_step:t_end), data1.dq6(t_start:t_step:t_end)];                  
                    
pos_xyz_med_1 = 1000*[data1.x(t_start:t_step:t_end), data1.y(t_start:t_step:t_end), data1.z(t_start:t_step:t_end)];

vel_xyz_med_1 = 1000*[data1.dx(t_start:t_step:t_end), data1.dy(t_start:t_step:t_end), data1.dz(t_start:t_step:t_end)];


% DATA 2: measured
pos_med_2 = (180/pi)*[data2.q1(t_start:t_step:t_end), data2.q2(t_start:t_step:t_end), data2.q3(t_start:t_step:t_end), ...
                      data2.q4(t_start:t_step:t_end), data2.q5(t_start:t_step:t_end), data2.q6(t_start:t_step:t_end)];
                  
vel_med_2 = (180/pi)*[data2.dq1(t_start:t_step:t_end), data2.dq2(t_start:t_step:t_end), data2.dq3(t_start:t_step:t_end), ...
                      data2.dq4(t_start:t_step:t_end), data2.dq5(t_start:t_step:t_end), data2.dq6(t_start:t_step:t_end)];                  
                     
pos_xyz_med_2 = 1000*[data2.x(t_start:t_step:t_end), data2.y(t_start:t_step:t_end), data2.z(t_start:t_step:t_end)];

vel_xyz_med_2 = 1000*[data2.dx(t_start:t_step:t_end), data2.dy(t_start:t_step:t_end), data2.dz(t_start:t_step:t_end)];

%% joint position: tracking performance
clc, close all;

figure(1), hold on, grid on, box on;
    screen = get(0, 'ScreenSize');    
    set(gcf,'units','pixel','position',[screen(3)*0.05, screen(4)*0.1, screen(3)*0.9, screen(4)*0.8])

for i=1:6
    plot_name = strcat('q',num2str(i),' (°)');
    subplot(2, 3, i),
    plot(time(t_start:t_step:t_end), pos_des(:, i), '-r', 'linewidth', 1), hold on, grid on, box on,
    plot(time(t_start:t_step:t_end), pos_med_1(:, i), '--k', 'linewidth', 1), hold on, grid on, box on,
    plot(time(t_start:t_step:t_end), pos_med_2(:, i), '--b', 'linewidth', 1)
    title(plot_name)
    [y_max, y_min, y_ticks]= get_axis(pos_des(:,i), pos_med_1(:,i), 4);
    yticks(y_ticks)
    axis([time(t_start) time(t_end+1), y_min y_max]);
    ax = gca; % current axes
    ax.FontSize = 12;
end         
    
    sgtitle('Joint Position: Tracking Performance', 'interpreter', 'latex', 'FontSize', 20)

%% joint position: error tracking
clc, close all;

figure(1), hold on, grid on, box on;
    screen = get(0, 'ScreenSize');    
    set(gcf,'units','pixel','position',[screen(3)*0.05, screen(4)*0.1, screen(3)*0.9, screen(4)*0.8])

for i=1:6
    plot_name = strcat('q',num2str(i),' (°)');
    subplot(2, 3, i),
    plot(time(t_start:t_step:t_end), pos_des(:, i)-pos_med_1(:, i), '--k', 'linewidth', 1), hold on, grid on, box on,
    plot(time(t_start:t_step:t_end), pos_des(:, i)-pos_med_2(:, i), '--b', 'linewidth', 1)
    title(plot_name)
    [y_max, y_min, y_ticks]= get_axis(pos_des(:, i)-pos_med_1(:, i), pos_des(:, i)-pos_med_2(:, i), 4);
    yticks(y_ticks)
    axis([time(t_start) time(t_end+1), y_min y_max]);
    ax = gca; % current axes
    ax.FontSize = 12;
    %legend({'15', '20'}, 'Location', 'northeastoutside')
    
end         
    
    sgtitle('Joint Position: Tracking Error', 'interpreter', 'latex', 'FontSize', 20)

    
    
%% joint velocity: tracking performance
clc, close all;

figure(1), hold on, grid on, box on;
    screen = get(0, 'ScreenSize');    
    set(gcf,'units','pixel','position',[screen(3)*0.05, screen(4)*0.1, screen(3)*0.9, screen(4)*0.8])

for i=1:6
    plot_name = strcat('q',num2str(i),' (°)');
    subplot(2, 3, i),
    plot(time(t_start:t_step:t_end), vel_des(:, i), '-r', 'linewidth', 2), hold on, grid on, box on,
    plot(time(t_start:t_step:t_end), vel_med_1(:, i), '--k', 'linewidth', 1), hold on, grid on, box on,
    plot(time(t_start:t_step:t_end), vel_med_2(:, i), '--b', 'linewidth', 1)
    title(plot_name)
    [y_max, y_min, y_ticks]= get_axis(vel_des(:,i), vel_med_1(:,i), 4);
    yticks(y_ticks)
    axis([time(t_start) time(t_end+1), y_min y_max]);
    ax = gca; % current axes
    ax.FontSize = 12;
end         
    
    sgtitle('Joint Velocity: Tracking Performance', 'interpreter', 'latex', 'FontSize', 20)    

%% joint velocity: error tracking
clc, close all;

figure(1), hold on, grid on, box on;
    screen = get(0, 'ScreenSize');    
    set(gcf,'units','pixel','position',[screen(3)*0.05, screen(4)*0.1, screen(3)*0.9, screen(4)*0.8])

for i=1:6
    plot_name = strcat('dq',num2str(i),' (°)');
    subplot(2, 3, i),
    plot(time(t_start:t_step:t_end), vel_des(:, i)-vel_med_1(:, i), '--k', 'linewidth', 1), hold on, grid on, box on,
    plot(time(t_start:t_step:t_end), vel_des(:, i)-vel_med_2(:, i), '--b', 'linewidth', 1)
    title(plot_name)
    [y_max, y_min, y_ticks]= get_axis(vel_des(:, i)-vel_med_1(:, i), vel_des(:, i)-vel_med_2(:, i), 4);
    yticks(y_ticks)
    axis([time(t_start) time(t_end+1), y_min y_max]);
    ax = gca; % current axes
    ax.FontSize = 12;
    %legend({'15', '20'}, 'Location', 'northeastoutside')
    
end         
    
    sgtitle('Joint Velocity: Tracking Error', 'interpreter', 'latex', 'FontSize', 20)    

    
    
    
    
    
    
    
    
    
%% cartesian position: tracking performance
clc, close all;

axis_name = ['x', 'y', 'z', 'w', 'ex', 'ey', 'ez'];

figure(1), hold on, grid on, box on;
    screen = get(0, 'ScreenSize');    
    set(gcf,'units','pixel','position',[screen(3)*0.05, screen(4)*0.1, screen(3)*0.9, screen(4)*0.8])

for i=1:3
    plot_name = strcat(axis_name(i), ' (mm)');
    subplot(3, 1, i),
    plot(time(t_start:t_step:t_end), pos_xyz_des(:, i), '-r', 'linewidth', 1), hold on, grid on, box on,
    plot(time(t_start:t_step:t_end), pos_xyz_med_1(:, i), '--k', 'linewidth', 1), hold on, grid on, box on,
    plot(time(t_start:t_step:t_end), pos_xyz_med_2(:, i), '--b', 'linewidth', 1)
    title(plot_name)
    [y_max, y_min, y_ticks]= get_axis(pos_xyz_des(:,i), pos_xyz_med_1(:,i), 4);
    yticks(round(y_ticks,1))
    axis([time(t_start) time(t_end+1), y_min y_max]);
    ax = gca; % current axes
    ax.FontSize = 12;
end         

    sgtitle('Cartesian Position: Tracking Performance', 'interpreter', 'latex', 'FontSize', 20)    

%% cartesian position: error tracking
clc, close all;

axis_name = ['x', 'y', 'z', 'w', 'ex', 'ey', 'ez'];

figure(1), hold on, grid on, box on;
    screen = get(0, 'ScreenSize');    
    set(gcf,'units','pixel','position',[screen(3)*0.05, screen(4)*0.1, screen(3)*0.9, screen(4)*0.8])

for i=1:3
    plot_name = strcat(axis_name(i), ' (mm)');
    subplot(3, 1, i),
    plot(time(t_start:t_step:t_end), pos_xyz_des(:, i)-pos_xyz_med_1(:, i), '--k', 'linewidth', 1), hold on, grid on, box on,
    plot(time(t_start:t_step:t_end), pos_xyz_des(:, i)-pos_xyz_med_2(:, i), '--b', 'linewidth', 1)
    title(plot_name)
    [y_max, y_min, y_ticks]= get_axis(pos_xyz_des(:, i)-pos_xyz_med_1(:, i), pos_xyz_des(:, i)-pos_xyz_med_2(:, i), 4);
    yticks(y_ticks)
    axis([time(t_start) time(t_end+1), y_min y_max]);
    ax = gca; % current axes
    ax.FontSize = 12;
end         
    sgtitle('Cartesian Position: Tracking Error', 'interpreter', 'latex', 'FontSize', 20)

%% cartesian velocity: tracking performance
clc, close all;

axis_name = ['x', 'y', 'z', 'w', 'ex', 'ey', 'ez'];

figure(1), hold on, grid on, box on;
    screen = get(0, 'ScreenSize');    
    set(gcf,'units','pixel','position',[screen(3)*0.05, screen(4)*0.1, screen(3)*0.9, screen(4)*0.8])

for i=1:3
    plot_name = strcat(axis_name(i), ' (mm/s)');
    subplot(3, 1, i),
    plot(time(t_start:t_step:t_end), vel_xyz_des(:, i), '-r', 'linewidth', 2), hold on, grid on, box on,
    plot(time(t_start:t_step:t_end), vel_xyz_med_1(:, i), '--k', 'linewidth', 2), hold on, grid on, box on,
    plot(time(t_start:t_step:t_end), vel_xyz_med_2(:, i), '--b', 'linewidth', 2)
    title(plot_name)
    [y_max, y_min, y_ticks]= get_axis(vel_xyz_des(:,i), vel_xyz_med_1(:,i), 4);
    yticks(round(y_ticks,1))
    axis([time(t_start) time(t_end+1), y_min y_max]);
    ax = gca; % current axes
    ax.FontSize = 12;
end         

    sgtitle('Cartesian Velocity: Tracking Performance', 'interpreter', 'latex', 'FontSize', 20)       

%% cartesian velocity: error tracking
clc, close all;

axis_name = ['x', 'y', 'z', 'w', 'ex', 'ey', 'ez'];

figure(1), hold on, grid on, box on;
    screen = get(0, 'ScreenSize');    
    set(gcf,'units','pixel','position',[screen(3)*0.05, screen(4)*0.1, screen(3)*0.9, screen(4)*0.8])

for i=1:3
    plot_name = strcat(axis_name(i), ' (mm/s)');
    subplot(3, 1, i),
    plot(time(t_start:t_step:t_end), vel_xyz_des(:, i)-vel_xyz_med_1(:, i), '--k', 'linewidth', 1), hold on, grid on, box on,
    plot(time(t_start:t_step:t_end), vel_xyz_des(:, i)-vel_xyz_med_2(:, i), '--b', 'linewidth', 1)
    title(plot_name)
    [y_max, y_min, y_ticks]= get_axis(vel_xyz_des(:, i)-vel_xyz_med_1(:, i), vel_xyz_des(:, i)-vel_xyz_med_2(:, i), 4);
    yticks(y_ticks)
    axis([time(t_start) time(t_end+1), y_min y_max]);
    ax = gca; % current axes
    ax.FontSize = 12;
end         
    sgtitle('Cartesian Velocity: Tracking Error', 'interpreter', 'latex', 'FontSize', 20)    
    
    
%% adaptation: Lambda
clc, close all;
t_start = 1;
t_step  = 1;
t_end   = 6000;

lambda1 = [data1.L1(t_start:t_step:t_end), data1.L2(t_start:t_step:t_end), data1.L3(t_start:t_step:t_end), ...
           data1.L4(t_start:t_step:t_end), data1.L5(t_start:t_step:t_end), data1.L6(t_start:t_step:t_end)];

lambda2 = [data2.L1(t_start:t_step:t_end), data2.L2(t_start:t_step:t_end), data2.L3(t_start:t_step:t_end), ...
           data2.L4(t_start:t_step:t_end), data2.L5(t_start:t_step:t_end), data2.L6(t_start:t_step:t_end)];

      
figure(1), hold on, grid on, box on;
    screen = get(0, 'ScreenSize');    
    set(gcf,'units','pixel','position',[screen(3)*0.05, screen(4)*0.1, screen(3)*0.9, screen(4)*0.8])

for i=1:6
    plot_name = strcat('$\lambda$',num2str(i));
    subplot(2, 3, i),
    plot(time(t_start:t_step:t_end), lambda1(:, i), '--k', 'linewidth', 1), hold on, grid on, box on,
    plot(time(t_start:t_step:t_end), lambda2(:, i), '--b', 'linewidth', 1)
    [y_max, y_min, y_ticks]= get_axis(lambda1(:,i), lambda2(:,i), 4);
    yticks(y_ticks)
    axis([time(t_start) time(t_end+1), y_min y_max]);
    ax = gca; % current axes
    ax.FontSize = 12;
    title(plot_name, 'interpreter', 'latex','FontSize', 18)
   
end
    sgtitle('Gradient descent: Lambda', 'interpreter', 'latex', 'FontSize', 20)

%% adaptation: P
clc, close all;
t_start = 1;
t_step  = 1;
t_end   = 6000;

P1 = [data1.P1(t_start:t_step:t_end), data1.P2(t_start:t_step:t_end), data1.P3(t_start:t_step:t_end), ...
      data1.P4(t_start:t_step:t_end), data1.P5(t_start:t_step:t_end), data1.P6(t_start:t_step:t_end)];

P2 = [data2.P1(t_start:t_step:t_end), data2.P2(t_start:t_step:t_end), data2.P3(t_start:t_step:t_end), ...
      data2.P4(t_start:t_step:t_end), data2.P5(t_start:t_step:t_end), data2.P6(t_start:t_step:t_end)];

      
figure(1), hold on, grid on, box on;
    screen = get(0, 'ScreenSize');    
    set(gcf,'units','pixel','position',[screen(3)*0.05, screen(4)*0.1, screen(3)*0.9, screen(4)*0.8])

for i=1:6
    plot_name = strcat('$\lambda$',num2str(i));
    subplot(2, 3, i),
    plot(time(t_start:t_step:t_end), P1(:, i), '--k', 'linewidth', 1), hold on, grid on, box on,
    plot(time(t_start:t_step:t_end), P2(:, i), '--b', 'linewidth', 1)
    %[y_max, y_min, y_ticks]= get_axis(P1(:,i), P2(:,i), 4);
    %yticks(y_ticks)
    %axis([time(t_start) time(t_end+1), y_min y_max]);
    ax = gca; % current axes
    ax.FontSize = 12;
    title(plot_name, 'interpreter', 'latex','FontSize', 18)
   
end
    sgtitle('Gradient descent: P', 'interpreter', 'latex', 'FontSize', 20)

%% adaptation: J
clc, close all;
t_start = 1;
t_step  = 1;
t_end   = 6000;

J1 = [data1.J1(t_start:t_step:t_end), data1.J2(t_start:t_step:t_end), data1.J3(t_start:t_step:t_end), ...
      data1.J4(t_start:t_step:t_end), data1.J5(t_start:t_step:t_end), data1.J6(t_start:t_step:t_end)];

J2 = [data2.J1(t_start:t_step:t_end), data2.J2(t_start:t_step:t_end), data2.J3(t_start:t_step:t_end), ...
      data2.P4(t_start:t_step:t_end), data2.J5(t_start:t_step:t_end), data2.J6(t_start:t_step:t_end)];


figure(1), hold on, grid on, box on;
    screen = get(0, 'ScreenSize');    
    set(gcf,'units','pixel','position',[screen(3)*0.05, screen(4)*0.1, screen(3)*0.9, screen(4)*0.8])

for i=1:6
    plot_name = strcat('$\lambda$',num2str(i));
    subplot(2, 3, i),
    plot(time(t_start:t_step:t_end), J1(:, i), '--k', 'linewidth', 1), hold on, grid on, box on,
    plot(time(t_start:t_step:t_end), J2(:, i), '--b', 'linewidth', 1)
    [y_max, y_min, y_ticks]= get_axis(J1(:,i), J2(:,i), 4);
    yticks(y_ticks)
    axis([time(t_start) time(t_end+1), y_min y_max]);
    ax = gca; % current axes
    ax.FontSize = 12;
    title(plot_name, 'interpreter', 'latex','FontSize', 18)
   
end
    sgtitle('Gradient descent: J', 'interpreter', 'latex', 'FontSize', 20)


















