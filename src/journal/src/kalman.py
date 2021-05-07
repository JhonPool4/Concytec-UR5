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

class MultipleKalmanDerivator:
    def __init__(self, deltaT, ndof = 7):
        self.x_v = np.zeros(ndof)
        self.dx_v = np.zeros(ndof)
        self.ddx_v = np.zeros(ndof)
        self.deltaT = deltaT

        self.derivators =   [KalmanDerivator(self.deltaT),
                             KalmanDerivator(self.deltaT), 
                             KalmanDerivator(self.deltaT), 
                             KalmanDerivator(self.deltaT), 
                             KalmanDerivator(self.deltaT),
                             KalmanDerivator(self.deltaT), 
                             KalmanDerivator(self.deltaT),
                             ]

    def update(self, x_update):
        x_v = []
        dx_v = []
        ddx_v = []

        for i, _ in enumerate(self.derivators):
            x, dx, ddx = self.derivators[i].kalman_filter(x_update[i])
            x_v.append(x)
            dx_v.append(dx)
            ddx_v.append(ddx)

        self.x_v = np.array(x_v)
        self.dx_v = np.array(dx_v)
        self.ddx_v = np.array(ddx_v)

        return self.x_v, self.dx_v, self.ddx_v 


class KalmanDerivator:
    def __init__(self, deltaT):
        self.deltaT = deltaT
        
        self.x_k_k = np.zeros((3,1))
        self.x_k1_k = np.zeros((3,1))
        
        self.P_k_k =  np.eye(3)
        self.P_k1_k = np.eye(3)
        
        self.K = np.zeros((3,1))    #np.random.randn(3,1)
        
        
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
        self.P_k_k = mx(mx((self.I - mx(self.K, H)), self.P_k1_k), np.transpose(self.I - mx(self.K, H))) + mx(self.K, mx(self.R, np.transpose(self.K))) 
        #self.P_k_k = mx(self.I - mx(self.K,H), self.P_k1_k)

        self.K = mx(mx(self.P_k1_k, np.transpose(H)), inv(mx(H, mx(self.P_k1_k, np.transpose(H))) + self.R))   
        
        return self.x_k_k[0][0], self.x_k_k[1][0], self.x_k_k[2][0]


class MultipleKalmanIntegrator:
    def __init__(self, deltaT, ndof = 7):
        self.x_v = np.zeros(ndof)
        self.dx_v = np.zeros(ndof)
        self.ddx_v = np.zeros(ndof)
        self.deltaT = deltaT

        self.integrators =   [KalmanIntegrator(self.deltaT),
                             KalmanIntegrator(self.deltaT), 
                             KalmanIntegrator(self.deltaT), 
                             KalmanIntegrator(self.deltaT), 
                             KalmanIntegrator(self.deltaT),
                             KalmanIntegrator(self.deltaT), 
                             KalmanIntegrator(self.deltaT),
                             ]

    def update(self, ddx_update):
        x_v = []
        dx_v = []
        ddx_v = []

        for i, _ in enumerate(self.integrators):
            x, dx, ddx = self.integrators[i].kalman_filter(ddx_update[i])
            x_v.append(x)
            dx_v.append(dx)
            ddx_v.append(ddx)

        self.x_v = np.array(x_v)
        self.dx_v = np.array(dx_v)
        self.ddx_v = np.array(ddx_v)

        return self.x_v, self.dx_v, self.ddx_v 


class KalmanIntegrator:
    def __init__(self, deltaT):
        self.deltaT = deltaT
        
        self.x_k_k = np.zeros((3,1))
        self.x_k1_k = np.zeros((3,1))
        
        self.P_k_k =  np.eye(3)
        self.P_k1_k = np.eye(3)
        
        self.K = np.zeros((3,1))    #np.random.randn(3,1)
        
        
        self.Q = .1*np.array([[deltaT**5/20, deltaT**4/8, deltaT**3/6],
                            [deltaT**4/8, deltaT**3/3, deltaT**2/2],
                            [deltaT**3/6, deltaT**2/2, deltaT]]) #

                #2*np.diag([0.01,0.05,0.1])#
                #2.*np.eye(3)
                
        
        self.R = 0.001*np.eye(1)
        self.I = np.eye(3)
        

    def kalman_filter(self, pos):
        F = np.array([[1., self.deltaT, 0.5*self.deltaT**2],[0., 1., self.deltaT],[0.,0.,1.]])
        H = np.array([[0., 0., 1.]])

        z = np.array([[pos]])

        #Prediction
        self.x_k1_k = mx(F,self.x_k_k)
        self.P_k1_k = mx(F, mx(self.P_k_k, np.transpose(F))) +  self.Q

        #Update
        self.x_k_k = self.x_k1_k + mx(self.K, (z - mx(H, self.x_k1_k)))
        self.P_k_k = mx(mx((self.I - mx(self.K, H)), self.P_k1_k), np.transpose(self.I - mx(self.K, H))) + mx(self.K, mx(self.R, np.transpose(self.K))) 
        #self.P_k_k = mx(self.I - mx(self.K,H), self.P_k1_k)

        self.K = mx(mx(self.P_k1_k, np.transpose(H)), inv(mx(H, mx(self.P_k1_k, np.transpose(H))) + self.R))   
        
        return self.x_k_k[0][0], self.x_k_k[1][0], self.x_k_k[2][0]