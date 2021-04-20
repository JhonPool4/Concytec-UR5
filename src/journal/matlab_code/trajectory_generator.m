function [dddq_d, ddq_d, dq_d, q_d] = trajectory_generator(T, t)

alpha = pi/4;
beta  = pi/4;
f = 1/T;
w = 2*pi*f;  

q_d   =  [ alpha*sin(w*t);           beta*sin(w*t)]; % (rad)
dq_d  =  [ alpha*w*cos(w*t);         beta*w*cos(w*t)];   % (rad/s)
ddq_d =  [-alpha*w*w*sin(w*t);      -beta*w*w*sin(w*t)];   % (rad/s^2)
dddq_d = [-alpha*w*w*w*cos(w*t);    -beta*w*w*w*cos(w*t)];   % (rad/s^3)

%q_d = t*pi/100*[1;1];
%dq_d = pi/100*[1;1];
%ddq_d = 0*[1;1];
%dddq_d = 0*[1;1];
end

