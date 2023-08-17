classdef BoostController
    %Classe do controlador Boost
    %   Define as matrizes do sistema e calcula os controladores
    % Herdar objeto do boostConverter e acrescentar somente os métodos de
    % controle!!!
    properties
        boostConverter
    end
    properties (Dependent)
        A1;
        A2;
        B1;
        B2;
        Q1;
    end
    
    methods
        function obj = BoostController(boostConverter)
            %Herda as propriedades da classe FuzzyOperations
            obj.boostConverter = boostConverter;
        end
        
        function A1 = get.A1(obj)
            A1 = obj.boostConverter.A1;
        end
        function A2 = get.A2(obj)
            A2= obj.boostConverter.A2;
        end
        
        function B1 = get.B1(obj)
            B1 = obj.boostConverter.B1;
        end
        function B2 = get.B2(obj)
            B2 = obj.boostConverter.B2;
        end
        
        function Q1 = get.Q1(obj)
            Q1 = [0 0;0 1/obj.boostConverter.Ro];
        end
        
        function P = Pstability(obj)
            P = sdpvar(size(obj.A1,1),size(obj.A1,2));
            rA1 = obj.makeRestriction(obj.A1,P);
            rA2 = obj.makeRestriction(obj.A2,P);
            restrictions = obj.getRestrictions(P,rA1,rA2);
            optimize(restrictions);
            P = value(P);
        end
        
        function [isStable,P,rA1,rA2] = isStable(obj)
            P = Pstability(obj);
            rA1 = obj.makeRestriction(obj.A1,P);
            rA2 = obj.makeRestriction(obj.A2,P);
            eig1 = eig(rA1);
            eig2 = eig(rA2);
            if (eig1 < 0) & (eig2 < 0) & (eig(P) > 0)
                isStable = 1;
            else
                isStable = 0;
            end
        end
        
        function [lyapA1,lyapA2] = lyapunov(obj,P,Q)
            %Returns the lyapunov equation for both subsystems
            lyapA1 = obj.makeRestriction(obj.A1,P,Q);
            lyapA2 = obj.makeRestriction(obj.A2,P,Q);
        end
        
        function P = calculateP(obj)
            P = sdpvar(size(obj.A1,1),size(obj.A1,2));
            rA1 =  obj.makeRestriction(obj.A1,P, obj.Q1);
            rA2 = obj.makeRestriction(obj.A2,P, obj.Q1);
            objective = trace(P);         
            restrictions = obj.getRestrictions(P,rA1,rA2);
            optimize(restrictions,objective);
            P = value(P);
        end
        
        function zeta = control_matrix(obj,P)
            zeta = P*((obj.A1 - obj.A2));
        end
        
        function controllaw = controllaw(obj,P,ve)
            %Retorna a matriz da lei de controle (27)
            xe = obj.boostConverter.equilibriumstate(ve);
            controllaw = control_matrix(obj,P)*xe;
        end        
    end
    methods (Static)
        function rest = makeRestriction(A,P,Q)
            if nargin>2
                rest = A'*P + P*A + Q;
            else
                rest = A'*P + P*A;
            end
        end
        
        function restrictions = getRestrictions(P,rA1,rA2)
             tolerance = 1e-15;
             restrictions = [P >= 0 +tolerance, rA1 <= 0 - tolerance,rA2  <= 0 - tolerance];
        end
    end
end


