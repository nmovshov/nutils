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

def Pn(n, x):
    """Fast implementation of ordinary Legendre polynomials of low degree.

    y = Pn(n,x) returns the ordinary Legendre polynomial of degree n evaulated at
    x. For n <= 12 the polynomials are implemented explicitly resutling in faster
    calculation compared with the recursion formula. For n > 12 we fall back on
    scipy.special.eval_legendre(n,x).

    Note: in keeping with the premise of an optimized implementation this function
    performs no input checks at all. Use with care.
    """

    x = np.array(x, dtype=float)

    if n == 0:
        y = np.ones(x.shape)
    elif n == 1:
        y = x
    elif n == 2:
        y = 0.5*(3*x**2 - 1)
    elif n == 3:
        y = 0.5*(5*x**3 - 3*x)
    elif n == 4:
        y = (1/8)*(35*x**4 - 30*x**2 + 3)
    elif n == 5:
        y = (1/8)*(63*x**5 - 70*x**3 + 15*x)
    elif n == 6:
        y = (1/16)*(231*x**6 - 315*x**4 + 105*x**2 - 5)
    elif n == 7:
        y = (1/16)*(429*x**7 - 693*x**5 + 315*x**3 - 35*x)
    elif n == 8:
        y = (1/128)*(6435*x**8 - 12012*x**6 + 6930*x**4 - 1260*x**2 + 35)
    elif n == 9:
        y = (1/128)*(12155*x**9 - 25740*x**7 + 18018*x**5 - 4620*x**3 + 315*x)
    elif n == 10:
        y = (1/256)*(46189*x**10 - 109395*x**8 + 90090*x**6 - 30030*x**4 + 3465*x**2 - 63)
    elif n == 11:
        y = (1/256)*(88179*x**11 - 230945*x**9 + 218790*x**7 - 90090*x**5 + 15015*x**3 - 693*x)
    elif n == 12:
        y = (1/1024)*(676039*x**12 - 1939938*x**10 + 2078505*x**8 - 1021020*x**6 + 225225*x**4 - 18018*x**2 + 231)
    else:
        from scipy.special import eval_legendre
        y = eval_legendre(n,x)

    return y

def _test():
    print("alo world")
    for k in range(14):
        print("Pn({},(0,0.5,-0.5)) = {}".format(k, Pn(k,(0,0.5,-0.5))))
    return

if __name__ == "__main__":
    _test()
    sys.exit(0)
