function isctrb = isctrb(A,B)
%     [rA,cA] = size(A);
%     [rC,cC] = size(C);
    C = ctrb(A,B);
    Crank = rank(C);
    [rC,cC] = size(C);
    minDim = min([rC,cC]);
    if Crank < minDim
        isctrb = 0;
    else
        isctrb = 1;
    end
end