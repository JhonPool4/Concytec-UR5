% journal
clc, clear all, close all

% controller
kp = [1;1]; % (N/m/rad)
kd = [1;1]; % (Ns/m/rad)

% learning rate
dt = 1e-3;
alpha = 1*dt; % sintonizar
T = 4;

% convergence condition
eps = 5*(pi/180)*(T/dt);

% initial conditions
q0 = [0; 0];  % (rad)
dq0 = [0; 0]; % (rad/s)
dJ_kp = [0; 0];
dJ_kd = [0; 0];
[ddq, dq, q, M, b]=forward_dynamics(0, q0, dq0, dt);
ddq_a = ddq;

k = 0; % discrete time


tt = 0:(T/dt):(60/dt);
e_acumulado = 0.0;
a = 1; 
update = 1;
PD = 1;
%gamma_kp = [0.5; 0.5];
%gamma_kd = [0.5; 0.5];
while(k< 20/dt)
    % discrete time
    k = k + 1;
    
    % desired position    
    [dddq_d, ddq_d, dq_d, q_d] = trajectory_generator(T, k*dt);
    
    % position, velocity and acceleration error
    e = q_d - q;
    de = dq_d - dq;
    dde = ddq_d - ddq;
    
    % derivative of kp and kd with respect to time
    dkp = alpha*(dJ_kp);
    dkd = alpha*(dJ_kd);
    
    % s and ds variabled
    s  = kp.*e + kd.*de;
    ds = dkp.*e + kp.*de + dkd.*de + kd.*(dde);
    
    if (PD == 1)
        % gradient descent (KP)
        gamma = 0.83; %0.83 
 
        dJ_kp =  gamma*s.*e    +   (1-gamma).*ds.*(de); 
        dJ_kd =  gamma*s.*de   +   (1-gamma).*ds.*(dde);
        gamma_kp = (s.*e)./(ds.*de);
        gamma_kd = (s.*de)./(ds.*dde);
    else
        % gradient descent (SMC)
        gamma = 1;
        dJ_kp = gamma*s.*e  + (1-gamma)*( (2-tanh(s).*tanh(s)).*ds.*( -2*gamma_kd.tanh(s).*(1-tanh(s).*tanh(s)).*ds.*e + (2-tanh(s).*tanh(s)).*de ) );
        dJ_kd = gamma*s.*de + (1-gamma)*( (2-tanh(s).*tanh(s)).*ds.*( -2*tanh(s).*(1-tanh(s).*tanh(s)).*ds.*de + (2-tanh(s).*tanh(s)).*dde ) );
    end
    
    % new values of kp, kd
    if (update == 1)
        kp = kp + alpha*dJ_kp;
        kd = kd + alpha*dJ_kd;
    end
    % control signal
    
    if (PD == 1)
        tau = M*( ddq_d + s) + b; % PD
    else
        tau = M*( ddq_d + s + tanh(s)) + b; % SMC
    end
    
    % send control signal
    [ddq, dq, q, M, b]=forward_dynamics(tau, q, dq, dt);

    % save data
    y_qd(:,k) = q_d;
    y_dqd(:,k) = dq_d;
    y_ddqd(:,k) = ddq_d;
    y_dddqd(:,k) = dddq_d;    
    y_q(:,k) = q;
    y_dq(:,k) = dq;
    y_ddq(:,k) = ddq;
    y_dddq(:,k) = dddq_d + ds;%ddq - ddq_a;
    y_e(:,k) = e;
    y_dde(:,k) = dde;
    y_kp(:,k) = kp;
    y_dkp(:,k) = dkp;
    y_dkd(:,k) = dkd;
    y_kd(:,k) = kd;
    y_tau(:,k) = tau;
    
    y_gamma_kp(:,k) = gamma_kp;
    y_gamma_kd(:,k) = gamma_kd;
    
    ddq_a = ddq;

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
            end
            e_acumulado = norm(e);
        end
    end
end

%%
figure(1), plot(y_qd(1,:)), hold on
           plot(y_q(1,:)) 
%%
figure(3), plot(y_e(1,:)), hold on
           plot(y_e(2,:))
           title('Error en posición angular')
           legend('alpha', 'beta')
           

%%   
figure(4), plot(y_kp(1,:)), hold on
           plot(y_kp(2,:))
           title('KP')
           legend('alpha', 'beta')

%%   
figure(5), plot(y_kd(1,:)), hold on
           plot(y_kd(2,:))
           title('KD')
           legend('alpha', 'beta')

%% jerk
figure(6), plot(y_dddq(2,:), 'b'), hold on
           plot(y_dddqd(2,:), '--r')
           
           legend('medido', 'deseado')

%% control signal
figure(7), hold on, grid on,
            plot(y_tau(1,:), 'b')
            plot(y_tau(2,:), '--r')