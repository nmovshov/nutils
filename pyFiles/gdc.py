#---------------------------------------------------------------------------------
#  Gravity-dominated collisions - a few calculations relating to impact scaling in
#                                 the gravity regime.
#
# Author: Naor Movshovitz (nmovshov at gee mail dot com)
#---------------------------------------------------------------------------------
import sys, os, shutil
import numpy as np

def disruption_level(R,MRHO,r,mrho,v,theta=np.pi/4,scaling='metal15',nom=False):
    """Return predicted level of disruption in gravity-dominated impact.

    This function returns the predicted level of disruption in a collision between
    a target of radius R and mass-or-density MRHO and a projectile of radius r and
    mass-or-density mrho with relative impact speed v at impact angle theta using
    the scaling law indicated by the string argument scaling. The colliding bodies
    are assumed to be large enough for the impact to be gravity dominated. They
    are also assumed to be undifferentiated and non-rotating. Specify all inputs
    in SI units. The MRHO and mrho will be interpreted as mass if their numeric
    value is greater than 10^6 and as density otherwise. The return value is the
    ratio of impact energy to predicted threshold energy for disruption. A value
    greater than or equal to one indicates catastrophic disruption, but this is a
    convenient reference not a strict definition.

    Parameters
    ----------
    R : numeric, scalar
        Target radius.
    MRHO : numeric, scalar
        Mass (if > 10^6) or mean density of target.
    r : numeric, scalar
        Projectile radius.
    mrho : numeric, scalar
        Mass (if > 10^6) or mean density of projectile.
    v : numeric, scalar
        Impact speed.
    theta : numeric, scalar (optional)
        Impact angle (default pi/4).
    scaling : string (optional)
        Choice of scaling law. Supported scaling laws are:
        'METAL15' uses the K/U scaling suggested in Movshovitz et al. (2015)
        'LS12'    uses the Q*RD scaling suggested in Leinhardt & Stewart (2012)
        'BA99'    uses the Q*D scaling suggested in Benz & Asphaug (1999)
        Default is 'METAL15'.
    nom : bool, (optional)
        Flag to tweak the algorithm in METAL15 scaling. With nom=False (default)
        disruption level is equal to 1 if K/U is inside the uncertainty interval
        [Clo,Chi], equal to K/(Clo*U) if K/U < Clo, and to K/(Chi*U) if K/U < Chi.
        When nom=True the returned disruption level is always K/(Cnom*U) with Cnom
        a nominal mid-point value. This parameter has no effect when a scaling
        other than 'METAL15' is specified.
    """
    print scaling
    pass

def _test():
    print "alo world"
    disruption_level(1,2,3,4,5,6)
    pass

if __name__ == "__main__":
    _test()
    pass