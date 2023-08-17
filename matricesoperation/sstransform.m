function [AsigmaBar,BsigmaBar,CsigmaBar] = sstransform(Asigma, Bsigma,Csigma,V)
    %Transform the matrix into a new switched state space
    CsigmaBar = cellfun(@(x) x*V, Csigma, 'UniformOutput',false);
    AsigmaBar = cellfun(@(x) inv(V)*x*V, Asigma, 'UniformOutput',false);
    BsigmaBar = cellfun(@(x) inv(V)*x, Bsigma, 'UniformOutput',false);
end