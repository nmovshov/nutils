classdef (Abstract) EquationOfState
    %EquationOfState An equation-of-state abstract base class.
    %   The EquationOfState abstract base class will implement only
    %   initialization of named constants and will define syntax for specialized
    %   equations of state subclasses.
    
    properties
        si;
    end
    
    % Constructor
    methods
        function eos = EquationOfState()
            % Superclass constructor called implicitly with no arguments
            % whenever a subclass instance is created.
            try
                eos.si = setUnits; % development/debugging
            catch
                eos.si = setFUnits; % deployment/production
            end
        end
    end
    
    % Required methods for any equation of state class
    methods (Abstract)
       pressure(obj) 
    end
    
end

