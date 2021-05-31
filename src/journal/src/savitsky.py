# ============================================================
#   Author  :   Jhon Charaja
#   Info    :   Savitsky Golay 1st and 2nd derivator
#               Modified version for jerk.
# ============================================================

import numpy as np
from copy import copy
from collections import deque

class MultipleSavGolDerivator:
    def __init__(self, deltaT, ndof = 7):
        self.dx_v = np.zeros(ndof)
        self.ddx_v = np.zeros(ndof)
        self.dddx_v = np.zeros(ndof)
        self.deltaT = deltaT

        self.derivators = []

        for _ in range(ndof):
            self.derivators.append(SavGolDerivator(self.deltaT))

    def update(self, dx_update):
        dx_v = []
        ddx_v = []
        dddx_v = []

        for i, _ in enumerate(self.derivators):
            dx, ddx, dddx = self.derivators[i].update_data(dx_update[i])
            dx_v.append(dx)
            ddx_v.append(ddx)
            dddx_v.append(dddx)

        self.dx_v = np.array(dx_v)
        self.ddx_v = np.array(ddx_v)
        self.dddx_v = np.array(dddx_v)

        return self.dx_v, self.ddx_v, self.dddx_v 


class SavGolDerivator:
    def __init__(self, deltaT):
        self.dx = 0.
        self.ddx = 0.
        self.dddx = 0.

        self.deltaT = deltaT
        
        self.sav_gol_ddx = SavGol2d(deltaT)
        self.sav_gol_dddx = SavGol3d(deltaT)
        

    def update_data(self, x):
        #ddx = (dx - self.dx)/self.deltaT
        # ddx = self.sav_gol_ddx.update(ddx_)

        #dddx =(ddx - self.ddx)/self.deltaT
        # dddx = self.sav_gol_dddx.update(dddx_)

        ddx = self.sav_gol_ddx.update(x)
        dddx = self.sav_gol_dddx.update(x)
        
        self.dx = copy(x)
        self.ddx = copy(ddx)
        self.dddx = copy(dddx)

        return self.dx, self.ddx, self.dddx

class SavGol:
    def __init__(self, acc = True):
        if acc:
            self.coeff = np.array([-3, 12, 17, 12, -3] ) / 5
            #self.coeff = np.array([-2, 3, 6, 7, 6, 3, -2])/21.
            #self.coeff = np.array([-78, -13, 42, 87,122, 147,162,167,162,147,122,87,42,-13,-78])/1105
            self.X = np.zeros(5)
        else:
            self.coeff = np.array([-42,-21,-2, 15, 30,43,54,63,70,75,78,79,78,75,70,63,54,43,30,15,-2,-21,-42])/805.
            self.X = np.zeros(23)

    def update(self, x):
        self.X[:-1] = self.X[1:]
        self.X[-1] = x
        y = np.sum(self.coeff * self.X)
        return y

class SavGol2d:
    def __init__(self, deltaT, acc = True):
        # self.coeff = np.array([-3, -2, -1, 0, 1, 2, 3] ) / 7
        self.coeff = np.array([5,0,-3,-4,-3,0,5]) / deltaT/42
        self.X = deque([0,0,0,0,0,0,0], maxlen = 7)

    def update(self, x):
        self.X.append(x)
        y = np.sum(self.coeff * self.X)
        return y

class SavGol3d:
    def __init__(self, deltaT, acc = True):
        self.coeff = np.array([-1,1,1,0,-1,-1,1] ) / deltaT/6
        self.X = deque([0,0,0,0,0,0,0],maxlen = 7)

    def update(self, x):
        self.X.append(x)
        y = np.sum(self.coeff * self.X)
        return y
