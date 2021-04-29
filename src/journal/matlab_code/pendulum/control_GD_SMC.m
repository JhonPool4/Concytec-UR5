% journal
clc, clear all, close all

% controller
lambda = 1; % (N/m/rad)

% learning rate
dt = 1e-2;
alpha = 0.1*dt; % sintonizar
T = 5;

% convergence condition
eps = 1*(pi/180)*(T/dt); % 5°/period
%eps = 0.1*pi/180;

% initial conditions
q  = 0;  % (rad)
dq = 0;  % (rad/s)
ddq = 0;
dddq = 0;
u  = 0;  % (Nm)
% forward dynamics
[ddq, dq, q, M, b]=f_dynamics_pendulum(u, q, dq, dt);

% first derivative of lambda with respect of time
dJ_lambda = 0;

% dynamic simulation
k = 0; % discrete time

update = 1;
time = 40;
tt = 0:(T/dt):(time/dt);
e_acumulado = 0.0;
a = 1; 

while (k<time/dt)
    
    % desired position
    beta = pi/4;
    t = k*dt;
    w = 2*pi*(1/T);
    q_d  =   beta*cos(w*t);
    dq_d  = -beta*w*sin(w*t);
    ddq_d = -beta*w*w*cos(w*t);
    dddq_d = beta*w*w*w*sin(w*t);
    
    % error
    e = q_d - q;
    de = dq_d - dq;
    dde = ddq_d - ddq;
    ddde = dddq_d - dddq;
    
    % first derivative of lambda with respect of time
    dlambda = -(alpha/dt)*dJ_lambda;
    
    % s variable
    s = lambda.*lambda.*e + 2*lambda.*de;
    ds = 2*lambda*dlambda*e + lambda*lambda*de + 2*dlambda*de + 2*lambda*dde;
    
    % control signal
    b_est = u - M*ddq;
    %u = M*(s ) + b_est;
    u = M*( s + tanh(s)) + b_est;
    %u = M*(ddq_d +  s + tanh(s)) + b_est; % no usar xd
    
    % past value
    ddq_a = ddq;
    
    % forward dynamics
    [ddq, dq, q, M, b]=f_dynamics_pendulum(u, q, dq, dt);
    
    dddq = (ddq - ddq_a)/dt;
    
    % cost function
    gamma = 0.8;
    c = gamma * 0.5*s*s + (1-gamma)*0.5*ds*ds;
    
    if (update == 1) && (mod(k,2)==0)
        % gradient descent
        %dJ_lambda = -s*lambda*lambda*2*M*( lambda*e + de);
        du_lambda = 2*M*( lambda*e + de)*(2-tanh(s)*tanh(s));
        dJ_lambda = -gamma*s*lambda*lambda*du_lambda ...
                    -(1-gamma)*ds*2*lambda*dlambda*du_lambda;
                
        % new value of lambda
        lambda = lambda - alpha*dJ_lambda;
    end
    % discrete time
    k = k +1;
    
    % save data
    y_qd(k) = q_d;
    y_q(k) = q;
    y_e(k) = e;
    y_de(k) = de;
    y_dde(k) = dde;
    y_ddde(k) = ddde;
    y_lambda(k) = lambda;
    y_c(k) = c;
    y_best(k) = b_est;
    y_b(k) = b;
  
    % convergence condition
    if (update == 1)
        if (tt(a)<=k) && (k<tt(a+1)) % Periodo
            e_acumulado = e_acumulado + norm(e);
        else
            y_ee(a) = e_acumulado; % almacena error acumulado
            a = a + 1;             % rango de nuevo ciclo
            if (e_acumulado <= eps)
                k
                e_acumulado
                update = 0;
                dJ_lambda = 0;
            end
            e_acumulado = norm(e);
        end
    end
end
t_start= 500;  
% figure(1), grid  on, hold on
%             plot(y_qd(:), '-r')
%             plot(y_q(:), '--k')
%             title('angular position')
%             
 figure(2), grid on, hold on
             plot(y_lambda(:), 'k')
             title('lambda')
%             
% figure(3), grid on, hold on
%             plot(y_c(t_start:end), 'k')
%             title('cost function')

          
figure(4), grid on, hold on
            plot(y_e(t_start:end), 'r')
            plot(y_de(t_start:end), 'b')
            plot(y_dde(t_start:end),'--k')
            plot(y_ddde(t_start:end), '-.g')
            legend('e', 'de', 'dde', 'ddde')
            
% figure(5), grid on, hold on
%             plot(y_b(:), 'r')
%             plot(y_best(:), '--k')
            