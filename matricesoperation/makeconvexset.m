function AsigmaLambda = makeconvexset(Asigma,lambdaSet)
    %%Make lambda multipication
    N = length(Asigma);
    [rA,cA] = size(Asigma{1,1});
    %Create Lambda set for each subsystem
    AsigmaLambda1 = cellfun(@(A,lamb) lamb*A, Asigma,lambdaSet,...
            'UniformOutput',false);
    alamb = [AsigmaLambda1{:}];  
    alamb = reshape(alamb,[rA,cA,N]);
    % Alambda=w1*A1+w2*A2+w3*A3;
    AsigmaLambda = sum(alamb,3);
end