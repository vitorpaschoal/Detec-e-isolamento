classdef BuckBoostConverter
    %Classe do controlador Boost
    %   Define as matrizes do sistema e calcula os controladores
    
    properties
        L %mH
        C %mF
        u %V
        Ro %Ohm
        R %Ohm
        C1;
        C2;
        B2;
    end
    properties (Dependent)
        A1;
        A2;
        B1;
        Q1;
    end
    
    methods
        function obj = BuckBoostConverter(Ro,R,L,C,u)
   
            if nargin<1
                obj.L = sym('L'); %H
                obj.C = sym('C'); %F
                obj.u = sym('u');%V
                obj.Ro = sym('Ro');%Ohm
                obj.R = sym('R');%Ohm
                obj.C1 = eye(2);
                obj.C2 = eye(2);
            else
                obj.Ro = Ro;
                obj.R = R;
                obj.L = L;
                obj.C = C;
                obj.u = u;
                obj.C1 = [1 0;0 -1];
                obj.C2 = [1 0;0 -1];
                obj.B2 = [0;0];
            end
        end
        
        function A1 = get.A1(obj)
            A1 = [-obj.R/obj.L 0;0 -1/(obj.Ro*obj.C)];
        end
        function A2 = get.A2(obj)
            A2 = [-obj.R/obj.L 1/obj.L;-1/obj.C -1/(obj.Ro*obj.C)];
        end
        
        function B1 = get.B1(obj)
            B1 = [1/obj.L;0];
        end
        
        function boost_parameters = parameters(obj)
            %Retorna os parâmetros em forma de array
            boost_parameters = [obj.Ro,obj.R,obj.L,obj.C,obj.u]';
        end
        
        function  boost_Amatrices = Amatrices(obj)
            %Retorna as matrizes em forma de matriz de 3 dimensões3
            boost_Amatrices = cat(3,obj.A1,obj.A2);
        end
        
        function  boost_Bmatrices = Bmatrices(obj)
            %Retorna as matrizes em forma de matriz de 3 dimensões3
            boost_Bmatrices = cat(3,obj.B1,obj.B2);
        end
     
        function boost_Cmatrices = Cmatrices(obj)
            boost_Cmatrices = cat(3,obj.C1,obj.C2);
        end
        
        function I_e = I_e(obj)
                v_e = sym('v_e');
                I_e = i_e(obj,v_e);
        end
        
        function [i_e,delta_ie] = i_e(obj,ve)
            if obj.R ~= 0
                delta_ie = (-obj.Ro*obj.u)^2 - 4*(ve^2+obj.u*ve)*(obj.R*obj.Ro);
                i_e = ((obj.u*obj.Ro) - sqrt(delta_ie))/(2*obj.R*obj.Ro);
            else
                i_e = (ve^2-obj.u*ve)/(obj.u*obj.Ro);
            end
        end
        
        function x_e = x_e(obj,ve)
            ie = i_e(obj,ve);
            x_e = [ie;ve];
        end
        
        function X_e = X_e(obj)
            A_lambda = obj.generatePolytope(obj.A1,obj.A2);
            B_lambda = obj.generatePolytope(obj.B1,obj.B2);
            X_e = -A_lambda\B_lambda*obj.u;
        end
    
    end
    methods (Static)
        function A_lambda = generatePolytope(A1,A2,lambda)
            if nargin < 3
                lambda = sym('lambda');
            end
            A_lambda = lambda*A1 + (1-lambda)*A2;
        end
    end

end




