function [fullObs,A,C,P]= isobsvslslmi(Asigma, Csigma,lambdaSet)
%function [AsigmaLambda,alamb] = isobsvslslmi(Asigma, Csigma)
    %%TEST IF A SWITCHED LINEAR SYSTEM IS OBSERVABLE through the
    %%observability of the global system, or the convex combination.
    %%Requires a convex set
    %Returns the observability matrix, rank and a boolean if system is
    %Observable

    [rA,~] = size(Asigma{1,1});
    tol = 1E-7;
    ops = sdpsettings('solver','sedumi','verbose',0,'debug',0,'showprogress',0);
    %P = sdpvar(rA,rA,'diagonal');
    P = sdpvar(rA,rA);    
    %Return the value for lambda
    AsigmaLambda = makeconvexset(Asigma,lambdaSet);
    CsigmaLambda = makeconvexset(Csigma,lambdaSet);

    A = AsigmaLambda;
    C = CsigmaLambda;

    lmiRestr = [A'*P+P*A-C'*C<=-tol ,P >= tol];

    [fullObs,P] = solvelmi(P,lmiRestr,[],ops,'Global Observable for given lambda');
 
end




