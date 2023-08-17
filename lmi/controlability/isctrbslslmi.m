function [fullCtrb,A,B,P]= isctrbslslmi(Asigma, Bsigma,lambdaSet)
    %function [AsigmaLambda,alamb] = isobsvslslmi(Asigma, Csigma)
        %%TEST IF A SWITCHED LINEAR SYSTEM IS OBSERVABLE through the
        %%observability of the global system, or the convex combination.
        %%Requires a convex set
        %Returns the observability matrix, rank and a boolean if system is
        %Controllable

        [rA,~] = size(Asigma{1,1});
        tol = 1E-7;
        ops = sdpsettings('solver','sedumi','verbose',0,'debug',0,'showprogress',0);
        %P = sdpvar(rA,rA,'diagonal');
        P = sdpvar(rA,rA);
          
        %Return the value for lambda
  
        AsigmaLambda = makeconvexset(Asigma,lambdaSet);
        BsigmaLambda = makeconvexset(Bsigma,lambdaSet);

        A = AsigmaLambda;
        B = BsigmaLambda;
        lmiRestr = [A*P+P*A'-B*B'<=-tol ,P >=tol];
        [fullCtrb,P] = solvelmi(P,lmiRestr,[],ops,'Controllable'); 
        
end

% function lmiRestr = ctrblmirestr(Asigma,Bsigma,testType)
%     if strcmp(testType,'local')
%         lmiRestr = [Asigma*P+P*A'-Bsigma*Bsigma'<0 ,P > 0];
%     else
%         lmiRestr = [A*P+P*A'-B*B'<0 ,P > 0];
%     end    
% end,
%myFun - Description
%
% Syntax: restr = myFun(input)
%
% Long description
    

  
    
    
    % function [matrixValue,lambdaValue] = evalconvexset(Asigma)
    % %myFun - Description
    % %
    % % Syntax: [matrixValue,lambdaValue] = myFun(input)
    % %
    % % Long description
    % N = length(Asigma);
    % %[rC,cC] = size(Csigma{1,1});
    % [rA,~] = size(Asigma{1,1});
    % ops = sdpsettings('solver','sedumi','verbose',1,'debug',1)
    
    % %Generates lambdas 
    % lambdaSet = cellfun(@(x) sdpvar(1,1),Asigma,'UniformOutput',false);
    
    % %AsigmaLambda  = makeconvexset(Asigma,lambdaSet);
    % AsigmaLambda = makeconvexset(Asigma,lambdaSet);
    % CsigmaLambda = makeconvexset(Csigma,lambdaSet);
    
    % lambdaRestr = makelambdarestrictions(lambdaSet);
    
    
    % optimize(lambdaRestr,[],ops);
    % %Return the value for lambda
    
    % A  = cellfun(@(lamb) value(lamb),AsigmaLambda,'UniformOutput',false);;
    % C = cellfun(@(lamb) value(lamb),CsigmaLambda,'UniformOutput',false);;
    % lambdaSet = cellfun(@(lamb) value(lamb),lambdaSet,'UniformOutput',false);
    
    % end