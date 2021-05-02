
import numpy as np
import pandas as pd
import math
from copy import copy
import os


class DataReader:
    def __init__(self, fn = '', dt = 0.01):
        self.datapath = fn
        self.xs = np.array([])
        self.dxs = np.array([])
        self.ddxs = np.array([])
        self.dddxs = np.array([])
        self.dt = dt
        self.max_count = 0
        self.df = None

    def read_dataset(self):
        self.df = pd.read_csv(self.datapath, delimiter = r"\s+", header = None)
        df = self.df
        pose = []
        vel = []
        self.max_count = df.shape[0] - 2
        
        for i in np.arange(df.shape[0]):
            x = df.iloc[i, 0]
            y = df.iloc[i, 1]
            z = df.iloc[i, 2]
            ew = 1
            ex = 0
            ey = 0
            ez = 0

            dx = df.iloc[i, 13]
            dy = df.iloc[i, 14]
            dz = df.iloc[i, 15]
            
            dew = 0
            dex = 0
            dey = 0
            dez = 0
            pose.append( [x, y, z, ew, ex, ey, ez] )
            vel.append( [dx, dy, dz, dew, dex, dey, dez])

        self.xs = np.array(pose)
        self.dxs = np.array(vel)


    def calculate(self):
        self.ddxs = np.diff(self.dxs, axis = 0) / self.dt
        self.dddxs = np.diff(self.ddxs, axis = 0) / self.dt

        self.xs = self.xs[:-4,:]
        self.dxs = self.dxs[:-4,:]
        self.ddxs = self.ddxs[:-3,:]
        self.dddxs = self.dddxs[:-2,:]

    def dataset_trajectory_generator(self, i):
        if i < self.max_count:
            x = self.xs[i,:]
            dx = self.dxs[i,:]
            ddx = self.ddxs[i,:]
            dddx = self.dddxs[i,:]

            return x, dx, ddx, dddx

        else:
            raise Exception('Read beyond the limits of the dataset')
        
                