from IPython import get_ipython
import numpy as np
from numba import jit

def potential(x, y, z, m, mask=None):
    if mask is None:
        mask = np.ones(shape=x.shape, dtype=bool)
    return pot(x, y, z, m, mask)

@jit
def pot(x, y, z, m, mask):
    U = np.zeros(x.shape)
    for j in range(len(x)):
        if mask[j]:
            for k in range(j):
                if mask[k]:
                    dx = x[j] - x[k]
                    dy = y[j] - y[k]
                    dz = z[j] - z[k]
                    dr = (dx*dx + dy*dy + dz*dz)**0.5
                    #dr = np.sqrt(dx*dx + dy*dy + dz*dz)
                    U[j] = U[j] - m[k]/dr
                    U[k] = U[k] - m[j]/dr
                    pass
                pass
            pass
        pass
    return U


def _potential(x, y, z, m, mask=None):
    if mask is None:
        mask = np.array(len(x)*[True])
    U = np.zeros(x.shape)
    for j in range(len(x)):
        if mask[j]:
            for k in range(j):
                if mask[k]:
                    dx = x[j] - x[k]
                    dy = y[j] - y[k]
                    dz = z[j] - z[k]
                    dr = (dx*dx + dy*dy + dz*dz)**0.5
                    #dr = np.sqrt(dx*dx + dy*dy + dz*dz)
                    U[j] = U[j] - m[k]/dr
                    U[k] = U[k] - m[j]/dr
                    pass
                pass
            pass
        pass
    return U

if __name__ == '__main__':
    ipython = get_ipython()

    N = 1000
    x = np.random.rand(N)
    y = np.random.rand(N)
    z = np.random.rand(N)
    m = np.random.rand(N)

    print 'interpreted python/numpy:'
    ipython.magic('timeit _potential(x, y, z, m)')

    print 'with Numba jit:'
    ipython.magic('timeit potential(x, y, z, m)')

    assert np.all(potential(x, y, z, m) == potential(x, y, z, m)), 'values do not match'

