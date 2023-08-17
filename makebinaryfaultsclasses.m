function [matrixData,matrixClasses,tsMatrix,newThTs] = makebinaryfaultsclasses(simTsobj)
    %Makes table for faults classifications,
    %matrixData = zeros(size(thArray{1},1),length(thArray));
    newthArray = simTsobj;
    %newthArray = keepfeatures(obj,[featuresArray,{'Class'}]);
    newThTs = newthArray;
    tsTables = table(newThTs);
    resultsTable = vertcat(tsTables{:,:});     
    classes = resultsTable.Class;
    resultsTable.Class = [];
    resultsTable.Class = classes;   
    tscgMatrix = table2array(resultsTable); 
    tsMatrix =tscgMatrix(:,2:end);%Remove Time
    
    matrixData = tsMatrix(:,1:end-1);
    classArray = unique(classes,'rows');
    
    matrixClasses = zeros(size(matrixData,1),length(classArray));
    %Complete Matrix
    for i = 1:length(classArray)
        matrixClasses(:,i) = classes == classArray(i);
    end
    
end
