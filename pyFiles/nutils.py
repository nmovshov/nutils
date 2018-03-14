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
    labels[0] = 0;
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
