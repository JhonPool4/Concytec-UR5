clc, clear all, close all;
% Lambda = 40; dt = 1e-3, Fi = 0.1/40; alpha = 5%
load('xdes.txt')
load('dxdes.txt')
load('qdes.txt')
load('dqdes.txt')
load('ddqdes.txt')
load('xmed.txt')
load('q.txt')
load('dq.txt')
load('ddq.txt')
load('time.txt')
load('u.txt')
load('Q_error.txt')

linewidth  = 2;
time = time*1e-3;

%% Operational Space: Position
error_X = 1000* (xdes(:,1) - xmed(:,1));    % mm
error_Y = 1000* (xdes(:,2) - xmed(:,2));    % mm
error_Z = 1000* (xdes(:,3) - xmed(:,3));    % mm

norm_e_x = sqrt(sum(abs(error_X).^2))/100;
norm_e_y = sqrt(sum(abs(error_Y).^2))/100;
norm_e_z = sqrt(sum(abs(error_Z).^2))/100;

close all
figure(1),
plot(time, 1000*xdes(:,1), 'r',time, 1000*xmed(:,1), 'k','linewidth', linewidth), grid on
title("X axis"), legend("desired", "measured"),
xlabel("[s]"), ylabel("[mm]")

figure(2),
plot(time, error_X, 'k','linewidth', linewidth), grid on
title("Error on X axis ("+num2str(round(norm_e_x,2))+" mm)"), 
xlabel("[s]"), ylabel("[mm]")
%%
%close all;

figure(3),
plot(time, 1000*xdes(:,2), 'r',time, 1000*xmed(:,2), 'k','linewidth', linewidth), grid on
title("Y axis"), legend("desired", "measured"),
xlabel("[s]"), ylabel("[mm]")

figure(4),
plot(time, error_Y, 'k','linewidth', linewidth), grid on
title("Error on Y axis ("+num2str(round(norm_e_y,2))+" mm)"), 
xlabel("[s]"), ylabel("[mm]")

%%
%close all;

figure(5),
plot(time, 1000*xdes(:,3), 'r',time, 1000*xmed(:,3), 'k','linewidth', linewidth), grid on
title("Z axis"), legend("desired", "measured"),
xlabel("[s]"), ylabel("[mm]")

figure(6),
plot(time, error_Z, 'k','linewidth', linewidth), grid on
title("Error on Z axis ("+num2str(round(norm_e_z,2))+" mm)"), 
xlabel("[s]"), ylabel("[mm]")


%% Operational Space: Orientation
%close all;

figure(7),
plot(time, xdes(:,4), 'r',time, xmed(:,4), 'k','linewidth', linewidth), grid on
title("w"), legend("desired", "measured")
xlabel("[s]"), ylabel("[rad]")

figure(8),
plot(time, xdes(:,5), 'r',time, xmed(:,5), 'k','linewidth', linewidth), grid on
title("e_{x}"), legend("desired", "measured")
xlabel("[s]"), ylabel("[rad]")
%axis([0 0.4 ex_min  ex_max])

figure(9),
plot(time, xdes(:,6), 'r',time, xmed(:,6), 'k','linewidth', linewidth), grid on
title("e_{y}"), legend("desired", "measured")
xlabel("[s]"), ylabel("[rad]")
%axis([0 0.4 ey_min ey_max])


figure(10),
plot(time, xdes(:,7), 'r',time, xmed(:,7), 'k','linewidth', linewidth), grid on
title("e_{z}"), legend("desired", "measured")
xlabel("[s]"), ylabel("[rad]")
%axis([0 0.4 ez_min ez_max])


























%% Joint space
close all

figure(1),

% Joint position Controlled
subplot(2,3,1),plot(time, qdes(:,1), 'r',time, q(:,1), 'k', 'linewidth', linewidth), grid on
title("Joint position q_{1}"), legend("desired", "measured"),
xlabel("[s]"), ylabel("[rad]")

subplot(2,3,2),plot(time, qdes(:,2), 'r',time, q(:,2), 'k','linewidth', linewidth), grid on
title("Joint position q_{2}"), legend("desired", "measured")
xlabel("[s]"), ylabel("[rad]")

subplot(2,3,3),plot(time, qdes(:,3), 'r',time, q(:,3), 'k','linewidth', linewidth), grid on
title("Joint position q_{3}"), legend("desired", "measured")
xlabel("[s]"), ylabel("[rad]")

subplot(2,3,4),plot(time, qdes(:,4), 'r',time, q(:,4), 'k','linewidth', linewidth), grid on
title("Joint position q_{4}"), legend("desired", "measured")
xlabel("[s]"), ylabel("[rad]")

subplot(2,3,5),plot(time, qdes(:,5), 'r',time, q(:,5), 'k','linewidth', linewidth), grid on
title("Joint position q_{5}"), legend("desired", "measured")
xlabel("[s]"), ylabel("[rad]")

subplot(2,3,6),plot(time, qdes(:,6), 'r',time, q(:,6), 'k','linewidth', linewidth), grid on
title("Joint position q_{6}"), legend("desired", "measured")
xlabel("[s]"), ylabel("[rad]")


%%
% Join position error
error_q1 = qdes(:,1) - q(:,1);
error_q2 = qdes(:,2) - q(:,2);
error_q3 = qdes(:,3) - q(:,3);
error_q4 = qdes(:,4) - q(:,4);
error_q5 = qdes(:,5) - q(:,5);
error_q6 = qdes(:,6) - q(:,6);

norm_e_q1 = sqrt(sum(abs(error_q1).^2))/1000;
norm_e_q2 = sqrt(sum(abs(error_q2).^2))/1000;
norm_e_q3 = sqrt(sum(abs(error_q3).^2))/1000;
norm_e_q4 = sqrt(sum(abs(error_q4).^2))/1000;
norm_e_q5 = sqrt(sum(abs(error_q5).^2))/1000;
norm_e_q6 = sqrt(sum(abs(error_q6).^2))/1000;


close all
figure(2),
subplot(2,3,1),plot(time, qdes(:,1) - q(:,1), 'k','linewidth', linewidth), grid on
title("Joint position error q_{1} ("+num2str(round(norm_e_q1,5))+" rad)"),
%title("Error on Y axis ("+num2str(round(norm_e_y,2))+" mm)"),
xlabel("[s]"), ylabel("[rad]")

subplot(2,3,2),plot(time, qdes(:,2) -q(:,2), 'k','linewidth', linewidth), grid on
title("Joint position error q_{2} ("+num2str(round(norm_e_q2,7))+" rad)"),
xlabel("[s]"), ylabel("[rad]")

subplot(2,3,3),plot(time, qdes(:,3) - q(:,3), 'k','linewidth', linewidth), grid on
title("Joint position error q_{3} ("+num2str(round(norm_e_q3,7))+" rad)"),
xlabel("[s]"), ylabel("[rad]")

subplot(2,3,4),plot(time, qdes(:,4) - q(:,4), 'k','linewidth', linewidth), grid on
title("Joint position error q_{4} ("+num2str(round(norm_e_q4,7))+" rad)"),
xlabel("[s]"), ylabel("[rad]")

subplot(2,3,5),plot(time, qdes(:,5) - q(:,5), 'k','linewidth', linewidth), grid on
title("Joint position error q_{5} ("+num2str(round(norm_e_q5,7))+" rad)"),
xlabel("[s]"), ylabel("[rad]")

subplot(2,3,6),plot(time, qdes(:,6) - q(:,6), 'k','linewidth', linewidth), grid on
title("Joint position error q_{6} ("+num2str(round(norm_e_q6,7))+" rad)"),
xlabel("[s]"), ylabel("[rad]")


%% Operational Space: Position
error_X = 1000* (xdes(:,1) - xmed(:,1));
error_Y = 1000* (xdes(:,2) - xmed(:,2));
error_Z = 1000* (xdes(:,3) - xmed(:,3));

norm_e_x = sqrt(sum(abs(error_X).^2))/1000;
norm_e_y = sqrt(sum(abs(error_Y).^2))/1000;
norm_e_z = sqrt(sum(abs(error_Z).^2))/1000;

close all
figure(3),
subplot(2,3,1),plot(time, 1000*xdes(:,1), 'r',time, 1000*xmed(:,1), 'k','linewidth', linewidth), grid on
title("X axis"), legend("desired", "measured"),
xlabel("[s]"), ylabel("[mm]")


subplot(2,3,2),plot(time, 1000*xdes(:,2), 'r',time, 1000*xmed(:,2), 'k','linewidth', linewidth), grid on
title("Y axis"), legend("desired", "measured")
xlabel("[s]"), ylabel("[mm]")

subplot(2,3,3),plot(time, 1000*xdes(:,3), 'r',time, 1000*xmed(:,3), 'k','linewidth', linewidth), grid on
title("Z axis"), legend("desired", "measured")
xlabel("[s]"), ylabel("[mm]")




subplot(2,3,4),plot(time, error_X, 'k'), grid on
title("Error on X axis ("+num2str(round(norm_e_x,2))+" mm)"), 
xlabel("[s]"), ylabel("[mm]")
%axis([0 1 -10 1])

subplot(2,3,5),plot(time, error_Y, 'k'), grid on
title("Error on Y axis ("+num2str(round(norm_e_y,2))+" mm)"),
xlabel("[s]"), ylabel("[mm]")

subplot(2,3,6),plot(time, error_Z, 'k'), grid on
title("Error on Z axis ("+num2str(round(norm_e_x,2))+" mm)"),
xlabel("[s]"), ylabel("[mm]")


%% Operational Space: Orientation
close all;

figure(4),
subplot(2,2,1),plot(time, xdes(:,4), 'r',time, xmed(:,4), 'k','linewidth', linewidth), grid on
title("w"), legend("desired", "measured")
xlabel("[s]"), ylabel("[rad]")

subplot(2,2,2),plot(time, xdes(:,5), 'r',time, xmed(:,5), 'k','linewidth', linewidth), grid on
title("e_{x}"), legend("desired", "measured")
xlabel("[s]"), ylabel("[rad]")
%axis([0 0.4 ex_min  ex_max])

subplot(2,2,3),plot(time, xdes(:,6), 'r',time, xmed(:,6), 'k','linewidth', linewidth), grid on
title("e_{y}"), legend("desired", "measured")
xlabel("[s]"), ylabel("[rad]")
%axis([0 0.4 ey_min ey_max])


subplot(2,2,4),plot(time, xdes(:,7), 'r',time, xmed(:,7), 'k','linewidth', linewidth), grid on
title("e_{z}"), legend("desired", "measured")
xlabel("[s]"), ylabel("[rad]")
%axis([0 0.4 ez_min ez_max])

%% Operational Space: Angle and Axis
close all;

%e = norm(xdes(:,5:7),2)

%Theta = 2*atan2();
%Axis  = xdes(:,5:7) ./ n




%%
close all;

norm_e_w = sqrt(sum(abs(Q_error(1)).^2))/1000;
norm_e_x = sqrt(sum(abs(Q_error(2)).^2))/1000;
norm_e_y = sqrt(sum(abs(Q_error(3)).^2))/1000;
norm_e_z = sqrt(sum(abs(Q_error(4)).^2))/1000;


figure(5),
% Joint position Controlled
subplot(2,2,1),plot(time, Q_error(:,1)+1, 'k', 'linewidth', linewidth), grid on
title("w ("+num2str(round(norm_e_w,12))+" )"),
xlabel("[s]"), ylabel("[rad]")

subplot(2,2,2),plot(time, Q_error(:,2), 'k','linewidth', linewidth), grid on
title("e_{x} ("+num2str(round(norm_e_x,12))+" )"),
xlabel("[s]"), ylabel("[rad]")

subplot(2,2,3),plot(time, Q_error(:,3), 'k','linewidth', linewidth), grid on
title("e_{y} ("+num2str(round(norm_e_y,12))+" )"),
xlabel("[s]"), ylabel("[rad]")

subplot(2,2,4),plot(time, Q_error(:,4), 'k','linewidth', linewidth), grid on
title("e_{z} ("+num2str(round(norm_e_z,12))+" )"),
xlabel("[s]"), ylabel("[rad]")




%% Effort control

figure(6),
linewidth  = 1.4;
% Joint position Controlled
subplot(2,3,1),plot(time, u(:,1), 'k', 'linewidth', linewidth), grid on
title("Force  \tau_{1}"),
xlabel("[s]"), ylabel("[Nm]")

subplot(2,3,2),plot(time, u(:,2), 'k','linewidth', linewidth), grid on
title("Force  \tau_{2}"),
xlabel("[s]"), ylabel("[Nm]")

subplot(2,3,3),plot(time, u(:,3), 'k','linewidth', linewidth), grid on
title("Force  \tau_{3}"),
xlabel("[s]"), ylabel("[Nm]")

subplot(2,3,4),plot(time, u(:,4), 'k','linewidth', linewidth), grid on
title("Force  \tau_{4}"),
xlabel("[s]"), ylabel("[Nm]")

subplot(2,3,5),plot(time, u(:,5), 'k','linewidth', linewidth), grid on
title("Force  \tau_{5}"),
xlabel("[s]"), ylabel("[Nm]")

subplot(2,3,6),plot(time, u(:,6), 'k','linewidth', linewidth), grid on
title("Force  \tau_{6}"),
xlabel("[s]"), ylabel("[Nm]")



















