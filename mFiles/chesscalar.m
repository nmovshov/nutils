classdef chesscalar
    %CHESSCALAR A field comprising the four chess pieces with custom + and *
    properties (Constant, Hidden)
        pieces = {'Q','R','B','N','NaN'}
    end
    properties
        kind
    end

    methods
        %% The constructor
        function obj = chesscalar(kind)
            %CHESSCALAR Construct an instance of this class
            if nargin > 0
                obj.kind = validatestring(kind, obj.pieces);
            end
        end

        %% Display overload
        function disp(obj)
            fprintf(1,'%6s\n',obj.kind)
        end

        %% Chess arithmetic
        function TF = eq(p1,p2)
            TF = p1.kind == p2.kind;
        end

        function TF = ne(p1,p2)
            TF = ~(p1 == p2);
        end

        function r = plus(p1,p2)
            %PLUS Addition table for chesscalars
            switch p1.kind
                case 'Q'
                    switch p2.kind
                        case 'Q'
                            r = chesscalar('N');
                        case 'R'
                            r = chesscalar('B');
                        case 'B'
                            r = chesscalar('R');
                        case 'N'
                            r = chesscalar('Q');
                    end
                case 'R'
                    switch p2.kind
                        case 'Q'
                            r = chesscalar('B');
                        case 'R'
                            r = chesscalar('N');
                        case 'B'
                            r = chesscalar('Q');
                        case 'N'
                            r = chesscalar('R');
                    end
                case 'B'
                    switch p2.kind
                        case 'Q'
                            r = chesscalar('R');
                        case 'R'
                            r = chesscalar('Q');
                        case 'B'
                            r = chesscalar('N');
                        case 'N'
                            r = chesscalar('B');
                    end
                case 'N'
                    r = chesscalar(p2.kind);
            end
        end
        
        function r = times(p1,p2)
            %TIMES Multiplication table for chesscalars
            switch p1.kind
                case 'Q'
                    switch p2.kind
                        case 'Q'
                            r = chesscalar('R');
                        case 'R'
                            r = chesscalar('B');
                        case 'B'
                            r = chesscalar('Q');
                        case 'N'
                            r = chesscalar('N');
                    end
                case 'R'
                    switch p2.kind
                        case 'Q'
                            r = chesscalar('B');
                        case 'R'
                            r = chesscalar('Q');
                        case 'B'
                            r = chesscalar('R');
                        case 'N'
                            r = chesscalar('N');
                    end
                case 'B'
                    r = chesscalar(p2.kind);
                case 'N'
                    r = chesscalar('N');
            end
        end

        function r = inv(p1)
            %INV Multiplicative inverse chesscalar
            switch p1.kind
                case 'Q'
                    r = chesscalar('R');
                case 'R'
                    r = chesscalar('Q');
                case 'B'
                    r = chesscalar('B');
                case 'N'
                    r = chesscalar('NaN');
            end
        end
        
        function r = rdivide(p1,p2)
            %RDIVIDE Division table for chesscalars
            if p2.kind == 'N', r = chesscalar('NaN'); return, end
            r = p1.*inv(p2);
        end

        function R = mrdivide(P1,P2)
            R = P1;
            for k=1:numel(P1)
                R(k) = P1(k)./P2(k);
            end
        end

        function R = mtimes(P1, P2)
            R = P1;
            for k=1:numel(P1)
                R(k) = P1(k).*P2(k);
            end
        end

        function r = minus(p1,p2)
            r = p1 + p2;
        end
        
        function p2 = uminus(p1)
            p2 = p1;
        end
        
        function p2 = uplus(p1)
            p2 = p1;
        end
    end
end
