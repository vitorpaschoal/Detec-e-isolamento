function [tsClassNum,tsClassNumbers] = testclass(obj,testName)
    % Test if the fault belongs to some class
    if isempty(testName)
        tsClassNum = 0;
        return
    end
    testNum = cellfun(@(name) contains(testName,name),obj.FaultsMap.keys);
    values = obj.FaultsMap.values;
    
    if nnz(testNum) == 0
        tsClassNum = 0;
    else
        testValues = values(testNum);
        tsClassNumbers = cell2mat(testValues);
        tsClassNum = tsClassNumbers(1);
    end
    
  
end