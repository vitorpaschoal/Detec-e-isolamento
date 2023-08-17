classdef BoostConverter
    %Classe do controlador Boost
    %   Define as matrizes do sistema e calcula os controladores
    
    properties
        L %mH
        C %mF
        u %V
        Ro %Ohm
        R %Ohm
        C1;
    end
    properties (Dependent)
        A1;
        A2;
        B1;
        B2;
        Q1;
    end
    
    methods
        function obj = BoostConverter(Ro,R,L,C,u)
   
            if nargin<1
                obj.L = sym('L'); %H
                obj.C = sym('C'); %F
                obj.u = sym('u');%V
                obj.Ro = sym('Ro');%Ohm
                obj.R = sym('R');%Ohm
                obj.C1 = eye(2);
             
            else
                obj.Ro = Ro;
                obj.R = R;
                obj.L = L;
                obj.C = C;
                obj.u = u;
                obj.C1 = eye(2);
              
            end
        end
        
        function A1 = get.A1(obj)
            %Switch closed - d = 1
            A1 = [-obj.R/obj.L 0;0 -1/(obj.Ro*obj.C)];
        end
        function A2 = get.A2(obj)
            %Switch open - d = 0
            A2 = [-obj.R/obj.L -1/obj.L;1/obj.C -1/(obj.Ro*obj.C)];
        end
        
        function B1 = get.B1(obj)
            B1 = [1/obj.L;0];
        end
        function B2 = get.B2(obj)
            B2 = obj.B1;
        end      
               
        function boost_parameters = Parameters(obj)
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
            boost_Cmatrices = cat(3,obj.C1,obj.C1);
        end
        
        function I_e = I_e(obj)
                v_e = sym('v_e');
                I_e = i_e(obj,v_e);
        end
        
        function [i_e,delta_ie] = equilibriumcurrent(obj,ve)
            delta_ie = (-obj.u/obj.R)^2 - (4*ve^2)/(obj.R*obj.Ro);
            i_e = ((obj.u/obj.R) - sqrt(delta_ie))/2;
        end
        
        function x_e = equilibriumstate(obj,ve)
            ie = equilibriumcurrent(obj,ve)
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
%     %The following four parameters are needed to calculate the power stage:
%        % 1. Input Voltage Range: VIN(min)and VIN(max)
%        %2. Nominal Output Voltage: VOUT
%        %3. Maximum Output Current: IOUT(max)
%        clc;
%        disp('BOOST CONVERTER CALCULATION')
%  Vin=input('enter the minimum input voltage:: ');
%  Vin1=input('enter the maximum input voltage:: ');
%  Vout=input('enter the output voltage:: ');
%  I=input('enter the maximum output current:: ');
%  fs=input('enter the switching frequency:: ');
%  %calculation of maximum switch current
%  n=0.9;
%  D=1-((Vin*n)/Vout); %duty cycle
%  di=.2*I*(Vout/Vin); %inductor ripple current
%  L=(Vin*(Vout-Vin1))/(di*fs*Vout); %inductor value
%  %dv=(I/(1-D))+(di/2);
%  dv=0.5;
%  C=I*D/(fs*dv);%output capacitor value
%  R=Vout/I;
%  disp('*****************************')
%  disp('DUTY CYCLE::::')
%  D=D*100;
%  D
%  disp('RIPPLE CURRENT:::')
%  di
%  disp('INDUCTOR VALUE:::')
%  L
%  disp('VOLTAGE RIPPLE:::')
%  dv
%  disp('CAPACITOR VALUE micro farad:::')
%  C=C;
%  C 
%  R
%  disp('**************************')
%  
end


