function lambdaSet = randomlambda(Asigma)
    %Get a set of random lambdas
    N = length(Asigma);
    randomLambda = randfixedsum(N,1,1,0,1);
    lambdaSet= arrayfun(@(x) x,randomLambda','UniformOutput',false);   
end