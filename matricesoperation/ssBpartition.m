function [BsigmaBar_1,BsigmaBar_2]= ssBpartition(BsigmaBar,CsigmaBar)
    %Partioning of the system matrices.
    [rB,cB] = size(BsigmaBar{1,1});
    [rC,~] = size(CsigmaBar{1,1});
    h = rB-rC ;%Rank difference    
    BsigmaBar_1 = cellfun(@(x) x(1:h,cB),BsigmaBar,...
        'UniformOutput',false);
    BsigmaBar_2 = cellfun(@(x) x(h+1:rB,cB),BsigmaBar,...
        'UniformOutput',false); 
end
