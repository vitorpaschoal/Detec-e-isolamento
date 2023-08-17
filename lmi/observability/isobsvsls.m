function [fullObs, isObsSigma, rankSigma, Osigma] = isobsvsls(Asigma, Csigma)
    %%TEST IF A SWITCHED LINEAR SYSTEM IS OBSERVABLE through the
    %Returns the observability matrix, rank and a boolean if system is
    %Observable
    %         [rA,cA] = size(Asigma{1,1});
    %     [rC,cC] = size(Csigma{1,1});
    %Must extend this funcion for N > 2

    Osigma = cellfun(@obsv, Asigma, Csigma, 'UniformOutput', false);
    rankSigma = cellfun(@rank, Osigma, 'UniformOutput', false);
    isObsSigma = cellfun(@isobsv, Asigma, Csigma, 'UniformOutput', false);
    %If is for a convex set
    fullObs = any(cell2mat(isObsSigma));
    %If for a noncovex set
    % fullObs = all(cell2mat(isObsSigma));
end



