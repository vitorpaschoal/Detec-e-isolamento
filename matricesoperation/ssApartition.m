function [AsigmaBar_partitions,BsigmaBar_partitions,AsigmaBar_11,AsigmaBar_12,AsigmaBar_21,AsigmaBar_22]= ssApartition(AsigmaBar,BsigmaBar,CsigmaBar)
    %Partioning of the system matrices.
    %Insert BsigmaBar
    [rA,~] = size(AsigmaBar{1,1});
    [rC,~] = size(CsigmaBar{1,1});
    [rB,cB] = size(BsigmaBar{1,1});
    h = rA-rC; %Rank difference    
    AsigmaBar_11 = cellfun(@(x) x(1:h,1:h),AsigmaBar,...
        'UniformOutput',false);
    AsigmaBar_12 = cellfun(@(x) x(1:h,h+1:rA),AsigmaBar,...
        'UniformOutput',false);
    AsigmaBar_21 = cellfun(@(x) x(h+1:rA,1:h),AsigmaBar,...
        'UniformOutput',false);
    AsigmaBar_22 = cellfun(@(x) x(h+1:rA,h+1:rA),AsigmaBar,...
        'UniformOutput',false); 
    BsigmaBar_1 =  cellfun(@(x) x(1:h,1:cB),BsigmaBar,...
    'UniformOutput',false);
    BsigmaBar_2 =  cellfun(@(x) x(h+1:rB,1:cB),BsigmaBar,...
    'UniformOutput',false);
    %Define Bsigma Bar
    AsigmaBar_partitions = {AsigmaBar_11,AsigmaBar_12,AsigmaBar_21,AsigmaBar_22};
    BsigmaBar_partitions = {BsigmaBar_1,BsigmaBar_2};
end