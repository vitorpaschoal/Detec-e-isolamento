function [fullCtrb,isCtrbSigma,rankSigma,Bsigma]= isctrbsls(Asigma, Bsigma)
    %%TEST IF A SWITCHED LINEAR SYSTEM IS OBSERVABLE through the
    %%observability of each pair
    %Returns the observability matrix, rank and a boolean if system is 
    %Observable
%         [rA,cA] = size(Asigma{1,1});
%     [rC,cC] = size(Csigma{1,1});
    Bsigma = cellfun(@ctrb,Asigma,Bsigma, 'UniformOutput',false);
    rankSigma = cellfun(@rank,Bsigma, 'UniformOutput',false);
    isCtrbSigma = cellfun(@isctrb,Asigma,Bsigma, 'UniformOutput',false);
    fullCtrb = all(cell2mat(isCtrbSigma));    
end

