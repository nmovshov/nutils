#---------------------------------------------------------------------------------
#  Naor's utility module - just a hodgepodge of stuff I sometimes use.
#
# Author: Naor Movshovitz (nmovshov at gee mail dot com)
#---------------------------------------------------------------------------------
import sys, os, shutil
import numpy as np
import scipy as sp

def eclazz(data, prox):
    """Partition a set (tree) into equivalence classes (connected components).

    Numerical Recipes (3rd edition) contains an efficient non-recursive
    algorithm due to D. Eardley [1] for partitioning a set into equivalence
    classes without holding a tree structure or an adjacency matrix. The
    algorithm works by going over all pairs of elements and labeling them to
    a common ancestor if they pass the given proximity test. This method
    will partition the set according to the equivalence relation that results
    from expanding the proximity relation prox to be transitive. This function is
    a python implementation of the NR3 c++ function.
    [1] Numerical Recipes (3rd edition) ch 8.6.

    Parameters
    ----------
    data : vector (list, tuple, or numpy.ndarray)
        A 1D vector containing the set to be partitioned. A numpy 2d array will be
        interpreted as a list of rows. That is, the rows of the array are the
        items of the set.
    prox : callable
        A boolean function that takes two arguments of the same type as data.
        prox(data[i],data[j]) returns true if the i-th and j-th elements of data
        are neighbors, false otherwise. **No checks are made to validate prox.**

    Returns
    -------
    labels : vector (list) of ints
        A vector of integer labels. labels[k] is the equivalence class of
        data[k]. There are len(np.unique(labels)) such classes.
    """

    # Some minimal assertions
    assert callable(prox)
    assert isinstance(data, (list, tuple, np.ndarray))
    if type(data) is np.ndarray:
        assert(data.ndim <= 2)
        pass

    # Initialize array of labels
    labels = [-1]*len(data)

    # The NR algorithm (with the book's exact, and useless, comments)
    labels[0] = 0
    for j in range(1, len(data)): # Loop over first element of all pairs.
        labels[j] = j
        for k in range(0,j): # Loop over second element of all pairs.
            labels[k] = labels[labels[k]] # Sweep it up this much.
            if prox(data[j], data[k]):
                labels[labels[labels[k]]] = j # Good exercise for the reader to
                                              # figure out why this much ancestry
                                              # is necessary!
                pass
            pass
        pass
    for j in range(len(data)):
        labels[j] = labels[labels[j]] # Only this much sweeping is needed finally.
        pass

    return labels

def gauleg(x1, x2, n):
    """Return abscissas and weights for Gauss-Legendre n-point quadrature.

    x,w = GAULEG(x1,x2,n) returns the abscissas x and weights w that can be used
    to evaluate the definite integral, I, of a function well approximated by an
    (2n - 1) degree polynomial in the interval [x1,x2] using the Gauss-Legendre
    formula:
        I = sum(w.*f(x))

    Algorithm:
      This function is based on the C++ implementation of a routine with the
      same name in Numerical Recipes, 3rd Edition. But in several places I opt
      for readability over performance, on the assumption that this function is
      most likely to be called in a setup routine rather than in an inner-loop
      computation.

    Example:
      fun = np.sin
      x,w = gauleg(0, np.pi, 6)
      I_quad = scipy.integrate.quad(fun, 0, np.pi)
      I_gaussleg = sum(w*fun(x))

    Reference: William H. Press, Saul A. Teukolsky, William T. Vetterling, and
    Brian P. Flannery. 2007. Numerical Recipes 3rd Edition: The Art of Scientific
    Computing (3 ed.). Cambridge University Press, New York, NY, USA.
    """

    # Minimal assertions
    assert np.isfinite(x1), "x1 must be real and finite"
    assert np.isfinite(x2), "x2 must be real and finite"
    assert int(n) == n and n > 2, "n must be positive integer > 2"
    assert x2 > x1, "Interval must be positive"

    # Local variables
    tol = 1e-14
    m = int(np.ceil(n/2))
    xmid = (x1 + x2)/2
    dx = (x2 - x1)
    x = np.NaN*np.ones((n,))
    w = np.NaN*np.ones((n,))

    # Main loop
    for j in range(m):
        # Get j-th root of Legendre polynomial Pn, along with Pn' value there.
        z = np.cos(np.pi*(j + 0.75)/(n + 0.5)) # initial guess for j-th root
        while True:
            # Calculate Pn(z) and Pn-1(z) and Pn'(z)
            p = np.NaN*np.ones((n+1,))
            p[0] = 1
            p[1] = z
            for k in range(2,n+1):
                pkm1 = p[k-1]
                pkm2 = p[k-2]
                pk = (1/k)*((2*k - 1)*z*pkm1 - (k - 1)*pkm2)
                p[k] = pk
            pn = p[-1]
            pp = (n*p[-2] - n*z*p[-1])/(1 - z**2)

            # And now Newton's method (we are hopefully very near j-th root)
            oldz = z
            z = z - pn/pp
            if np.abs(z - oldz) < tol:
                break

        # Now use j-th root to get 2 abscissas and weights
        x[j]     = xmid - z*dx/2 # Scaled abscissa left of center
        x[n-1-j] = xmid + z*dx/2 # Scaled abscissa right of center
        w[j]     = dx/((1 - z**2)*pp**2)
        w[n-1-j] = w[j]

    # Verify and return
    assert np.all(np.isfinite(x))
    assert np.all(np.isfinite(w))
    return (x,w)

def _test():
    print("alo world")
    x, w = gauleg(-1,2,5)
    print(x)
    print(w)
    return

if __name__ == "__main__":
    _test()
    sys.exit(0)
