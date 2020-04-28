import rbdl
import numpy as np


# Lectura del modelo del robot a partir de URDF (parsing)
#modelo = rbdl.loadModel('../urdf/ur5_robot.urdf')
#modelo = rbdl.loadModel('/home/utec/ros_ws/src/sawyer/sawyer_description/urdf/sawyer_base.urdf')
modelo = rbdl.loadModel('/home/utec/ros_ws/src/ur5/ur5_description/urdf/ur5_joint_limited_robot.urdf')
#modelo = rbdl.loadModel('/home/utec/ros_ws/src/lab1/urdf/robot.urdf')

# Grados de libertad
ndof = modelo.q_size

# Configuracion articular
q = np.array([0.5, 0.2, 0.3, 0.8, 0.5, 0.6])
# Velocidad articular
dq = np.array([0.8, 0.7, 0.8, 0.6, 0.9, 1.0])
# Aceleracion articular
ddq = np.array([0.2, 0.5, 0.4, 0.3, 1.0, 0.5])

# Arrays numpy
zeros = np.zeros(ndof)          # Vector de ceros
tau   = np.zeros(ndof)          # Para torque
g     = np.zeros(ndof)          # Para la gravedad
c     = np.zeros(ndof)          # Para el vector de Coriolis+centrifuga
M     = np.zeros([ndof, ndof])  # Para la matriz de inercia
e     = np.eye(6)               # Vector identidad
# Efectos no lineales
b2    = np.zeros(ndof)          # Para efectos no lineales
M2 = np.zeros([ndof, ndof])  # Para matriz de inercia


# Vector tau
rbdl.InverseDynamics(modelo, q, dq, ddq, tau)

# Vector g
rbdl.InverseDynamics(modelo, q, zeros, zeros, g)

# Matriz C*dq
rbdl.InverseDynamics(modelo, q, dq, zeros, c)
c = c -g

# Matriz M
for i in range(0,6):
	rbdl.InverseDynamics(modelo, q, zeros, e[i,:], M[i,:])

M = M - g

# Efectos no Lineales
rbdl.NonlinearEffects(modelo,q, dq, b2)

rbdl.CompositeRigidBodyAlgorithm(modelo, q, M2)



# Parte 2: Calcular M y los efectos no lineales b usando las funciones
# CompositeRigidBodyAlgorithm y NonlinearEffects. Almacenar los resultados
# en los arreglos llamados M2 y b2









# Parte 2: Verificacion de valores





# Parte 3: Verificacion de la expresion de la dinamica
