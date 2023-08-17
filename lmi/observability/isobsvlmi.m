function [fullObs, P] = isobsvlmi(A, C)
    %function [AsigmaLambda,alamb] = isobsvslslmi(Asigma, Csigma)
    %%TEST IF A SWITCHED LINEAR SYSTEM IS OBSERVABLE through the
    %%observability of the local systems
    %Returns the observability matrix, rank and a boolean if system is
    %Observable

    %Tests locally   - P common
    [rA, ~] = size(A);
    tol = 1E-7;
    ops = sdpsettings('solver', 'sedumi', 'verbose', 0, ...
        'debug', 0, 'showprogress', 0);
    P = sdpvar(rA, rA,'full');

    restr = [A'*P +  P*A - C'*C <= -tol];

    lmiRestr = [P >= tol, restr];
    [fullObs, P] = solvelmi(P, lmiRestr, [], ops, 'Local Observable');
    
end
