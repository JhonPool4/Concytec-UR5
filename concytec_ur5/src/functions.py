import numpy as np
from copy import copy
import rbdl

pi=np.pi

def dh(d, theta, a, alpha):
    """
    Calcular la matriz de transformacion homogenea asociada con los parametros
    de Denavit-Hartenberg del Robot UR5
    Los valores d, theta, a, alpha son escalares.
    - theta [rad]
    - alpha [rad]
    - d     [m]
    - a     [m]
    """
    T = np.array(
        [[np.cos(theta),    -np.cos(alpha)*np.sin(theta),   +np.sin(alpha)*np.sin(theta),   a*np.cos(theta)],
         [np.sin(theta),    +np.cos(alpha)*np.cos(theta),   -np.sin(alpha)*np.cos(theta),   a*np.sin(theta)],
         [      0      ,            +np.sin(alpha)      ,           +np.cos(alpha)      ,           d      ],
         [      0      ,                    0           ,                   0           ,           1      ]])


    return T

def fkine_ur5(q):
    """
    Calcular la cinematica directa del robot UR5 dados sus valores articulares. 
    q es un vector numpy de la forma [q1, q2, q3, q4, q5, q6]
	Longitudes (en metros)
    """
    
    
    T1 = dh(0.08916,          +q[0],    0.0,     +pi/2)
    T2 = dh(    0.0,          +q[1], -0.425,       0.0)
    T3 = dh(    0.0,          +q[2], -0.392,       0.0)
    T4 = dh(0.10915,          +q[3],    0.0,     +pi/2)
    T5 = dh(0.09465,       +pi+q[4],    0.0,     +pi/2)
    T6 = dh( 0.0823,       +pi+q[5],    0.0,       0.0)
    
    # Efector final con respecto a la base
    T = np.dot(np.dot(np.dot(np.dot(np.dot(T1,T2),T3),T4),T5),T6)
    return T

def jacobian_ur5(q, delta=0.0001):
    """
    Jacobiano analitico para la posicion del robot UR5. Retorna una matriz de 3x6
    y toma como entrada el vector de configuracion articular q=[q1, q2, q3, q4, q5, q6]
    """
    # Alocacion de memoria
    J = np.zeros((3,6))
    # Transformacion homogenea inicial (usando q)
    T = fkine_ur5(q)
    # Iteracion para la derivada de cada columna
    for i in xrange(6):
        # Copiar la configuracion articular inicial
        dq = copy(q);
        # Incrementar la articulacion i-esima usando un delta
        dq[i] = dq[i] + delta  
        dT = fkine_ur5(dq)
        
        J[:,i] = (dT[0:3, 3] - T[0:3, 3])/delta

    return J

def jacobian_pose_ur5(q, delta=0.0001):
    """
    Jacobiano analitico para la posicion y orientacion (usando un
    cuaternion). Retorna una matriz de 7x6 y toma como entrada el vector de
    configuracion articular q=[q1, q2, q3, q4, q5, q6]
    """
    J = np.zeros((7,6))
    # Transformacion homogenea inicial (usando q)
    T = fkine_ur5(q)
    Q = rot2quat(T[0:3,0:3])

    for i in xrange(6):
        dq      = copy(q)
        dq[i]   = dq[i] + delta
        dT      = fkine_ur5(dq)
        dQ      = rot2quat(dT[0:3,0:3])
        Jpos    = (dT[0:3,3] - T[0:3,3])/delta
        Jrot    = (dQ - Q)/delta
        #Jrot 	= np.squeeze(np.asarray(Jrot))
        J[:,i] = np.concatenate((Jpos, Jrot), axis=0)
   
    return J

def pseudoInversa(J):
	"""
	Calcula la pseudoinversa de Moore-Penrose y los minimos cuadrados amortiguados
	"""
	Jinv = np.linalg.pinv(J)
	return Jinv

def inversa(x):

	if np.linalg.norm(x) == 0:
		return np.zeros((6,6))
	else:
		return np.linalg.pinv(x)

def quatError(Qdes, Q):
    """
    Compute difference between quaterions.
    Input:
    ------
    	- Qdes: 	Desired quaternion
    	- Q   :		Current quaternion

    Output:
    -------
    	- Qe  :		Error quaternion	
    """

    we = Qdes[0]*Q[0] + np.dot(Qdes[1:4].transpose(),Q[1:4]) - 1
    e  = -Qdes[0]*Q[1:4] + Q[0]*Qdes[1:4] - np.cross(np.transpose(Qdes[1:4]), np.transpose(Q[1:4]))
    Qe = np.array([ we, e[0], e[1], e[2] ])

    return Qe    

def rot2quat(R):
    """
    Converts a rotation matrix to quaterion
    Input:
    ------
    	- R: Rotation matrix
    Output:
    -------
    	- Q: Quaternion [w, ex, ey, ez]
    """
    dEpsilon = 1e-6;
    quat = 4*[0.,]

    quat[0] = 0.5*np.sqrt(R[0,0]+R[1,1]+R[2,2]+1.0)
    if ( np.fabs(R[0,0]-R[1,1]-R[2,2]+1.0) < dEpsilon ):
        quat[1] = 0.0
    else:
        quat[1] = 0.5*np.sign(R[2,1]-R[1,2])*np.sqrt(R[0,0]-R[1,1]-R[2,2]+1.0)
    if ( np.fabs(R[1,1]-R[2,2]-R[0,0]+1.0) < dEpsilon ):
        quat[2] = 0.0
    else:
        quat[2] = 0.5*np.sign(R[0,2]-R[2,0])*np.sqrt(R[1,1]-R[2,2]-R[0,0]+1.0)
    if ( np.fabs(R[2,2]-R[0,0]-R[1,1]+1.0) < dEpsilon ):
        quat[3] = 0.0
    else:
        quat[3] = 0.5*np.sign(R[1,0]-R[0,1])*np.sqrt(R[2,2]-R[0,0]-R[1,1]+1.0)

    return np.array(quat)


def ikine_pose_ur5(xdes, dxdes, ddxdes, q0):
    """
    Calcular la cinematica inversa de UR5 con el metodo del jacobiano inverso.
    Los valores de K se obtuvieron experimentalmente.
	
	Inputs:
	-------
		- xdes	: 	Desired position and orientation vector
		- dxdes :	Desired linear and angular velocity vector
		- ddxdes: 	Desired linear and angular acceleration vector
		- q0	:	Initial joint configuration (It's very important)

	Outputs:
	--------		
		- qdes	:	Desired joint position
		- qdes  :	Desired joint velocity
		- ddqdes: 	Desired joint acceleration
    """    
    k_p             = 550;
    k_o             = 150;
    k               = np.diag([k_p, k_p, k_p, k_o, k_o, k_o, k_o])
    best_norm_e1    = 0.01
    best_norm_e2    = 0.01
    max_iter        = 20
    delta           = 0.001
    dq_p			= np.zeros(6)

    q  = copy(q0)
    for i in range(max_iter):
        T       = fkine_ur5(q)
        e1      = xdes[0:3] - T[0:3,3]
        e2      = quatError(xdes[3:7], rot2quat(T[0:3,0:3]))
        e       = np.concatenate((e1,e2), axis=0)
        de      = -np.dot(k,e)
        J       = jacobian_pose_ur5(q,delta)
        Jinv    = np.linalg.pinv(J)
        dq      = np.dot(Jinv, dxdes - de )
        q       = q + delta*dq
        
        if (np.linalg.norm(e2) < best_norm_e2) & (np.linalg.norm(e1)< best_norm_e1):

            best_norm_e2    =   np.linalg.norm(e2)
            best_norm_e1    =   np.linalg.norm(e1)
            q_best          =   q
            dq_best         =   dq
            ddq_best 		= 	(dq_best - dq_p)/delta
            #ddq_best        =   np.dot(Jinv, ( ddxdes - np.dot(dJ,dq_best) ))
            print("iter: ", i)
            print("norma position: ",best_norm_e1)
            print("norma orientation: ",best_norm_e2)
            #print("---------")

     	dq_p 	= dq
    return q_best, dq_best, ddq_best


def saturador(x):
	n = len(x)
	#print("nafads: ", n)
	a = np.zeros(n)

	for i in range(n):
		if abs(x[i]) <= 1:
			 a[i] = x[i]
		else:
			a[i] = np.sign(x[i])
	return a

def saturador_effort_control_UR5(u):
	size0 = 12*0.9
	size1 = 28*0.9
	size2 = 56*0.9
	size3 = 150*0.9
	size4 = 330*0.9

	if abs(u[0]) >= size3:
		u[0] = np.sign(u[0])*size3

	if abs(u[1]) >= size3:
		u[1] = np.sign(u[1])*size3
	
	if abs(u[2]) >= size3:
		u[2] = np.sign(u[2])*size3

	if abs(u[3]) >= size1:
		u[3] = np.sign(u[3])*size1

	if abs(u[4]) >= size1:
		u[4] = np.sign(u[4])*size1

	if abs(u[5]) >= size1:
		u[5] = np.sign(u[5])*size1

	return u


class Robot(object):
    def __init__(self, q0, dq0, ndof, dt):
        self.q 	= q0    # numpy array (ndof x 1)
        self.dq = dq0  # numpy array (ndof x 1)
        self.M 	= np.zeros([ndof, ndof])
        #self.c 	= np.zeros(ndof)
        #self.g 	= np.zeros(ndof)
        self.b 	= np.zeros(ndof)
        self.z 	= np.zeros(ndof)
        self.dt = dt
        self.robot = rbdl.loadModel('/home/utec/ros_ws/src/ur5/ur5_description/urdf/ur5_joint_limited_robot.urdf')

    def send_command(self, tau):
        tau = np.squeeze(np.asarray(tau))
        rbdl.CompositeRigidBodyAlgorithm(self.robot, self.q, self.M)
        #rbdl.InverseDynamics(self.robot, self.q, self.z, self.z, self.g)
        #rbdl.InverseDynamics(self.robot, self.q, self.dq, self.z, self.c); self.c = self.c-self.g
        rbdl.NonlinearEffects(self.robot, self.q, self.dq, self.b)
        self.ddq = np.linalg.inv(self.M).dot(tau-self.b)
        
        self.dq = self.dq + self.dt*self.ddq
        self.q = self.q + self.dt*self.dq
        
    def read_joint_positions(self):
        return self.q

    def read_joint_velocities(self):
        return self.dq

    def read_joint_acceleration(self):
        return self.ddq    

    def get_M(self):
        return self.M

    def get_b(self):
    	return self.b