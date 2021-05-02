# ============================================================
#   Author  :   Jhon Charaja
#   Info    :   Kalman 1st and 2nd derivator
# ============================================================

import numpy as np
import math
from copy import copy
import os
from numpy.linalg import inv
from numpy import matmul as mx

class KalmanDerivator:
    def __init__(self, deltaT, ndof = 7):
        self.q_v = np.zeros(ndof)
        self.dq_v = np.zeros(ndof)
        self.ddq_v = np.zeros(ndof)
        self.deltaT = deltaT

        self.joint_spaces = [Joint(self.deltaT),
							 Joint(self.deltaT), 
							 Joint(self.deltaT), 
							 Joint(self.deltaT), 
							 Joint(self.deltaT), 
							 Joint(self.deltaT)]

    def update(self, q_update):
        q_v = []
		dq_v = []
		ddq_v = []

		for i, _ in enumerate(self.joint_spaces):
			q, dq, ddq = self.joint_spaces[i].kalman_filter(q_update[i])
			q_v.append(q)
			dq_v.append(dq)
			ddq_v.append(ddq)

		self.q_v = np.array(q_v)
		self.dq_v = np.array(dq_v)
		self.ddq_v = np.array(ddq_v)

        return self.q_v, self.dq_v, self.ddq_v 


class Joint:
    def __init__(self, deltaT):
        self.deltaT = deltaT
        
        self.x_k_k = np.zeros((3,1))
        self.x_k1_k = np.zeros((3,1))
        
        self.P_k_k =  np.eye(3)
        self.P_k1_k = np.eye(3)
        
        self.K = np.zeros((3,1))	#np.random.randn(3,1)
        
        
        self.Q = .1*np.array([[deltaT**5/20, deltaT**4/8, deltaT**3/6],
        					[deltaT**4/8, deltaT**3/3, deltaT**2/2],
        					[deltaT**3/6, deltaT**2/2, deltaT]]) #

        		#2*np.diag([0.01,0.05,0.1])#
        		#2.*np.eye(3)
        		
        
        self.R = 0.001*np.eye(1)
        self.I = np.eye(3)
        

    def kalman_filter(self, pos):
        F = np.array([[1., self.deltaT, 0.5*self.deltaT**2],[0., 1., self.deltaT],[0.,0.,1.]])
        H = np.array([[1., 0., 0.]])

        z = np.array([[pos]])

        #Prediction
        self.x_k1_k = mx(F,self.x_k_k)
        self.P_k1_k = mx(F, mx(self.P_k_k, np.transpose(F))) +  self.Q

        #Update
        self.x_k_k = self.x_k1_k + mx(self.K, (z - mx(H, self.x_k1_k)))
        #self.P_k_k = mx(mx((self.I - mx(self.K, H)), self.P_k1_k), np.transpose(self.I - mx(self.K, H))) + mx(self.K, mx(self.R, np.transpose(self.K))) 
        self.P_k_k = mx(self.I - mx(self.K,H), self.P_k1_k)

        self.K = mx(mx(self.P_k1_k, np.transpose(H)), inv(mx(H, mx(self.P_k1_k, np.transpose(H))) + self.R))   
        
        return self.x_k_k[0][0], self.x_k_k[1][0], self.x_k_k[2][0]