% compare plots with different parameters

clc, clear all, close all;

Path_data  = '/home/utec/catkin_ws/src/journal/src/Data/SMCi/circular_traj/';
Path_image = '/home/utec/catkin_ws/src/journal/src/images/SMCi/circular_traj/60_seg/';

file1 = 'articular_lambda_0.5_alpha_0.1_beta_0.001_gamma_0.999_t_60.csv'; % --k
file2 = 'articular_lambda_0.5_alpha_0.5_beta_0.001_gamma_0.999_t_60.csv'; % --b
file3 = 'articular_lambda_0.5_alpha_0.8_beta_0.001_gamma_0.999_t_60.csv'; % --b

%file2 = 'cartesian_lambda_10.0_alpha_0.0001_beta_0.001_gamma_0.999_v3.csv'; % --b

data1 = readtable(fullfile(Path_data, file1),'PreserveVariableNames',true);
data2 = readtable(fullfile(Path_data, file2),'PreserveVariableNames',true);
data3 = readtable(fullfile(Path_data, file3),'PreserveVariableNames',true);

%% plot settings
time = 0:1/100:600;

t_start = 1 + 5000;
t_step  = 1;
t_end   = 1 + 6000;

len = (t_end - t_start)/t_step + 1;

% colors
color1 = [0, 0.4470, 0.7410];               % black         --alpha=0.1 
color2 = [0.6350, 0.0780, 0.1840];       % dark blue     --alpha=0.5
color3 = [0.4660, 0.6740, 0.1880];      % dark green    --alpha=0.8

% frecuency
frec = 5;

% Data: desired
pos_xyz_des = 1000*[data1.x_des(t_start:t_step:t_end), data1.y_des(t_start:t_step:t_end), data1.z_des(t_start:t_step:t_end)];
pos_xyz_des = medfilt1(pos_xyz_des, frec);

vel_xyz_des = 1000*[data1.dx_des(t_start:t_step:t_end), data1.dy_des(t_start:t_step:t_end), data1.dz_des(t_start:t_step:t_end)];
vel_xyz_des = medfilt1(vel_xyz_des, frec);

accel_xyz_des = 1000*[data1.ddx_des(t_start:t_step:t_end), data1.ddy_des(t_start:t_step:t_end), data1.ddz_des(t_start:t_step:t_end)];
accel_xyz_des = medfilt1(accel_xyz_des, frec);

jerk_xyz_des = 1000*[data1.dddx_des(t_start:t_step:t_end), data1.dddy_des(t_start:t_step:t_end), data1.dddz_des(t_start:t_step:t_end)];
jerk_xyz_des = medfilt1(jerk_xyz_des, frec);

pos_des = (180/pi)*[data1.q1_des(t_start:t_step:t_end), data1.q2_des(t_start:t_step:t_end), data1.q3_des(t_start:t_step:t_end), ...
                    data1.q4_des(t_start:t_step:t_end), data1.q5_des(t_start:t_step:t_end), data1.q6_des(t_start:t_step:t_end)];
pos_des = medfilt1(pos_des, frec);
                
vel_des = (180/pi)*[data1.dq1_des(t_start:t_step:t_end), data1.dq2_des(t_start:t_step:t_end), data1.dq3_des(t_start:t_step:t_end), ...
                    data1.dq4_des(t_start:t_step:t_end), data1.dq5_des(t_start:t_step:t_end), data1.dq6_des(t_start:t_step:t_end)];
vel_des = medfilt1(vel_des, frec);

accel_des = (180/pi)*[data1.ddq1_des(t_start:t_step:t_end), data1.ddq2_des(t_start:t_step:t_end), data1.ddq3_des(t_start:t_step:t_end), ...
                      data1.ddq4_des(t_start:t_step:t_end), data1.ddq5_des(t_start:t_step:t_end), data1.ddq6_des(t_start:t_step:t_end)];                
accel_des = medfilt1(accel_des, frec);                

% DATA 1: measured
pos_med_1 = (180/pi)*[data1.q1(t_start:t_step:t_end), data1.q2(t_start:t_step:t_end), data1.q3(t_start:t_step:t_end), ...
                      data1.q4(t_start:t_step:t_end), data1.q5(t_start:t_step:t_end), data1.q6(t_start:t_step:t_end)];

pos_med_1 = medfilt1(pos_med_1, frec);

vel_med_1 = (180/pi)*[data1.dq1(t_start:t_step:t_end), data1.dq2(t_start:t_step:t_end), data1.dq3(t_start:t_step:t_end), ...
                      data1.dq4(t_start:t_step:t_end), data1.dq5(t_start:t_step:t_end), data1.dq6(t_start:t_step:t_end)];                  

vel_med_1 = medfilt1(vel_med_1, frec);

pos_xyz_med_1 = 1000*[data1.x(t_start:t_step:t_end), data1.y(t_start:t_step:t_end), data1.z(t_start:t_step:t_end)];
pos_xyz_med_1 = medfilt1(pos_xyz_med_1, frec);

vel_xyz_med_1 = 1000*[data1.dx(t_start:t_step:t_end), data1.dy(t_start:t_step:t_end), data1.dz(t_start:t_step:t_end)];
vel_xyz_med_1 = medfilt1(vel_xyz_med_1, frec);

accel_xyz_med_1 = 1000*[data1.ddx(t_start:t_step:t_end), data1.ddy(t_start:t_step:t_end), data1.ddz(t_start:t_step:t_end)];
accel_xyz_med_1 = medfilt1(accel_xyz_med_1, frec);

jerk_xyz_med_1  = 1000*[data1.dddx(t_start:t_step:t_end), data1.dddy(t_start:t_step:t_end), data1.dddz(t_start:t_step:t_end)];
jerk_xyz_med_1 = medfilt1(jerk_xyz_med_1, frec);

tau_med_1 = [data1.u1(t_start:t_step:t_end), data1.u2(t_start:t_step:t_end), data1.u3(t_start:t_step:t_end), ...
             data1.u4(t_start:t_step:t_end), data1.u5(t_start:t_step:t_end), data1.u6(t_start:t_step:t_end)];
tau_med_1 = medfilt1(tau_med_1, frec);

% DATA 2: measured
pos_med_2 = (180/pi)*[data2.q1(t_start:t_step:t_end), data2.q2(t_start:t_step:t_end), data2.q3(t_start:t_step:t_end), ...
                      data2.q4(t_start:t_step:t_end), data2.q5(t_start:t_step:t_end), data2.q6(t_start:t_step:t_end)];
pos_med_2 = medfilt1(pos_med_2, frec);
                  
vel_med_2 = (180/pi)*[data2.dq1(t_start:t_step:t_end), data2.dq2(t_start:t_step:t_end), data2.dq3(t_start:t_step:t_end), ...
                      data2.dq4(t_start:t_step:t_end), data2.dq5(t_start:t_step:t_end), data2.dq6(t_start:t_step:t_end)];                  
vel_med_2 = medfilt1(vel_med_2, frec);

pos_xyz_med_2 = 1000*[data2.x(t_start:t_step:t_end), data2.y(t_start:t_step:t_end), data2.z(t_start:t_step:t_end)];
pos_xyz_med_2 = medfilt1(pos_xyz_med_2, frec);

vel_xyz_med_2 = 1000*[data2.dx(t_start:t_step:t_end), data2.dy(t_start:t_step:t_end), data2.dz(t_start:t_step:t_end)];
vel_xyz_med_2 = medfilt1(vel_xyz_med_2, frec);

accel_xyz_med_2 = 1000*[data2.ddx(t_start:t_step:t_end), data2.ddy(t_start:t_step:t_end), data2.ddz(t_start:t_step:t_end)];
accel_xyz_med_2 = medfilt1(accel_xyz_med_2, frec);

jerk_xyz_med_2  = 1000*[data2.dddx(t_start:t_step:t_end), data2.dddy(t_start:t_step:t_end), data2.dddz(t_start:t_step:t_end)];
jerk_xyz_med_2 = medfilt1(jerk_xyz_med_2, frec);

tau_med_2 = [data2.u1(t_start:t_step:t_end), data2.u2(t_start:t_step:t_end), data2.u3(t_start:t_step:t_end), ...
             data2.u4(t_start:t_step:t_end), data2.u5(t_start:t_step:t_end), data2.u6(t_start:t_step:t_end)];
tau_med_2 = medfilt1(tau_med_2, frec);
         
% DATA 3: measured
pos_med_3 = (180/pi)*[data3.q1(t_start:t_step:t_end), data3.q2(t_start:t_step:t_end), data3.q3(t_start:t_step:t_end), ...
                      data3.q4(t_start:t_step:t_end), data3.q5(t_start:t_step:t_end), data3.q6(t_start:t_step:t_end)];
pos_med_3 = medfilt1(pos_med_3, frec);
                  
vel_med_3 = (180/pi)*[data3.dq1(t_start:t_step:t_end), data3.dq2(t_start:t_step:t_end), data3.dq3(t_start:t_step:t_end), ...
                      data3.dq4(t_start:t_step:t_end), data3.dq5(t_start:t_step:t_end), data3.dq6(t_start:t_step:t_end)];                  
vel_med_3 = medfilt1(vel_med_3, frec);
                                    
pos_xyz_med_3 = 1000*[data3.x(t_start:t_step:t_end), data3.y(t_start:t_step:t_end), data3.z(t_start:t_step:t_end)];
pos_xyz_med_2 = medfilt1(pos_xyz_med_2, frec);

vel_xyz_med_3 = 1000*[data3.dx(t_start:t_step:t_end), data3.dy(t_start:t_step:t_end), data3.dz(t_start:t_step:t_end)];
vel_xyz_med_3 = medfilt1(vel_xyz_med_3, frec);

accel_xyz_med_3 = 1000*[data3.ddx(t_start:t_step:t_end), data3.ddy(t_start:t_step:t_end), data3.ddz(t_start:t_step:t_end)];
accel_xyz_med_3 = medfilt1(accel_xyz_med_3, frec);

jerk_xyz_med_3  = 1000*[data3.dddx(t_start:t_step:t_end), data3.dddy(t_start:t_step:t_end), data3.dddz(t_start:t_step:t_end)];
jerk_xyz_med_3 = medfilt1(jerk_xyz_med_3, frec);

tau_med_3 = [data3.u1(t_start:t_step:t_end), data3.u2(t_start:t_step:t_end), data3.u3(t_start:t_step:t_end), ...
             data3.u4(t_start:t_step:t_end), data3.u5(t_start:t_step:t_end), data3.u6(t_start:t_step:t_end)];   
tau_med_3 = medfilt1(tau_med_3, frec);         
%% joint position: tracking performance
clc, close all;

figure(1), hold on, grid on, box on;
    screen = get(0, 'ScreenSize');    
    set(gcf,'units','pixel','position',[screen(3)*0.05, screen(4)*0.1, screen(3)*0.9, screen(4)*0.8])

for i=1:6
    %plot_name = strcat('$\tau$',num2str(i),' (Nm)');
    plot_name = strcat('$\mathrm{q}$',num2str(i),' ($^\circ$)');
    subplot(2, 3, i),
    plot(time(t_start:t_step:t_end), pos_des(:, i), '-k', 'linewidth', 2), hold on, grid on, box on,
    p1=plot(time(t_start:t_step:t_end), pos_med_1(:, i), 'color', color1, 'linestyle', '--','marker','o', 'linewidth', 1), %hold on, grid on, box on,
    p2=plot(time(t_start:t_step:t_end), pos_med_2(:, i), 'color', color2, 'linestyle', '--','marker','s', 'linewidth', 1), %hold on, grid on, box on,
    p3=plot(time(t_start:t_step:t_end), pos_med_3(:, i), 'color', color3, 'linestyle', '--','marker','^', 'linewidth', 1), %hold on, grid on, box on,
    title(plot_name, 'interpreter', 'latex')
    [y_max, y_min, y_ticks]= get_axis(pos_des(:,i), pos_med_1(:,i), 4, 2);
    yticks(y_ticks)
    xticks(time(t_start):2:time(t_end))
    axis([time(t_start) time(t_end), y_min y_max]);
    ax = gca; % current axes
    ax.FontSize = 18;
    set(gca,'TickLabelInterpreter','latex')
    p1.MarkerIndices = 1:150:length(pos_des(:,i));
    p2.MarkerIndices = 50:150:length(pos_des(:,i))-50;   
    p3.MarkerIndices = 100:150:length(pos_des(:,i))-100;
    
    p1.MarkerFaceColor = color1;
    p2.MarkerFaceColor = color2;
    p3.MarkerFaceColor = color3;

    p1.MarkerSize = 6;
    p2.MarkerSize = 6;
    p3.MarkerSize = 6;
end         
    
    sgtitle('Joint Position: Tracking Performance', 'interpreter', 'latex', 'FontSize', 25)
    % add a bit space to the figure
    fig = gcf;
    fig.Position(3) = fig.Position(3) + 75;
    % add legend
    Lgnd = legend({'desired','$\alpha$=0.1', '$\alpha$=0.5','$\alpha$=0.8'}, 'interpreter', 'latex');
    %title(Lgnd,'rada')
    Lgnd.FontSize = 18;
    Lgnd.Position(1) = 0.01;
    Lgnd.Position(2) = 0.65;    
    
    
% Save image
FileName     = strcat(Path_image, 'articular_SMCi_position_compare');
saveas(gcf,FileName,'epsc')  

%% joint position: error tracking
clc, close all;

figure(1), hold on, grid on, box on;
    screen = get(0, 'ScreenSize');    
    set(gcf,'units','pixel','position',[screen(3)*0.05, screen(4)*0.1, screen(3)*0.9, screen(4)*0.8])
    

for i=1:6
    plot_name = strcat('$\mathrm{q}$',num2str(i),' ($^\circ$)');
    subplot(2, 3, i), hold on, grid on, box on,
    p1=plot(time(t_start:t_step:t_end), pos_des(:, i)-pos_med_1(:, i), 'color', color1, 'linestyle', '--','marker','o', 'linewidth', 1),
    p2=plot(time(t_start:t_step:t_end), pos_des(:, i)-pos_med_2(:, i), 'color', color2, 'linestyle', '--','marker','s', 'linewidth', 1), %hold on, grid on, box on,
    p3=plot(time(t_start:t_step:t_end), pos_des(:, i)-pos_med_3(:, i), 'color', color3, 'linestyle', '--','marker','^', 'linewidth', 1), %hold on, grid on, box on,    
    
    title(plot_name, 'interpreter', 'latex')
    [y_max, y_min, y_ticks]= get_axis(pos_des(:, i)-pos_med_1(:, i), pos_des(:, i)-pos_med_3(:, i), 4, 3);
    yticks(y_ticks)
    xticks(time(t_start):2:time(t_end))
    axis([time(t_start) time(t_end), y_min y_max]);
    ax = gca; % current axes
    ax.FontSize = 18;
    set(gca,'TickLabelInterpreter','latex')  
    
    p1.MarkerIndices = 1:150:length(pos_des(:,i));
    p2.MarkerIndices = 50:150:length(pos_des(:,i))-50;   
    p3.MarkerIndices = 100:150:length(pos_des(:,i))-100;
    
    p1.MarkerFaceColor = color1;
    p2.MarkerFaceColor = color2;
    p3.MarkerFaceColor = color3;

    p1.MarkerSize = 6;
    p2.MarkerSize = 6;
    p3.MarkerSize = 6;    
end         
    sgtitle('Joint Position: Tracking Error', 'interpreter', 'latex', 'FontSize', 25)
    % add a bit space to the figure
    fig = gcf;
    fig.Position(3) = fig.Position(3) + 75;
    % add legend
    Lgnd = legend({'$\alpha$=0.1', '$\alpha$=0.5','$\alpha$=0.8'}, 'interpreter', 'latex');
    %title(Lgnd,'rada')
    Lgnd.FontSize = 18;
    Lgnd.Position(1) = 0.01;
    Lgnd.Position(2) = 0.65;    

% Save image
FileName     = strcat(Path_image, 'articular_SMCi_position_error_compare');
saveas(gcf,FileName,'epsc')      
    
%% joint velocity: tracking performance
clc, close all;

figure(1), hold on, grid on, box on;
    screen = get(0, 'ScreenSize');    
    set(gcf,'units','pixel','position',[screen(3)*0.05, screen(4)*0.1, screen(3)*0.9, screen(4)*0.8])

for i=1:6
    plot_name = strcat('$\mathrm{\dot{q}}$',num2str(i),' ($\frac{\circ}{s}$)');
    subplot(2, 3, i),
    plot(time(t_start:t_step:t_end), vel_des(:, i), '-k', 'linewidth', 2), hold on, grid on, box on,
    p1=plot(time(t_start:t_step:t_end), vel_med_1(:, i), 'color', color1, 'linestyle', '--','marker','o', 'linewidth', 1), %hold on, grid on, box on,
    p2=plot(time(t_start:t_step:t_end), vel_med_2(:, i), 'color', color2, 'linestyle', '--','marker','s', 'linewidth', 1), %hold on, grid on, box on,
    p3=plot(time(t_start:t_step:t_end), vel_med_3(:, i), 'color', color3, 'linestyle', '--','marker','^', 'linewidth', 1), %hold on, grid on, box on,    
    
    title(plot_name, 'interpreter', 'latex')
    [y_max, y_min, y_ticks]= get_axis(vel_des(:,i), vel_med_1(:,i), 4, 4);
    yticks(y_ticks)
    xticks(time(t_start):2:time(t_end))
    axis([time(t_start) time(t_end), y_min y_max]);
    ax = gca; % current axes
    ax.FontSize = 18;
    set(gca,'TickLabelInterpreter','latex')  
    
    p1.MarkerIndices = 1:150:length(pos_des(:,i));
    p2.MarkerIndices = 50:150:length(pos_des(:,i))-50;   
    p3.MarkerIndices = 100:150:length(pos_des(:,i))-100;
    
    p1.MarkerFaceColor = color1;
    p2.MarkerFaceColor = color2;
    p3.MarkerFaceColor = color3;

    p1.MarkerSize = 6;
    p2.MarkerSize = 6;
    p3.MarkerSize = 6; 
end         
    
    sgtitle('Joint Velocity: Tracking Performance', 'interpreter', 'latex', 'FontSize', 25)    
    % add a bit space to the figure
    fig = gcf;
    fig.Position(3) = fig.Position(3) + 75;
    % add legend
    Lgnd = legend({'desired','$\alpha$=0.1', '$\alpha$=0.5','$\alpha$=0.8'}, 'interpreter', 'latex');
    %title(Lgnd,'rada')
    Lgnd.FontSize = 18;
    Lgnd.Position(1) = 0.01;
    Lgnd.Position(2) = 0.65;    
    
% Save image
FileName     = strcat(Path_image, 'articular_SMCi_velocity_compare');
saveas(gcf,FileName,'epsc')    

%% joint velocity: error tracking
clc, close all;

figure(1), hold on, grid on, box on;
    screen = get(0, 'ScreenSize');    
    set(gcf,'units','pixel','position',[screen(3)*0.05, screen(4)*0.1, screen(3)*0.9, screen(4)*0.8])

for i=1:6
    plot_name = strcat('$\mathrm{\dot{q}}$',num2str(i),' ($\frac{\circ}{s}$)');
    subplot(2, 3, i), hold on, grid on, box on,
    p1=plot(time(t_start:t_step:t_end), vel_des(:, i)-vel_med_1(:, i), 'color', color1, 'linestyle', '--','marker','o', 'linewidth', 1), %hold on, grid on, box on,
    p2=plot(time(t_start:t_step:t_end), vel_des(:, i)-vel_med_2(:, i), 'color', color2, 'linestyle', '--','marker','s', 'linewidth', 1), %hold on, grid on, box on,
    p3=plot(time(t_start:t_step:t_end), vel_des(:, i)-vel_med_3(:, i), 'color', color3, 'linestyle', '--','marker','^', 'linewidth', 1), %hold on, grid on, box on,
   
    title(plot_name, 'interpreter', 'latex')    
    [y_max, y_min, y_ticks]= get_axis(vel_des(:, i)-vel_med_1(:, i), vel_des(:, i)-vel_med_2(:, i), 4, 4);
    yticks(y_ticks)
    xticks(time(t_start):2:time(t_end))
    axis([time(t_start) time(t_end), y_min y_max]);
    ax = gca; % current axes
    ax.FontSize = 18;
    set(gca,'TickLabelInterpreter','latex')  
    
    p1.MarkerIndices = 1:150:length(pos_des(:,i));
    p2.MarkerIndices = 50:150:length(pos_des(:,i))-50;   
    p3.MarkerIndices = 100:150:length(pos_des(:,i))-100;
    
    p1.MarkerFaceColor = color1;
    p2.MarkerFaceColor = color2;
    p3.MarkerFaceColor = color3;

    p1.MarkerSize = 6;
    p2.MarkerSize = 6;
    p3.MarkerSize = 6;
end         
    
    sgtitle('Joint Velocity: Tracking Error', 'interpreter', 'latex', 'FontSize', 25)    
    % add a bit space to the figure
    fig = gcf;
    fig.Position(3) = fig.Position(3) + 75;
    % add legend
    Lgnd = legend({'$\alpha$=0.1', '$\alpha$=0.5','$\alpha$=0.8'}, 'interpreter', 'latex');
    %title(Lgnd,'rada')
    Lgnd.FontSize = 18;
    Lgnd.Position(1) = 0.01;
    Lgnd.Position(2) = 0.65;  
    
FileName     = strcat(Path_image, 'articular_SMCi_velocity_error_compare');
saveas(gcf,FileName,'epsc')         












%% cartesian position: tracking performance
clc, close all;

axis_name = ["$x$", "$y$", "$z$", "$w$", "$ex$", "$ey$", "$ez$"];

figure(1), hold on, grid on, box on;
    screen = get(0, 'ScreenSize');    
    set(gcf,'units','pixel','position',[screen(3)*0.05, screen(4)*0.1, screen(3)*0.9, screen(4)*0.8])

for i=1:3
    plot_name = strcat(axis_name(i), ' (mm)');
    subplot(3, 1, i),
    plot(time(t_start:t_step:t_end), pos_xyz_des(:, i), '-k', 'linewidth', 2), hold on, grid on, box on,
    p1=plot(time(t_start:t_step:t_end), pos_xyz_med_1(:, i), 'color', color1, 'linestyle', '--','marker','o', 'linewidth', 2), %hold on, grid on, box on,
    p2=plot(time(t_start:t_step:t_end), pos_xyz_med_2(:, i), 'color', color2, 'linestyle', '--','marker','s', 'linewidth', 2), %hold on, grid on, box on,
    p3=plot(time(t_start:t_step:t_end), pos_xyz_med_3(:, i), 'color', color3, 'linestyle', '--','marker','^', 'linewidth', 2), %hold on, grid on, box on,    

    ylabel(plot_name, 'interpreter', 'latex')  
    [y_max, y_min, y_ticks]= get_axis(pos_xyz_des(:,i), pos_xyz_med_1(:,i), 3,0);
    yticks(y_ticks)
    xticks(time(t_start):2:time(t_end))
    axis([time(t_start) time(t_end), y_min y_max]);
    ax = gca; % current axes
    ax.FontSize = 18;
    set(gca,'TickLabelInterpreter','latex') 
    
    p1.MarkerIndices = 1:150:length(pos_des(:,i));
    p2.MarkerIndices = 50:150:length(pos_des(:,i))-50;   
    p3.MarkerIndices = 100:150:length(pos_des(:,i))-100;
    
    p1.MarkerFaceColor = color1;
    p2.MarkerFaceColor = color2;
    p3.MarkerFaceColor = color3;

    p1.MarkerSize = 8;
    p2.MarkerSize = 8;
    p3.MarkerSize = 8;    
end         

    sgtitle('Cartesian Position: Tracking Performance', 'interpreter', 'latex', 'FontSize', 25)    
    % add a bit space to the figure
    fig = gcf;
    fig.Position(3) = fig.Position(3) + 75;
    % add legend
    Lgnd = legend({'desired','$\alpha$=0.1', '$\alpha$=0.5','$\alpha$=0.8'}, 'interpreter', 'latex');
    %title(Lgnd,'rada')
    Lgnd.FontSize = 18;
    Lgnd.Position(1) = 0.92;
    Lgnd.Position(2) = 0.73;  
    
% save image
FileName     = strcat(Path_image, 'articular_SMCi_pos_xyz_compare');
saveas(gcf,FileName,'epsc')        
%% cartesian position: error tracking
clc, close all;

axis_name = ["$x$", "$y$", "$z$", "$w$", "$ex$", "$ey$", "$ez$"];

figure(1), hold on, grid on, box on;
    screen = get(0, 'ScreenSize');    
    set(gcf,'units','pixel','position',[screen(3)*0.05, screen(4)*0.1, screen(3)*0.9, screen(4)*0.8])

for i=1:3
    plot_name = strcat(axis_name(i), ' (mm)');
    subplot(3, 1, i), hold on, grid on, box on,
    p1=plot(time(t_start:t_step:t_end), pos_xyz_des(:, i)-pos_xyz_med_1(:, i), 'color', color1, 'linestyle', '--','marker','o', 'linewidth', 1), %hold on, grid on, box on,
    p2=plot(time(t_start:t_step:t_end), pos_xyz_des(:, i)-pos_xyz_med_2(:, i), 'color', color2, 'linestyle', '--','marker','s', 'linewidth', 1), %hold on, grid on, box on,
    p3=plot(time(t_start:t_step:t_end), pos_xyz_des(:, i)-pos_xyz_med_3(:, i), 'color', color3, 'linestyle', '--','marker','^', 'linewidth', 1), %hold on, grid on, box on,    
    
    ylabel(plot_name, 'interpreter', 'latex')
    [y_max, y_min, y_ticks]= get_axis(pos_xyz_des(:,i)-pos_xyz_med_1(:, i), pos_xyz_des(:,i)-pos_xyz_med_3(:,i), 3,2);
    yticks(y_ticks)
    xticks(time(t_start):2:time(t_end))
    axis([time(t_start) time(t_end), y_min y_max]);
    ax = gca; % current axes
    ax.FontSize = 18;
    set(gca,'TickLabelInterpreter','latex') 

    
    p1.MarkerIndices = 1:150:length(pos_des(:,i));
    p2.MarkerIndices = 50:150:length(pos_des(:,i))-50;   
    p3.MarkerIndices = 100:150:length(pos_des(:,i))-100;
    
    p1.MarkerFaceColor = color1;
    p2.MarkerFaceColor = color2;
    p3.MarkerFaceColor = color3;

    p1.MarkerSize = 8;
    p2.MarkerSize = 8;
    p3.MarkerSize = 8; 
end         
    sgtitle('Cartesian Position: Tracking Error', 'interpreter', 'latex', 'FontSize', 25)
    % add a bit space to the figure
    fig = gcf;
    fig.Position(3) = fig.Position(3) + 75;
    % add legend
    Lgnd = legend({'$\alpha$=0.1', '$\alpha$=0.5','$\alpha$=0.8'}, 'interpreter', 'latex');
    %title(Lgnd,'rada')
    Lgnd.FontSize = 18;
    Lgnd.Position(1) = 0.92;
    Lgnd.Position(2) = 0.75;      

% save image
FileName     = strcat(Path_image, 'articular_SMCi_pos_xyz_error_compare');
saveas(gcf,FileName,'epsc')      

%% cartesian velocity: tracking performance
clc, close all;

axis_name = ["$\dot{x}$", "$\dot{y}$", "$\dot{z}$", "$w$", "$ex$", "$ey$", "$ez$"];

figure(1), hold on, grid on, box on;
    screen = get(0, 'ScreenSize');    
    set(gcf,'units','pixel','position',[screen(3)*0.05, screen(4)*0.1, screen(3)*0.9, screen(4)*0.8])

for i=1:3
    plot_name = strcat(axis_name(i), ' ($\mathrm{\frac{mm}{s}}$)');
    subplot(3, 1, i),
    plot(time(t_start:t_step:t_end), vel_xyz_des(:, i), '-k', 'linewidth', 2), hold on, grid on, box on,
    p1=plot(time(t_start:t_step:t_end), vel_xyz_med_1(:, i), 'color', color1, 'linestyle', '--','marker','o', 'linewidth', 1), %hold on, grid on, box on,
    p2=plot(time(t_start:t_step:t_end), vel_xyz_med_2(:, i), 'color', color2, 'linestyle', '--','marker','s', 'linewidth', 1), %hold on, grid on, box on,
    p3=plot(time(t_start:t_step:t_end), vel_xyz_med_3(:, i), 'color', color3, 'linestyle', '--','marker','^', 'linewidth', 1), %hold on, grid on, box on,    
    
    ylabel(plot_name, 'interpreter', 'latex')
    [y_max, y_min, y_ticks]= get_axis(vel_xyz_des(:,i), vel_xyz_med_1(:,i), 4, 1);
    yticks(y_ticks)
    xticks(time(t_start):2:time(t_end))
    axis([time(t_start) time(t_end), y_min y_max]);
    ax = gca; % current axes
    ax.FontSize = 18;
    set(gca,'TickLabelInterpreter','latex') 
    
    p1.MarkerIndices = 1:150:length(pos_des(:,i));
    p2.MarkerIndices = 50:150:length(pos_des(:,i))-50;   
    p3.MarkerIndices = 100:150:length(pos_des(:,i))-100;
    
    p1.MarkerFaceColor = color1;
    p2.MarkerFaceColor = color2;
    p3.MarkerFaceColor = color3;

    p1.MarkerSize = 8;
    p2.MarkerSize = 8;
    p3.MarkerSize = 8; 
end         

    sgtitle('Cartesian Velocity: Tracking Performance', 'interpreter', 'latex', 'FontSize', 20)       
    % add a bit space to the figure
    fig = gcf;
    fig.Position(3) = fig.Position(3) + 75;
    % add legend
    Lgnd = legend({'desired','$\alpha$=0.1', '$\alpha$=0.5','$\alpha$=0.8'}, 'interpreter', 'latex');
    %title(Lgnd,'rada')
    Lgnd.FontSize = 18;
    Lgnd.Position(1) = 0.92;
    Lgnd.Position(2) = 0.75; 
    
% save image
FileName     = strcat(Path_image, 'articular_SMCi_vel_xyz_compare');
saveas(gcf,FileName,'epsc')          
    
%% cartesian velocity: error tracking
clc, close all;

axis_name = ["$\dot{x}$", "$\dot{y}$", "$\dot{z}$", "$ex$", "$ey$", "$ez$"];

figure(1), hold on, grid on, box on;
    screen = get(0, 'ScreenSize');    
    set(gcf,'units','pixel','position',[screen(3)*0.05, screen(4)*0.1, screen(3)*0.9, screen(4)*0.8])

for i=1:3
    plot_name = strcat(axis_name(i), ' ($\mathrm{\frac{mm}{s}}$)');
    subplot(3, 1, i), hold on , grid on, box on,
    p1=plot(time(t_start:t_step:t_end), vel_xyz_des(:, i)-vel_xyz_med_1(:, i), 'color', color1, 'linestyle', '--','marker','o', 'linewidth', 1), %hold on, grid on, box on,
    p2=plot(time(t_start:t_step:t_end), vel_xyz_des(:, i)-vel_xyz_med_2(:, i), 'color', color2, 'linestyle', '--','marker','s', 'linewidth', 1), %hold on, grid on, box on,
    p3=plot(time(t_start:t_step:t_end), vel_xyz_des(:, i)-vel_xyz_med_3(:, i), 'color', color3, 'linestyle', '--','marker','^', 'linewidth', 1), %hold on, grid on, box on,    
    
    ylabel(plot_name, 'interpreter', 'latex')
    [y_max, y_min, y_ticks]= get_axis(vel_xyz_des(:, i)-vel_xyz_med_1(:, i), vel_xyz_des(:, i)-vel_xyz_med_3(:, i), 4, 1);
    yticks(y_ticks)
    xticks(time(t_start):2:time(t_end))
    axis([time(t_start) time(t_end), y_min y_max]);
    ax = gca; % current axes
    ax.FontSize = 18;
    set(gca,'TickLabelInterpreter','latex') 
    
    p1.MarkerIndices = 1:150:length(pos_des(:,i));
    p2.MarkerIndices = 50:150:length(pos_des(:,i))-50;   
    p3.MarkerIndices = 100:150:length(pos_des(:,i))-100;
    
    p1.MarkerFaceColor = color1;
    p2.MarkerFaceColor = color2;
    p3.MarkerFaceColor = color3;

    p1.MarkerSize = 8;
    p2.MarkerSize = 8;
    p3.MarkerSize = 8; 
end         
    sgtitle('Cartesian Velocity: Tracking Error', 'interpreter', 'latex', 'FontSize', 20)    
     % add a bit space to the figure
    fig = gcf;
    fig.Position(3) = fig.Position(3) + 75;
    % add legend
    Lgnd = legend({'$\alpha$=0.1', '$\alpha$=0.5','$\alpha$=0.8'}, 'interpreter', 'latex');
    %title(Lgnd,'rada')
    Lgnd.FontSize = 18;
    Lgnd.Position(1) = 0.92;
    Lgnd.Position(2) = 0.75; 
     
% save image
FileName     = strcat(Path_image, 'articular_SMCi_vel_xyz_error_compare');
saveas(gcf,FileName,'epsc')          


%% cartesian acceleration: tracking performance
clc, close all;

axis_name = ["$\ddot{x}$", "$\ddot{y}$", "$\ddot{z}$", "$w$", "$ex$", "$ey$", "$ez$"];

figure(1), hold on, grid on, box on;
    screen = get(0, 'ScreenSize');    
    set(gcf,'units','pixel','position',[screen(3)*0.05, screen(4)*0.1, screen(3)*0.9, screen(4)*0.8])

for i=1:3
    plot_name = strcat(axis_name(i), ' ($\mathrm{\frac{mm}{s^2}}$)');
    subplot(3, 1, i),
    plot(time(t_start:t_step:t_end), accel_xyz_des(:, i), '-k', 'linewidth', 2), hold on, grid on, box on,
    p1=plot(time(t_start:t_step:t_end), accel_xyz_med_1(:, i), 'color', color1, 'linestyle', '--','marker','o', 'linewidth', 1), %hold on, grid on, box on,
    p2=plot(time(t_start:t_step:t_end), accel_xyz_med_2(:, i), 'color', color2, 'linestyle', '--','marker','s', 'linewidth', 1), %hold on, grid on, box on,
    p3=plot(time(t_start:t_step:t_end), accel_xyz_med_3(:, i), 'color', color3, 'linestyle', '--','marker','^', 'linewidth', 1), %hold on, grid on, box on,    
    
    ylabel(plot_name, 'interpreter', 'latex')
    [y_max, y_min, y_ticks]= get_axis(accel_xyz_med_1(:, i), accel_xyz_med_3(:, i), 4, 1);
    yticks(y_ticks)
    xticks(time(t_start):2:time(t_end))
    axis([time(t_start) time(t_end), y_min y_max]);
    ax = gca; % current axes
    ax.FontSize = 18;
    set(gca,'TickLabelInterpreter','latex') 
    
    p1.MarkerIndices = 1:150:length(pos_des(:,i));
    p2.MarkerIndices = 50:150:length(pos_des(:,i))-50;   
    p3.MarkerIndices = 100:150:length(pos_des(:,i))-100;
    
    p1.MarkerFaceColor = color1;
    p2.MarkerFaceColor = color2;
    p3.MarkerFaceColor = color3;

    p1.MarkerSize = 8;
    p2.MarkerSize = 8;
    p3.MarkerSize = 8; 
end         

    sgtitle('Cartesian Acceleration: Tracking Performance', 'interpreter', 'latex', 'FontSize', 20)       
     % add a bit space to the figure
    fig = gcf;
    fig.Position(3) = fig.Position(3) + 75;
    % add legend
    Lgnd = legend({'desired','$\alpha$=0.1', '$\alpha$=0.5','$\alpha$=0.8'}, 'interpreter', 'latex');
    %title(Lgnd,'rada')
    Lgnd.FontSize = 18;
    Lgnd.Position(1) = 0.92;
    Lgnd.Position(2) = 0.75;
    
% save image
FileName     = strcat(Path_image, 'articular_SMCi_accel_xyz_compare');
saveas(gcf,FileName,'epsc')   

%% cartesian acceleration: tracking error
clc, close all;

axis_name = ["$\ddot{x}$", "$\ddot{y}$", "$\ddot{z}$", "$w$", "$ex$", "$ey$", "$ez$"];

figure(1), hold on, grid on, box on;
    screen = get(0, 'ScreenSize');    
    set(gcf,'units','pixel','position',[screen(3)*0.05, screen(4)*0.1, screen(3)*0.9, screen(4)*0.8])

for i=1:3
    plot_name = strcat(axis_name(i), ' ($\mathrm{\frac{mm}{s^2}}$)');
    subplot(3, 1, i), hold on, grid on, box on,
    p1=plot(time(t_start:t_step:t_end), accel_xyz_des(:, i)-accel_xyz_med_1(:, i), 'color', color1, 'linestyle', '--','marker','o', 'linewidth', 1), %hold on, grid on, box on,
    p2=plot(time(t_start:t_step:t_end), accel_xyz_des(:, i)-accel_xyz_med_2(:, i), 'color', color2, 'linestyle', '--','marker','s', 'linewidth', 1), %hold on, grid on, box on,
    p3=plot(time(t_start:t_step:t_end), accel_xyz_des(:, i)-accel_xyz_med_3(:, i), 'color', color3, 'linestyle', '--','marker','^', 'linewidth', 1), %hold on, grid on, box on,    
    
    ylabel(plot_name, 'interpreter', 'latex')
    [y_max, y_min, y_ticks]= get_axis(accel_xyz_des(:, i)-accel_xyz_med_1(:, i), accel_xyz_des(:, i)-accel_xyz_med_3(:, i), 4, 1);
    yticks(y_ticks)
    xticks(time(t_start):2:time(t_end))
    axis([time(t_start) time(t_end), y_min y_max]);
    ax = gca; % current axes
    ax.FontSize = 18;
    set(gca,'TickLabelInterpreter','latex') 
    
    p1.MarkerIndices = 1:150:length(pos_des(:,i));
    p2.MarkerIndices = 50:150:length(pos_des(:,i))-50;   
    p3.MarkerIndices = 100:150:length(pos_des(:,i))-100;
    
    p1.MarkerFaceColor = color1;
    p2.MarkerFaceColor = color2;
    p3.MarkerFaceColor = color3;

    p1.MarkerSize = 8;
    p2.MarkerSize = 8;
    p3.MarkerSize = 8; 
end         

    sgtitle('Cartesian Acceleration: Tracking Error', 'interpreter', 'latex', 'FontSize', 20)       
     % add a bit space to the figure
    fig = gcf;
    fig.Position(3) = fig.Position(3) + 75;
    % add legend
    Lgnd = legend({'$\alpha$=0.1', '$\alpha$=0.5','$\alpha$=0.8'}, 'interpreter', 'latex');
    %title(Lgnd,'rada')
    Lgnd.FontSize = 18;
    Lgnd.Position(1) = 0.92;
    Lgnd.Position(2) = 0.75;
    
% save image
FileName     = strcat(Path_image, 'articular_SMCi_accel_xyz_error_compare');
saveas(gcf,FileName,'epsc')   

%% cartesian jerk: tracking performance
clc, close all;

axis_name = ["$\ddot{x}$", "$\ddot{y}$", "$\ddot{z}$", "$w$", "$ex$", "$ey$", "$ez$"];

figure(1), hold on, grid on, box on;
    screen = get(0, 'ScreenSize');    
    set(gcf,'units','pixel','position',[screen(3)*0.05, screen(4)*0.1, screen(3)*0.9, screen(4)*0.8])

for i=1:3
    plot_name = strcat(axis_name(i), ' ($\mathrm{\frac{mm}{s^3}}$)');
    subplot(3, 1, i),
    plot(time(t_start:t_step:t_end), jerk_xyz_des(:, i), '-k', 'linewidth', 2), hold on, grid on, box on,
    p1=plot(time(t_start:t_step:t_end), jerk_xyz_med_1(:, i), 'color', color1, 'linestyle', '--','marker','o', 'linewidth', 1), %hold on, grid on, box on,
    p2=plot(time(t_start:t_step:t_end), jerk_xyz_med_2(:, i), 'color', color2, 'linestyle', '--','marker','s', 'linewidth', 1), %hold on, grid on, box on,
    p3=plot(time(t_start:t_step:t_end), jerk_xyz_med_3(:, i), 'color', color3, 'linestyle', '--','marker','^', 'linewidth', 1), %hold on, grid on, box on,    
    
    ylabel(plot_name, 'interpreter', 'latex')
    [y_max, y_min, y_ticks]= get_axis(jerk_xyz_med_1(:, i), jerk_xyz_med_3(:, i), 4, 1);
    yticks(y_ticks)
    xticks(time(t_start):2:time(t_end))
    axis([time(t_start) time(t_end), y_min y_max]);
    ax = gca; % current axes
    ax.FontSize = 18;
    set(gca,'TickLabelInterpreter','latex') 
    
    p1.MarkerIndices = 1:150:length(pos_des(:,i));
    p2.MarkerIndices = 50:150:length(pos_des(:,i))-50;   
    p3.MarkerIndices = 100:150:length(pos_des(:,i))-100;
    
    p1.MarkerFaceColor = color1;
    p2.MarkerFaceColor = color2;
    p3.MarkerFaceColor = color3;

    p1.MarkerSize = 8;
    p2.MarkerSize = 8;
    p3.MarkerSize = 8; 
end         

    sgtitle('Cartesian Jerk: Tracking Performance', 'interpreter', 'latex', 'FontSize', 20)       
     % add a bit space to the figure
    fig = gcf;
    fig.Position(3) = fig.Position(3) + 75;
    % add legend
    Lgnd = legend({'desired','$\alpha$=0.1', '$\alpha$=0.5','$\alpha$=0.8'}, 'interpreter', 'latex');
    %title(Lgnd,'rada')
    Lgnd.FontSize = 18;
    Lgnd.Position(1) = 0.92;
    Lgnd.Position(2) = 0.75;
    
% save image
FileName     = strcat(Path_image, 'articular_SMCi_jerk_xyz_compare');
saveas(gcf,FileName,'epsc')   

%% cartesian jerk: tracking error
clc, close all;

axis_name = ["$\ddot{x}$", "$\ddot{y}$", "$\ddot{z}$", "$w$", "$ex$", "$ey$", "$ez$"];

figure(1), hold on, grid on, box on;
    screen = get(0, 'ScreenSize');    
    set(gcf,'units','pixel','position',[screen(3)*0.05, screen(4)*0.1, screen(3)*0.9, screen(4)*0.8])

for i=1:3
    plot_name = strcat(axis_name(i), ' ($\mathrm{\frac{mm}{s^2}}$)');
    subplot(3, 1, i), hold on, grid on, box on,
    p1=plot(time(t_start:t_step:t_end), jerk_xyz_des(:, i)-jerk_xyz_med_1(:, i), 'color', color1, 'linestyle', '--','marker','o', 'linewidth', 1), %hold on, grid on, box on,
    p2=plot(time(t_start:t_step:t_end), jerk_xyz_des(:, i)-jerk_xyz_med_2(:, i), 'color', color2, 'linestyle', '--','marker','s', 'linewidth', 1), %hold on, grid on, box on,
    p3=plot(time(t_start:t_step:t_end), jerk_xyz_des(:, i)-jerk_xyz_med_3(:, i), 'color', color3, 'linestyle', '--','marker','^', 'linewidth', 1), %hold on, grid on, box on,    
    
    ylabel(plot_name, 'interpreter', 'latex')
    [y_max, y_min, y_ticks]= get_axis(jerk_xyz_des(:, i)-jerk_xyz_med_1(:, i), jerk_xyz_des(:, i)-jerk_xyz_med_3(:, i), 4, 1);
    yticks(y_ticks)
    xticks(time(t_start):2:time(t_end))
    axis([time(t_start) time(t_end), y_min y_max]);
    ax = gca; % current axes
    ax.FontSize = 18;
    set(gca,'TickLabelInterpreter','latex') 
    
    p1.MarkerIndices = 1:150:length(pos_des(:,i));
    p2.MarkerIndices = 50:150:length(pos_des(:,i))-50;   
    p3.MarkerIndices = 100:150:length(pos_des(:,i))-100;
    
    p1.MarkerFaceColor = color1;
    p2.MarkerFaceColor = color2;
    p3.MarkerFaceColor = color3;

    p1.MarkerSize = 8;
    p2.MarkerSize = 8;
    p3.MarkerSize = 8; 
end         

    sgtitle('Cartesian Jerk: Tracking Error', 'interpreter', 'latex', 'FontSize', 20)       
     % add a bit space to the figure
    fig = gcf;
    fig.Position(3) = fig.Position(3) + 75;
    % add legend
    Lgnd = legend({'$\alpha$=0.1', '$\alpha$=0.5','$\alpha$=0.8'}, 'interpreter', 'latex');
    %title(Lgnd,'rada')
    Lgnd.FontSize = 18;
    Lgnd.Position(1) = 0.92;
    Lgnd.Position(2) = 0.75;
    
% save image
FileName     = strcat(Path_image, 'articular_SMCi_jerk_xyz_error_compare');
saveas(gcf,FileName,'epsc')   









%% Control signal
clc, close all;

figure(1), hold on, grid on, box on;
    screen = get(0, 'ScreenSize');    
    set(gcf,'units','pixel','position',[screen(3)*0.05, screen(4)*0.1, screen(3)*0.9, screen(4)*0.8])

for i=1:6
    plot_name = strcat('$\tau$',num2str(i),' (Nm)');
    subplot(2, 3, i),
    plot(time(t_start:t_step:t_end), tau_med_1(:, i), '--k', 'linewidth', 2), hold on, grid on, box on,
    plot(time(t_start:t_step:t_end), tau_med_2(:, i), '--b', 'linewidth', 1)
    title(plot_name, 'interpreter', 'latex','FontSize', 18)
    [y_max, y_min, y_ticks]= get_axis(tau_med_1(:,i), tau_med_2(:,i), 4, 4);
    yticks(y_ticks)
    axis([time(t_start) time(t_end), y_min y_max]);
    ax = gca; % current axes
    ax.FontSize = 12;
end        

    sgtitle('Control signal', 'interpreter', 'latex', 'FontSize', 20)    
    
    
    
    
    
    
%% adaptation: Lambda
clc, close all;
t_start = 1 + 0;
%t_step  = 1;
%t_end   = 1 + 6000;

lambda_1 = [data1.L1(t_start:t_step:t_end), data1.L2(t_start:t_step:t_end), data1.L3(t_start:t_step:t_end), ...
           data1.L4(t_start:t_step:t_end), data1.L5(t_start:t_step:t_end), data1.L6(t_start:t_step:t_end)];


lambda_2 = [data2.L1(t_start:t_step:t_end), data2.L2(t_start:t_step:t_end), data2.L3(t_start:t_step:t_end), ...
           data2.L4(t_start:t_step:t_end), data2.L5(t_start:t_step:t_end), data2.L6(t_start:t_step:t_end)];
       
       
lambda_3 = [data3.L1(t_start:t_step:t_end), data3.L2(t_start:t_step:t_end), data3.L3(t_start:t_step:t_end), ...
           data3.L4(t_start:t_step:t_end), data3.L5(t_start:t_step:t_end), data3.L6(t_start:t_step:t_end)];       

      
figure(1), hold on, grid on, box on;
    screen = get(0, 'ScreenSize');    
    set(gcf,'units','pixel','position',[screen(3)*0.05, screen(4)*0.1, screen(3)*0.9, screen(4)*0.8])

for i=1:6
    plot_name = strcat('$\lambda$',num2str(i));
    subplot(2, 3, i),
    hold on, grid on, box on,
    p1=plot(time(t_start:t_step:t_end), lambda_1(:, i), 'color', color1, 'linestyle', '--','marker','o', 'linewidth', 1), %hold on, grid on, box on,
    p2=plot(time(t_start:t_step:t_end), lambda_2(:, i), 'color', color2, 'linestyle', '--','marker','s', 'linewidth', 1), %hold on, grid on, box on,
    p3=plot(time(t_start:t_step:t_end), lambda_3(:, i), 'color', color3, 'linestyle', '--','marker','^', 'linewidth', 1), %hold on, grid on, box on,    
    
    title(plot_name, 'interpreter', 'latex')
    [y_max, y_min, y_ticks]= get_axis(lambda_1(:, i), lambda_3(:, i), 4, 10);
    yticks(y_ticks)
    xticks(time(t_start):10:time(t_end))
    axis([time(t_start) time(t_end), y_min y_max]);
    ax = gca; % current axes
    ax.FontSize = 18;
    set(gca,'TickLabelInterpreter','latex') 
    
    p1.MarkerIndices = 1:600:length(lambda_1(:,i));
    p2.MarkerIndices = 200:600:length(lambda_2(:,i))-200;   
    p3.MarkerIndices = 400:600:length(lambda_3(:,i))-400;
    
    p1.MarkerFaceColor = color1;
    p2.MarkerFaceColor = color2;
    p3.MarkerFaceColor = color3;

    p1.MarkerSize = 8;
    p2.MarkerSize = 8;
    p3.MarkerSize = 8; 
   
end
    sgtitle('Gradient descent: Lambda', 'interpreter', 'latex', 'FontSize', 20)

% save image
%FileName     = strcat(Path_image, 'articular_SMCi_lambda_compare');
%saveas(gcf,FileName,'epsc')          
    
%% adaptation: P1
clc, close all;
t_start = 1 + 59000;
t_step  = 1;
t_end   = 1 + 60000;

P1 = [data1.P1(t_start:t_step:t_end), data1.P2(t_start:t_step:t_end), data1.P3(t_start:t_step:t_end), ...
      data1.P4(t_start:t_step:t_end), data1.P5(t_start:t_step:t_end), data1.P6(t_start:t_step:t_end)];

P2 = [data2.P1(t_start:t_step:t_end), data2.P2(t_start:t_step:t_end), data2.P3(t_start:t_step:t_end), ...
      data2.P4(t_start:t_step:t_end), data2.P5(t_start:t_step:t_end), data2.P6(t_start:t_step:t_end)];

      
figure(1), hold on, grid on, box on;
    screen = get(0, 'ScreenSize');    
    set(gcf,'units','pixel','position',[screen(3)*0.05, screen(4)*0.1, screen(3)*0.9, screen(4)*0.8])

for i=1:6
    plot_name = strcat('P',num2str(i));
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
    
%% adaptation: P2
clc, close all;
t_start = 1 + 5000;
t_step  = 1;
t_end   = 1 + 6000;

J1 = [data1.J1(t_start:t_step:t_end), data1.J2(t_start:t_step:t_end), data1.J3(t_start:t_step:t_end), ...
      data1.J4(t_start:t_step:t_end), data1.J5(t_start:t_step:t_end), data1.J6(t_start:t_step:t_end)];

J2 = [data2.J1(t_start:t_step:t_end), data2.J2(t_start:t_step:t_end), data2.J3(t_start:t_step:t_end), ...
      data2.P4(t_start:t_step:t_end), data2.J5(t_start:t_step:t_end), data2.J6(t_start:t_step:t_end)];


figure(1), hold on, grid on, box on;
    screen = get(0, 'ScreenSize');    
    set(gcf,'units','pixel','position',[screen(3)*0.05, screen(4)*0.1, screen(3)*0.9, screen(4)*0.8])

for i=1:6
    plot_name = strcat('J',num2str(i));
    subplot(2, 3, i),
    plot(time(t_start:t_step:t_end), J1(:, i), '--k', 'linewidth', 1), hold on, grid on, box on,
    plot(time(t_start:t_step:t_end), J2(:, i), '--b', 'linewidth', 1)
    [y_max, y_min, y_ticks]= get_axis(J1(:,i), J2(:,i), 4);
    yticks(y_ticks)
    axis([time(t_start) time(t_end), y_min y_max]);
    ax = gca; % current axes
    ax.FontSize = 12;
    title(plot_name, 'interpreter', 'latex','FontSize', 18)
   
end
    sgtitle('Gradient descent: J', 'interpreter', 'latex', 'FontSize', 20)


















