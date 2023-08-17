function lambdaSet = optimizeLambda(Asigma)
%myFun - Description
%
% Syntax: lambdaSet = myFun(Asigma)
%
% Long description 
ops = sdpsettings('solver','sedumi','verbose',0,'debug',0);
lambdaSet = cellfun(@(x) sdpvar(1,1),Asigma,'UniformOutput',false);
lambdaRestr = makelambdarestrictions(lambdaSet);
optimize(lambdaRestr,[],ops);
%Return the value for lambda
lambdaSet = cellfun(@(lamb) value(lamb),lambdaSet,'UniformOutput',false);

end