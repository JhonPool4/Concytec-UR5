import numpy as np
from copy import copy
import rbdl

#cos=np.cos; sin=np.sin; 
pi=np.pi


def dh(d, theta, a, alpha):
    """
    Calcular la matriz de transformacion homogenea asociada con los parametros
    de Denavit-Hartenberg.
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

    """
    # Longitudes (en metros)
     # Matrices DH (completar)
    
    T1 = dh(0.08916,          +q[0],    0.0,     +pi/2)
    T2 = dh(    0.0,          +q[1], -0.425,       0.0)
    T3 = dh(    0.0,          +q[2], -0.392,       0.0)
    T4 = dh(0.10915,          +q[3],    0.0,     +pi/2)

    T5 = dh(0.09465,        pi+q[4],    0.0,     +pi/2)
    T6 = dh( 0.0823,          +q[5],    0.0,       0.0)
    
    # Efector final con respecto a la base
    T = np.dot(np.dot(np.dot(np.dot(np.dot(T1,T2),T3),T4),T5),T6)
    return T


def jacobian_ur5(q, delta=0.0001):
    """
    Jacobiano analitico para la posicion. Retorna una matriz de 3x6 y toma como
    entrada el vector de configuracion articular q=[q1, q2, q3, q4, q5, q6]
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

        J[:,i] = np.concatenate((Jpos, Jrot), axis=0)
    
    return J

def pseudoInversa(J):

    Jinv =np.linalg.pinv(J)

    return Jinv

def ikine_ur5(xdes, q0):
    """
    Calcular la cinematica inversa de UR5 numericamente
    """
    epsilon  = 0.001
    max_iter = 1000
    delta    = 0.00001

    q  = copy(q0)
    for i in range(max_iter):
        # Main loop
        T       = fkine_ur5(q)[0:3,3]
        ep      = xdes[0:3] - T[0:3,3]
        e0      = quatError(xdes[3:6], rot2quat(T[0:3,0:3]))
        q       = q + np.dot(np.linalg.pinv(jacobian_pose_ur5(q,delta)),( e ))

        if np.linalg.norm(e) < epsilon:
            break    
    return q

def quatError(Qdes, Q):

    we = Qdes[0]*Q[0] + np.dot(Qdes[1:4].transpose(),Q[1:4]) -1
    e  = -Qdes[0]*Q[1:4] + Q[0]*Qdes[1:4] - np.dot(Qdes[1:4], Q[1:4])

    Qe = np.array([ we, e[0], e[1], e[2] ])

    return Qe


def rot2quat(R):
    """
    Convertir una matriz de rotacion en un cuaternion
    Entrada:
      R -- Matriz de rotacion
    Salida:
      Q -- Cuaternion [ew, ex, ey, ez]
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


class Robot(object):
    def __init__(self, q0, dq0, ndof, dt):
        self.q = q0    # numpy array (ndof x 1)
        self.dq = dq0  # numpy array (ndof x 1)
        self.M = np.zeros([ndof, ndof])
        self.b = np.zeros(ndof)
        self.dt = dt
        self.robot = rbdl.loadModel('/home/utec/ros_ws/src/ur5/ur5_description/urdf/ur5_joint_limited_robot.urdf')

    def send_command(self, tau):
        tau = np.squeeze(np.asarray(tau))
        rbdl.CompositeRigidBodyAlgorithm(self.robot, self.q, self.M)
        rbdl.NonlinearEffects(self.robot, self.q, self.dq, self.b)
        ddq = np.linalg.inv(self.M).dot(tau-self.b)
        self.q = self.q + self.dt*self.dq
        self.dq = self.dq + self.dt*ddq

    def read_joint_positions(self):
        return self.q

    def read_joint_velocities(self):
        return self.dq

    def get_M(self):
        return self.M

    def get_b(self):
        return self.b