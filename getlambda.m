function lambdaSet = getlambda(Asigma, method)
    %myFun - Description
    %
    % Syntax: getlambda = myFun(input)
    %
    % Long description
    if strcmp(method, 'random')
        lambdaSet = randomlambda(Asigma);
    else
        lambdaSet = optimizeLambda(Asigma);
    end

end
