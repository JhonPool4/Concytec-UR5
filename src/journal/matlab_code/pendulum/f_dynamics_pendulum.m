%@param tau: control signal         (N.m)       [2x1]
%@param q:   angular position       (rad)       [2x1]
%@param dq:  angular velocity       (rad/s)     [2x1]
%@param ddq: angular acceleration   (rad/s^2)   [2x1]
%@param dt:  sampling time          (s)
function [ddq, dq, q, M, b]=f_dynamics_pendulum(tau, q, dq, dt)

% robot parameters
g  = 9.81; % m/s^2;
m = 10; % kg
l = 1; % kg

M = m*l*l/3;
b = m*g*l*sin(q);

% update
ddq = inv(M)*( tau - b );
dq = dq + dt*ddq;
q = q + dt*dq;

% estimated: test with m = 8 kg
m = 7; % kg
l = 1; % kg

M = m*l*l/3;
b = m*g*l*sin(q);

end