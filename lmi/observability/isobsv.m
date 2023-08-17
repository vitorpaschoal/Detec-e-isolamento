function isobs = isobsv(A,C)
%     [rA,cA] = size(A);
%     [rC,cC] = size(C);
    O = obsv(A,C);
    Orank = rank(O);
    [rO,cO] = size(O);
    minDim = min([rO,cO]);
    if Orank < minDim
        isobs = 0;
    else
        isobs = 1;
    end
end