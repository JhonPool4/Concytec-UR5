%@param tau: control signal         (N.m)       [2x1]
%@param q:   angular position       (rad)       [2x1]
%@param dq:  angular velocity       (rad/s)     [2x1]
%@param ddq: angular acceleration   (rad/s^2)   [2x1]
%@param dt:  sampling time          (s)
function [ddq, dq, q, M, b]=forward_dynamics(tau, q, dq, dt)
% robot parameters
g  = 9.81; % m/s^2;
m1 = 10; % kg
m2 = 10; % kg
l1 = 1; % kg
l2 = 1; % kg

% inertia matriz
M = [ m1*l1^2 + m2*l1^2 + m2*l2^2*sin(q(2))^2,   m2*l1*l2*cos(q(2))*cos(q(1))^2
     -m2*l1*l2*cos(q(2))*cos(q(1))^2,             m2*l2^2 ];

% nonlinear effects vector 
b = [2*m2*l2^2*sin(q(2))*cos(q(2))*dq(1)*dq(2) + m2*l1*l2*sin(q(2))*cos(q(1))^2*dq(2)^2
     2*m2*l1*l2*cos(q(2))*cos(q(1))*sin(q(1))*dq(1)^2 + m2*g*l2*sin(q(2)) ];

% update 
ddq = inv(M)*(tau - b);
dq  = dq + dt*ddq;
q   = q  + dt*dq;

% estimated  robot parameters
g  = 9.81; % m/s^2;
m1 = 10; % kg
m2 = 10; % kg
l1 = 1; % kg
l2 = 1; % kg


% inertia matriz
M = [ m1*l1^2 + m2*l1^2 + m2*l2^2*sin(q(2))^2,   m2*l1*l2*cos(q(2))*cos(q(1))^2
     -m2*l1*l2*cos(q(2))*cos(q(1))^2,             m2*l2^2 ];

% nonlinear effects vector 
b = [2*m2*l2^2*sin(q(2))*cos(q(2))*dq(1)*dq(2) + m2*l1*l2*sin(q(2))*cos(q(1))^2*dq(2)^2
     2*m2*l1*l2*cos(q(2))*cos(q(1))*sin(q(1))*dq(1)^2 + m2*g*l2*sin(q(2)) ];
end