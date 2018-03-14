#---------------------------------------------------------------------------------
#  Planetary Science Helpers - a bunch of functions that calculate planetary
#                              science stuff.
#
# Author: Naor Movshovitz (nmovshov at gee mail dot com)
#---------------------------------------------------------------------------------
import sys, os, shutil
import numpy as np
import scipy as sp
import matplotlib as mpl
import matplotlib.pyplot as plt

def Q_star_D(target_radius, scaling_method='MKN14_ice'):
    """Return power-law scaled, threshold specific energy for disruption, Q*D.
    
    The fraction of mass ejected from a target after a gravity regime collision
    scales with the specific energy of the impact, Q*. The scaling parameter is 
    the threshold for dispersing half of the original target mass - Q*D. In the
    gravity regime, we find that Q*D(R) can be approximated by a power law:
            Q*D(R) = B*(R/meters)^b.
    This function returns Q*D for an ice or basalt target, based on a few sources.
    
    Note: Unlike Benz & Asphaug (1999) we do not bother separating the
    multiplicative constant from the target density, since the density is implied
    in the target type anyway.
    
    Parameters
    ----------
    target_radius : numeric, scalar, positive
        Target's radius in meters.
    scaling_method : string in ['MKN14_ice', 'MKN14_basalt'], (optional)
        Power-law choice. Default is 'MKN14_ice', for power law derived from our
        2014 Spheral++ simulations together with Benz & Asphaug 1999 data.
    """
    
    # Some minimal assertions
    assert np.isscalar(target_radius) and np.isfinite(target_radius) 
    assert np.isreal(target_radius) and target_radius > 0
    assert scaling_method in ['MKN14_ice', 'MKN14_basalt']
    assert 1e5 <= target_radius <= 1e6, "Expecting target radius in meters."

    # Choose power-law parameters based on scaling_method
    if scaling_method is 'MKN14_ice':
        B = 0.05 # J/kg
        b = 1.1876
    elif scaling_method is 'MKN14_basalt':
        B = 1.48 # J/kg
        b = 0.9893
    # Return a power-law scaled Q*D
    QsD = B*target_radius**b

    return QsD

def hydrostatic_2layer_incompressible_pressure_profile(R, rc, rhoc, rhom, G=6.674e-11):
    """Return pressure inside a small, hydrostatic, 2-layer planet.
    
    Assuming constant density in the two-layers, the hydrostatic equation:
            dp/dr = -rho(r) * g(r)
    can be integrated to give the pressure as a function of radial distance from
    the center of the planet. The integration constants are fixed by requiring
    zero pressure at the surface and continuity at the core/mantle boundary.
    
    This function has two modes. The basic mode takes a vector R, interpreted as
    radial distance, and returns the pressure at each point in R, assuming that 
    the planet's outer radius is max(R). The second mode takes a scalar R,
    interpreted as the planet's radius, and returns the central pressure.
    
    Parameters
    ----------
    R : numeric, scalar or vector
        If scalar, planet's outer radius. If vector, list of positions where
        pressure is to be calculated, and max(R) is planet's radius.
    rc : numeric, scalar, positive
        Radius of core/mantle boundary.
    rhoc : numeric, scalar, positive
        Density of inner layer (core).
    rhom : numeric, scalar, positive
        Density of outer layer (mantle).
    G : numeric, scalar, positive, (optional)
        Value for universal gravitational constant. The default value is in SI 
        units, so if R and rc are given in meters and rhoc and rhoc are given in
        kg/m^3 then the returned pressure is in Pa.
    """
    
    R = np.array(R)
    assert np.all(np.isreal(R))
    assert np.all(R>=0)
    assert isinstance(rc,(int,float))
    assert isinstance(rhoc,(int,float))
    assert isinstance(rhom,(int,float))
    assert isinstance(G,(int,float))
    assert rc > 0 and rhoc > 0 and rhom > 0 and G > 0
    assert rc < R.max()
    
    a = R.max()
    c2 = 4*np.pi/3*G*(0.5*rhom**2*a**2 - rhom*(rhoc - rhom)*rc**3/a)
    c1 = 4*np.pi/3*G*(0.5*rhoc**2 - 1.5*rhom**2 + rhoc*rhom)*rc**2 + c2
    
    # Two branches, depending on what user had in mind
    if R.size == 1: # user wants central pressure
        return c1
    else: # user wants a profile
        p = np.ones(R.size)*np.NaN
        for k in range(R.size):
            if R[k] <= rc:
                p[k] = c1 - 4*np.pi/3*G*0.5*rhoc**2*R[k]**2
            else:
                p[k] = c2 - 4*np.pi/3*G*(0.5*rhom**2*R[k]**2 -
                                         rhom*(rhoc - rhom)*rc**3/R[k])
                pass
            pass
        pass
    
    return p
    
def hydrostatic_1layer_incompressible_pressure_profile(R, rho, G=6.674e-11):
    """Return pressure inside a small, hydrostatic, 1-layer planet.
    
    Assuming constant density, the hydrostatic equation:
            dp/dr = -rho(r) * g(r)
    can be integrated to give the pressure as a function of radial distance from
    the center of the planet. The integration constant is fixed by requiring zero
    pressure at the surface.
    
    This function has two modes. The basic mode takes a vector R, interpreted as
    radial distance, and returns the pressure at each point in R, assuming that 
    the planet's outer radius is max(R). The second mode takes a scalar R, 
    interpreted as the planet's radius, and returns the central pressure.
    
    Parameters
    ----------
    R : numeric, scalar or vector
        If scalar, planet's outer radius. If vector, list of positions where
        pressure is to be calculated, and max(R) is planet's radius.
    rho : numeric, scalar, positive
        Density (assumed constant) of planet.
    G : numeric, scalar, positive, (optional)
        Value for universal gravitational constant. The default value is in SI 
        units, so if R is given in meters and rho is given in kg/m^3 then the
        returned pressure is in Pa.
    """
    
    R = np.array(R)
    assert np.all(np.isreal(R))
    assert np.all(R>=0)
    assert isinstance(rho,(int,float))
    assert isinstance(G,(int,float))
    assert rho > 0 and G > 0
    
    a = R.max()
    
    # Two branches, depending on what user had in mind
    if R.size == 1: # user wants central pressure
        return 2*np.pi/3*G*rho**2*a**2
    else: # user wants a profile
        p = np.ones(R.size)*np.NaN
        for k in range(R.size):
            p[k] = 2*np.pi/3*G*rho**2*(a**2 - R[k]**2)
        pass
    
    return p

def _test():
    print "alo"
    pass

if __name__ == "__main__":
    _test()
    pass
