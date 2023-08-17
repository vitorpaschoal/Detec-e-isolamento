function [x,t,labels] = getnndata(simTsgroup,downRate)
    %Fault analysis statements
    %define a time window (maybe one unit more than actual threshold)
    %tsArray = simTsgroup;
    [matrixData,matrixClasses,~,newThTable] = makebinaryfaultsclasses(simTsgroup);
   
    [x,t] = preproccess(matrixData,matrixClasses);
    
    labels = newThTable.timeseriesnames;
    
    plotmatrix2(x',labels(1:end-1))

    function [x,t] = preproccess(matrixData,matrixClasses)
        %Remove duplicates
        mDataCol = size(matrixData,2);
        %downRate = 10; %downsample rate
        
        matrixComplete =[matrixData,matrixClasses];
        %[matrixSimple,~] = unique(matrixComplete,'rows');
        matrixSimple = matrixComplete;
        matrixDown = downsample(matrixSimple,downRate);
        dataMatrix = matrixDown(:,1:mDataCol);
        classMatrix = matrixDown(:,mDataCol+1:end);
        
        x = dataMatrix';
        t = classMatrix';
    end
    
end

