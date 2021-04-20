% journal
clc, clear all, close all

% controller
kp = [1;1]; % (N/m/rad)
kd = [1;1]; % (Ns/m/rad)

% learning rate
dt = 1e-3;
alpha = 1*dt;
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
while(k< 60/dt)
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
    
    % s and ds variable
    s  = kp.*e + kd.*de;
    ds = dkp.*(e) + kp.*de + dkd.*(de) + kd.*(dde);
    
    % gradient descent     
    dJ_kp =  s.*e    +   ds.*(de);
    dJ_kd =  s.*de   +   ds.*(de);
    % new values of kp, kd
    if (update == 1)
        kp = kp + alpha*dJ_kp;
        kd = kd + alpha*dJ_kd;
    end
    % control signal
    tau = M*(kp.*e + kd.*de) + b + K*tanh(s);
    
    
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
    y_dddq(:,k) = ddq - ddq_a;
    y_e(:,k) = e;
    y_dde(:,k) = dde;
    y_kp(:,k) = kp;
    y_dkp(:,k) = dkp;
    y_dkd(:,k) = dkd;
    y_kd(:,k) = kd;
    y_tau(:,k) = tau;
    
    ddq_a = ddq;

    if (tt(a)<=k) && (k<tt(a+1))
        e_acumulado = e_acumulado + norm(e);
    else
        y_ee(a) = e_acumulado;
        a = a + 1;
        if (e_acumulado < eps)
            k
            e_acumulado
            update = 0;
        end
        e_acumulado = norm(e);
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
figure(6), plot(y_dddq(2,:)), hold on
           title('Jerk medido')

