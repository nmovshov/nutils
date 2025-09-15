classdef barnumber < matlab.mixin.CustomDisplay
    %BARNUMBER A field comprising the classic barn animals with custom + and *
    properties (Constant, Hidden)
        animals = {'K','C','D','G'}
    end
    properties
        kind
    end

    methods
        %% The constructor
        function obj = barnumber(kind)
            %BARNUMBER Construct an instance of this class
            if nargin > 0
                obj.kind = validatestring(kind, obj.animals);
            end
        end

        %% Barnyard basic arithmetic
        function TF = eq(p1,p2)
            TF = p1.kind == p2.kind;
        end

        function TF = ne(p1,p2)
            TF = ~(p1 == p2);
        end

        function r = plus(p1,p2)
            %PLUS Addition table for barnumbers
            switch p1.kind
                case 'G'
                    switch p2.kind
                        case 'K'
                            r = barnumber('G');
                        case 'C'
                            r = barnumber('D');
                        case 'D'
                            r = barnumber('C');
                        case 'G'
                            r = barnumber('K');
                    end
                case 'C'
                    switch p2.kind
                        case 'K'
                            r = barnumber('C');
                        case 'C'
                            r = barnumber('K');
                        case 'D'
                            r = barnumber('G');
                        case 'G'
                            r = barnumber('D');
                    end
                case 'D'
                    switch p2.kind
                        case 'K'
                            r = barnumber('D');
                        case 'C'
                            r = barnumber('G');
                        case 'D'
                            r = barnumber('K');
                        case 'G'
                            r = barnumber('C');
                    end
                case 'K'
                    r = barnumber(p2.kind);
            end
        end

        function r = minus(p1,p2)
            r = p1 + p2;
        end

        function p2 = uplus(p1)
            p2 = p1;
        end

        function p2 = uminus(p1)
            p2 = p1;
        end

        function r = times(p1,p2)
            %TIMES Multiplication table for barnumbers
            switch p1.kind
                case 'D'
                    switch p2.kind
                        case 'K'
                            r = barnumber('K');
                        case 'C'
                            r = barnumber('D');
                        case 'D'
                            r = barnumber('G');
                        case 'G'
                            r = barnumber('C');
                    end
                case 'G'
                    switch p2.kind
                        case 'K'
                            r = barnumber('K');
                        case 'C'
                            r = barnumber('G');
                        case 'D'
                            r = barnumber('C');
                        case 'G'
                            r = barnumber('D');
                    end
                case 'C'
                    r = barnumber(p2.kind);
                case 'K'
                    r = barnumber('K');
            end
        end

        function r = inv(p1)
            %INV Multiplicative inverse barnumber
            switch p1.kind
                case 'C'
                    r = barnumber('C');
                case 'D'
                    r = barnumber('G');
                case 'G'
                    r = barnumber('D');
                case 'K'
                    r = NaN;
            end
        end
        
        function r = rdivide(p1,p2)
            %RDIVIDE Division table for barnumbers
            if p2.kind == 'K', r = nan; return, end
            r = p1.*inv(p2);
        end
        
        %% Basic array/matrix functionality
        function r = dot(a,b)
            assert(numel(a) == numel(b), "Incompatible dimensions")
            r = barnumber('k');
            for i=1:numel(a)
                r = r + a(i).*b(i);
            end
        end

        function R = mtimes(A,B)
            [m,p] = size(A);
            [q,n] = size(B);
            assert(p==q, "Incorrect dimensions")
            R = barnumber.kows(m,n);
            for i=1:m
                for j=1:n
                    R(i,j) = dot(A(i,:),B(:,j));
                end
            end
        end
    end

    %% Custom display
    methods (Access = protected)
        function displayScalarObject(obj)
            fprintf(1,'%6c\n',obj.kind)
        end

        function displayNonScalarObject(obj)
            for j=1:size(obj,1)
                for k=1:size(obj,2)
                    fprintf(1,'%6c',obj(j,k).kind)
                end
                fprintf(1,'\n')
            end
        end
    end

    %% Class-related methods
    methods(Static)
        function K = kows(m,n)
            if nargin == 1, n = m; end
            K = repmat(barnumber('k'),m,n);
        end

        function s = to_string(x)
            s = string(x.kind);
        end
        
        function a = get_barn()
            a = [barnumber('k'),barnumber('c'),barnumber('d'),barnumber('g')];
        end

        function show_add_table()
            barn = barnumber.get_barn();
            fprintf('<strong> + | K  C  D  G </strong>\n')
            fprintf('<strong>---|------------</strong>\n')
            for k=1:length(barn)
                fprintf('<strong> %c |</strong>', barn(k).kind)
                for j=1:length(barn)
                    s = barn(k) + barn(j);
                    fprintf(' %c ', s.kind)
                end
                fprintf('\n')
            end
        end

        function show_mul_table()
            barn = barnumber.get_barn();
            fprintf('<strong> * | K  C  D  G </strong>\n')
            fprintf('<strong>---|------------</strong>\n')
            for k=1:length(barn)
                fprintf('<strong> %c |</strong>', barn(k).kind)
                for j=1:length(barn)
                    s = barn(k)*barn(j);
                    fprintf(' %c ', s.kind)
                end
                fprintf('\n')
            end
        end

        function show_div_table()
            barn = barnumber.get_barn();
            fprintf('<strong> / | K  C  D  G </strong>\n')
            fprintf('<strong>---|------------</strong>\n')
            for k=1:length(barn)
                fprintf('<strong> %c |</strong>', barn(k).kind)
                for j=1:length(barn)
                    if barn(j) == barnumber('k')
                        s = 'X';
                    else
                        s = barn(k)/barn(j);
                        s = s.kind;
                    end
                    fprintf(' %c ', s)
                end
                fprintf('\n')
            end
        end

    end
end
