function lambdaRestr = makelambdarestrictions(lambdaSet)
    %makelambdarestrictions - make the restrictions
    %
    % Syntax: lambdaRestr = makelambdarestrictions(input)
    %
    % Long description
    tol = 1E-5;
    N = length(lambdaSet);
    lambdaArray = [lambdaSet{:}];
    sumLambda = sum(lambdaArray(1:end-1));

    %w1>=0 w2>=0 w3>=0
    lambdaRestr1 = cellfun(@(lamb) lamb >= 0,lambdaSet,'UniformOutput',false);
    %Restriction - % w_I=1-w1-w2-...-w_i
    lambdaRestr = [lambdaRestr1{:}, lambdaSet{end} >= 1- sumLambda-tol, ... 
        lambdaSet{end} <= 1- sumLambda];

end