function lambdaSet = boostlambda(Asigma,Bsigma,xe,u)
    %myFun - Description
    %
    % Syntax: lambdaSet = myFun(Asigma)
    %
    % Long description 
    tol = 1E-7;
    ops = sdpsettings('solver','sedumi','verbose',0,'debug',0,'showprogress',0,...
                'warning',0);
    lambdaSet = cellfun(@(x) sdpvar(1,1),Asigma,'UniformOutput',false);
    lambdaRestr = makelambdarestrictions(lambdaSet);
    Alambda = makeconvexset(Asigma,lambdaSet);
    Blambda = makeconvexset(Bsigma,lambdaSet);
    boostrestriction = [Alambda*xe + Blambda*u == 0]; %Maybe use a tolerance
    optimize([lambdaRestr boostrestriction],[],ops);
    %Return the value for lambda
    lambdaSet = cellfun(@(lamb) value(lamb),lambdaSet,'UniformOutput',false);
    
    end