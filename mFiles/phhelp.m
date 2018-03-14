%% Physunits Toolbox Documentation

%% About the Physunits toolbox
% The Physunits toolbox is an attempt to confer dimensional `awareness' to
% the MATLAB environment. The motivation for this, as well as a suggested
% way to go about it, are explained in
% Automated computation and consistency checking of physical dimensions
% and units in scientific programs, Petty, G.W., Software - Practice and
% Experience, (Volume 31, Issue 11, 19 June 2001)
%
% The author of the same has also made available for download a FORTRAN90
% module that implements this ides in the FORTRAN language. The module and
% paper can be downloaded from http://meso.aos.wisc.edu/~gpetty .
%
% The Physunits toolbox is based on the above module, and expands
% it, while trying to adhere consistently to MATLAB standards and
% practices.

%% How it works
%%
% The PHYSUNITS toolbox works by defining the PREAL class, with a PREAL
% data type and overloaded functions to support it. An object of type
% PREAL represents a physical quantity. It has two fields:
%%
% * |value| - The numerical value, which must be a numerical type with
% zero imaginary part.
% * |units| - A vector of 7 numbers, representing the physical dimensions
% associated with |value|.
%
% The format for the |units| vector is [|length|,
% |mass|, |time|, |temperature|, |electric current|, |amount of matter|,
% |luminous intensity|],
% but this format is usually transparent to the user, who defines her
% variables via an interface structure.
%
% The overloaded functions and
% operators are then responsible for enforcing consistency in all
% operations envolving PREAL variables. In particular:
%%
% * Addition of two variables is only possible if they have the same
% dimensions.
% * Exponents must be dimensionless.
% * Trancendental functions accept dimensionless arguments only.
% * Binary logical operations can only be perfomed on variables having the
% same dimensions.


%% Using the PREAL class
%%
% The PREAL class constructor accepts two arguments: a scalar real number,
% and a vector of 7 real numbers; and creates a PREAL object using these
% arguments for the
% value and units fields. This is a cumbersome and error prone method but,
% fortunately, the user will rarely need to use it directly. Instead she
% calls the function |setUnits|, which returns an interface structure
% that greatly facilitates the definition and use of dimensioned variables.
%
% The interface structure contains predefined variables of type PREAL,
% representing the basic SI units as well as many other units,
% derived units, constants of nature, parameters, etc. Get this
% structure by calling the setUnits function. Once this interface
% structure is present in your workspace, you can the use the predefined
% variables.

%% Examples
%%
% In the command window, get the interface structure by calling setSIUnits:
si=setUnits;
%%
% Create PREAL variables by multiplying double literals with the predefined
% unit variables:
x=2*si.meter
%%
dr=1e-3*si.m
%%
F=12*si.newton
%%
% Operations on PREAL types follow the rules of physical dimensions:
x^2
%%
x+dr
%%
sin(dr/x)
%%
F*dr
%%
% You can use the |double| function to convert a preal variable to a
% double. (This function simply discards the |units| field of the variable.)
fprintf('Work done is %g joules.\n',double(F*dr))
%%
% Attempting an illegal operation results in an error:
%x+F
%%
% Notice that, as a bonus, the physunits toolbox can be used as a unit
% converter.
fprintf('One joule equals %g ergs.\n',double(si.joule/si.erg))
fprintf('One dyne equals %g Newtons.\n',double(si.dyne/si.newton))

%% Sample program
% A short sample program that demonstrates the PREAL class can be found in
% |...\physunits\iceball.m|.

%% Extending the Physunits toolbox
% Anyone who will use the Physunits toolbox will undoubtedly discover that
% new capabilities need to be added. More than likely, these will include
% more functions that need to be overloaded for the PREAL class. If you get
% an error message from MATLAB complaining that function so-and-so is not
% defined for class PREAL, then you should simply define it for the PREAL
% class by putting an m-file with the same name in the |@preal| directory.
% For example, the function |sin| is defined for the PREAL class. Take a
% look in the file |sin.m| that resides in the |@preal| directory to see
% how it is defined. With this function as a reference it should not be
% difficult to define the |asin| function also for the PREAL class should
% you find it necessary.
%
% Another improvent you are likely to need is the addition of more
% predefined variables used often in your work.
% This may be done by editing the |setUnits| function,
% and adding the required definitions at the end of the file.

%% Disabling the Physunits toolbox
% Using physical units in calculations is helpful and natural for
% scientists and engineers, but the need to use a user-defined type instead
% of the standard DOUBLE class comes with a penalty on performance. Long
% calculations involving PREAL variables may become too slow. A way to
% `turn off' the dimensional awareness of the code is therefore desirable.
% Converting all PREAL variables into doubles with the |double| function is
% not practical. Instead, use the |physunits| function with the 'off' flag
% at the beginning of your code.
physunits off

%%
% This causes all _subsequent_ variables defined as PREALs in the code to
% be treated as regular double variables. The rest of the code should run
% exactly as it would were it written without any use of PREALs.
%
% The recommended practice is therefore to use PREAL variables with
% physical dimensions throughout the code, enjoying the benefits of automatic
% consistency checks, dimensional tracking, and dimensional display, during
% development and debugging. When the code is ready for the `operational'
% run, a one-line comand at the beginning will restore performance and
% efficiency to optimal.