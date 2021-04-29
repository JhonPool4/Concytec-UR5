% journal
clc, clear all, close all

% controller
lambda = 1*[1;1]; % (N/m/rad)

% learning rate
dt = 1e-2;
alpha = 0.01*dt; % sintonizar
T = 5;

% convergence condition
eps = 1*(pi/180)*(T/dt); % 5°/period

% initial conditions
q  = [0; 0];  % (rad)
dq = [0; 0];  % (rad/s)
dddq = [0; 0];
u  = [0; 0];  % (Nm)
% forward dynamics
[ddq, dq, q, M, b]=forward_dynamics(u, q, dq, dt);

% vectors
dJ_lambda = [0; 0];

% dynamic simulation
k = 1; % discrete time
update = 1;
time = 30;
tt = 0:(T/dt):(time/dt);
e_acumulado = 0.0;
a = 1; 


while(k< time/dt)      

    % desired position    
    [dddq_d, ddq_d, dq_d, q_d] = trajectory_generator(T, k*dt);

    % position, velocity and acceleration error
    e = q_d - q;
    de = dq_d - dq;
    dde = ddq_d - ddq;
    ddde = dddq_d - dddq;
       
    % first derivative of lambda with respect of time
    dlambda = -(alpha/dt)*dJ_lambda;
    
    % s variable
    s = lambda.*lambda.*e + 2*lambda.*de;
    ds = 2*lambda.*dlambda.*e + lambda.*lambda.*de + 2*dlambda.*de + 2*lambda.*dde;
    
    % control signal
    b_est = u - M*ddq;
    u = M*(s + tanh(s)) + b_est;
    
    % past value
    ddq_a = ddq;
    
    % forward dynamics
    [ddq, dq, q, M, b]=forward_dynamics(u, q, dq, dt);
    
    dddq = (ddq - ddq_a)/dt;
    
    % cost function
    gamma = 1;%0.9999;
    c = gamma*0.5*s.*s + (1-gamma)*0.5*ds.*ds;
    
    if (update == 1) && (mod(k,2)==0)
        % gradient descent
        du_lambda = 2*M*( lambda.*e + de).*(2-tanh(s).*tanh(s));
        dJ_lambda = -gamma*s.*lambda.*lambda.*du_lambda ...
                    -(1-gamma)*2*ds.*lambda.*dlambda.*du_lambda;
                
        % new value of lambda
        lambda = lambda - alpha*dJ_lambda;
    end
    % discrete time
    k = k +1;
   
    % save data
    y_qd(:,k) = q_d;
    y_q(:,k) = q;   
    y_e(:,k)   = e;
    y_de(:,k)  = de;
    y_dde(:,k) = dde; 
    y_ddde(:,k) = ddde;
    y_c(:,k)   = c;
    y_lambda(:,k) = lambda;

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


%%
close all
t_start = 500;
x = 1;

figure(1), grid on, hold on
            plot(y_e(x, t_start:end), 'r')
            plot(y_de(x, t_start:end), 'b')
            plot(y_dde(x, t_start:end),'--k')
            plot(y_ddde(x, t_start:end), '-.g')
           title('Error')
           %legend('q1', 'q2')

figure(2), grid on, hold on
            plot(y_c(x, t_start:end), 'k')
            title('cost function')
            
t_start = 1;           
figure(3), grid on, hold on
            plot(y_lambda(x, t_start:end), 'k')
            title('Lambda')
            



