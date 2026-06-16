"""
PHYSUNITS Dimensionally aware variables and expressions.

The physunits module is an attempt to include "dimensional awareness" in python
calculations. The motivation and a suggested algorithm are explained in Petty
(2001), where the author also describes a FORTRAN90 implementation that
provided the basis for this module.

The physunits module works by defining the `preal` data type and overloaded
functions to support it. A variable of type `preal` represents a physical
quantity. It has two data attributes:

  self.value is a scalar representing the numeric value, and
  self.units is a ndarray used to represent the physical dimensions.

But these details are never needed by the user, who defines their variables by
multiplying a numeric value by one or more predefined class variables.

Reference:
Petty, G.W., 2001. Automated computation and consistency checking of physical
dimensions and units in scientific programs. _Software: Practice and
Experience_, 31(11), pp.1067-1076.
"""
import numpy as np

_nbdim = 6
_dim_labels=['m','kg','s','K','A','mol']

class preal:
    """A dimensioned physical quantity.

    A variable of type `preal` represents a physical quantity using two
    data attributes:

    self.value is a scalar of type float64 representing the numerical value.

    self.units is an ndarray with shape=(5,) and dtype=float64, representing
    powers of base dimensions of the quantity, using the format:
      [length, mass, time, temperature, electric current, amount of matter]

    These are the base SI units, excepting illumination and luminous intensity
    because no one really knows what these are supposed to be.

    Note that self.units has dtype=float64 for simplicity but in practice will
    hold values that are ratios of small integers.
    """

    ### PREAL CONSTRUCTOR
    def __init__(self, value=np.nan, units=np.zeros(_nbdim)):
        if type(value) is preal:
            self.value = value.value
            self.units = value.units.copy()
        else:
            try:
                self.value = np.float64(0.0) + value
            except:
                raise ValueError(f"could not create preal value from {value}")
            try:
                units = np.array(units, dtype=np.float64)
                assert units.shape == (_nbdim,)
                self.units = np.zeros(_nbdim) + units
            except:
                raise ValueError(f"could not create base units from {units}")

    ### PREAL ISAS
    def isreal(self):
        return np.isreal(self.value)
    def isinf(self):
        return np.isinf(self.value)
    def isfinite(self):
        return np.isfinite(self.value)
    def isdimless(self):
        return np.array_equal(self.units, np.zeros(_nbdim))

    ### DISPLAY DUNDERS
    def __repr__(self):
        # return f"physunits.preal({self.value!r}, {self.units!r})"
        return self.__str__()
    
    def __str__(self):
        s = f"{self.value:0.4}"
        for k in range(len(_dim_labels)):
            if np.abs(self.units[k]) < 0.1:
                continue
            if self.units[k] < 0:
                continue
            if np.isclose(self.units[k], 1.0):
                s = s + f" {_dim_labels[k]}"
            else:
                s = s + f" {_dim_labels[k]}^{self.units[k]:g}"
        for k in range(len(_dim_labels)):
            if np.abs(self.units[k]) < 0.1:
                continue
            if self.units[k] > 0:
                continue
            else:
                s = s + f" {_dim_labels[k]}^{self.units[k]:g}"
        return s

    ### TYPE CAST DUNDERS
    def __int__(self):
        return int(self.value)
    def __float__(self):
        return float(self.value)
    def __complex__(self):
        return complex(self.value)

    ### BASIC UNARY DUNDERS
    def __abs__(self):
        return preal(abs(self.value), self.units)
    def __neg__(self):
        return preal(-self.value, self.units)

    ### PREAL ARITHMETIC OPERATIONS
    def __add__(self, other):
        other = preal(other)
        if np.array_equal(self.units, other.units):
            return preal(self.value + other.value, self.units)
        else:
            raise ValueError("Dimension mismatch, check your units!")
    def __radd__(self, other):
        other = preal(other)
        if np.array_equal(self.units, other.units):
            return preal(self.value + other.value, self.units)
        else:
            raise ValueError("Dimension mismatch, check your units!")

    def __sub__(self, other):
        other = preal(other)
        if np.array_equal(self.units, other.units):
            return preal(self.value - other.value, self.units)
        else:
            raise ValueError("Dimension mismatch, check your units!")
    def __rsub__(self, other):
        other = preal(other)
        if np.array_equal(self.units, other.units):
            return preal(other.value - self.value, self.units)
        else:
            raise ValueError("Dimension mismatch, check your units!")

    def __mul__(self, other):
        other = preal(other)
        return preal(self.value*other.value, self.units + other.units)
    def __rmul__(self, other):
        other = preal(other)
        return preal(self.value*other.value, self.units + other.units)

    def __truediv__(self, other):
        other = preal(other)
        return preal(self.value/other.value, self.units - other.units)
    def __rtruediv__(self, other):
        other = preal(other)
        return preal(other.value/self.value, other.units - self.units)

    def __pow__(self, other):
        other = preal(other)
        if other.isdimless():
            return preal(self.value**other.value, self.units*other.value)
        else:
            raise ValueError("Dimension mismatch, check your units!")
    def __rpow__(self, other):
        other = preal(other)
        if self.isdimless():
            return preal(other.value**self.value, other.units*self.value)
        else:
            raise ValueError("Dimension mismatch, check your units!")

### Transcendental functions overloaded for preal
def cos(p):
    p = preal(p)
    if p.isdimless():
        return np.cos(p.value)
    else:
        raise ValueError("Transcendental function takes dimensionless input.")
def sin(p):
    p = preal(p)
    if p.isdimless():
        return np.sin(p.value)
    else:
        raise ValueError("Transcendental function takes dimensionless input.")
def tan(p):
    p = preal(p)
    if p.isdimless():
        return np.tan(p.value)
    else:
        raise ValueError("Transcendental function takes dimensionless input.")
def exp(p):
    p = preal(p)
    if p.isdimless():
        return np.exp(p.value)
    else:
        raise ValueError("Transcendental function takes dimensionless input.")
def log(p):
    p = preal(p)
    if p.isdimless():
        return np.log(p.value)
    else:
        raise ValueError("Transcendental function takes dimensionless input.")
def log10(p):
    p = preal(p)
    if p.isdimless():
        return np.log10(p.value)
    else:
        raise ValueError("Transcendental function takes dimensionless input.")

### Predefined interface variables ###
# Base units
meter    = preal(1,[1, 0, 0, 0, 0, 0])
kilogram = preal(1,[0, 1, 0, 0, 0, 0])
second   = preal(1,[0, 0, 1, 0, 0, 0])
kelvin   = preal(1,[0, 0, 0, 1, 0, 0])
ampere   = preal(1,[0, 0, 0, 0, 1, 0])
mole     = preal(1,[0, 0, 0, 0, 0, 1])
radian   = preal(1,[0, 0, 0, 0, 0, 0])

# Abbreviations
m   = meter
kg  = kilogram
s   = second
K   = kelvin
A   = ampere
mol = mole
rad = radian

# SI prefixes
yotta = 1.0e+24
zetta = 1.0e+21
exa   = 1.0e+18
peta  = 1.0e+15
tera  = 1.0e+12
giga  = 1.0e+09
mega  = 1.0e+06
kilo  = 1.0e+03
hecto = 1.0e+02
deka  = 1.0e+01
deci  = 1.0e-01
centi = 1.0e-02
milli = 1.0e-03
micro = 1.0e-06
nano  = 1.0e-09
pico  = 1.0e-12
femto = 1.0e-15
atto  = 1.0e-18
zepto = 1.0e-21
zocto = 1.0e-24

# Basic derived units
steradian = radian**2
degree    = radian*np.pi/180
hertz     = second**-1
newton    = kilogram*meter/second**2
pascal    = newton/meter**2
joule     = newton*meter
watt      = joule/second
coulomb   = ampere*second
volt      = joule/coulomb
ohm       = volt/ampere
tesla     = newton/ampere/meter
gauss     = tesla/1e4

# More abbreviations
deg = degree
Hz  = hertz
N   = newton
Pa  = pascal
J   = joule
W   = watt
C   = coulomb
V   = volt
T   = tesla
G   = gauss

# Common physical constants
# 2018 NIST reference <http://physics.nist.gov/cuu/index.html>
speed_of_light      = 299792458*meter/second
planck              = 6.62607015e-34*joule*second
h_bar               = 1.054571817e-34*joule*second
avogadro            = 6.02214076e+23/mole
universal_gas       = 8.314462618*joule/(mole*kelvin)
boltzmann           = 1.380649e-23*joule/kelvin
electron_charge     = 1.602176634e-19*coulomb
electron_rest_mass  = 9.1093837015e-31*kilogram
proton_rest_mass    = 1.67262192369e-27*kilogram
stefan_boltzmann    = 5.670374419e-8*watt*m**-2*kelvin**-4
gravity             = 6.67430e-11*meter**3/(kilogram*second**2)


# Selected astronomical constants
# IAU, NSFA, and the Navy's almanac (http://asa.usno.navy.mil)
solar_mass_parameter = 1.32712440041e20*meter**3*second**-2
earth_mass_parameter = 3.986004356e14*meter**3/second**2
astronomical_unit    = 149597870700*meter

# Selected non-SI units of time
minute        = 60.0*second
hour          = 60.0*minute
hr            = hour
day           = 24.0*hour
year          = 365.24*day
yr            = year

# Selected non-SI units of length
angstrom          = 1.0e-10*meter
micrometer        = micro*meter
micron            = micrometer
millimeter        = milli*meter
mm                = millimeter
centimeter        = centi*meter
cm                = centimeter
kilometer         = kilo*meter
km                = kilometer
inch              = 2.54*centimeter
foot              = 12.0*inch
yard              = 3.0*foot
statute_mile      = 5280.0*foot
mile              = statute_mile
light_year        = speed_of_light*year
parsec            = 3.085680e+16*meter
pc                = parsec

# Selected non-SI units of volume
liter              = 1.0e-3*meter**3
cc                 = centimeter**3
imperial_gallon_uk = 4.54609*liter

# Selected non-SI units of linear velocity
kilometer_per_hour = kilometer/hour
kph                = kilometer_per_hour

# Selected non-SI units of mass
gram                 = kilogram/kilo
g                    = gram
atomic_mass_unit     = 1.0e-3*kilogram/(avogadro*mole)
amu                  = atomic_mass_unit
slug                 = 1.459390e+1*kilogram
solar_mass           = 1.9884e+30*kilogram
earth_mass           = 5.9722e+24*kilogram

# Selected non-SI units of force
dyne = 1.0e-5*newton

# Selected non-SI units of pressure
bar          = 1.0e+5*pascal
millibar     = milli*bar
mbar         = millibar
atmosphere   = 1.01325e+5*pascal
atm          = atmosphere
millimeterHg = 133.322*pascal
mmHg         = millimeterHg
GPa          = giga*pascal

# Selected non-SI units of energy
electronvolt = electron_charge*volt
eV           = electronvolt
erg          = 1.0e-7*joule
btu          = 1055.05585*joule
calorie      = 4.184*joule
gram_tnt     = 1000*calorie
ton_tnt      = 1e6*gram_tnt
kiloton_tnt  = 1000*ton_tnt
