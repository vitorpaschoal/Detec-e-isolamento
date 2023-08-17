function [parametersArray,operationsArray,factorsArray]  = makeFaultsTestParameters(sensor,boostsim)
    %Returns the cell array of parameters and operations with a composition of given
    %
    
    sensorFactors =  boostsim.sensorFactors; %Open and Gain Variation
    sensorOperations = boostsim.sensorOperations;
    
    paramFactors =  boostsim.paramFactors;
    paramArray = boostsim.paramArray;
    paramOperations =   boostsim.paramOperations;
    
    nParams = numel(paramArray);
    npOperations = numel(paramOperations);
    
    nsFactors = sum(cellfun(@numel,sensorFactors));
    npFactors = sum(cellfun(@numel,paramFactors));
    nfTotal = nsFactors*npFactors;
    
    newParamOperations = repmat(paramOperations,[1,nParams]);
    newParamArray = reshape(repmat(paramArray,[npOperations,1]),[1,npOperations*nParams]);
    
    parametersArray{nfTotal} = [];
    operationsArray{nfTotal} = [];
    factorsArray{nfTotal} = [];
    
    %Sensor and parameters factors
    n = 1;
    for i = 1:numel(sensorFactors)
        for j = 1:numel(sensorFactors{i})
            for k = 1:numel(paramFactors)
                for m = 1:numel(paramFactors{k})
                    parametersArray{n} = {newParamArray{k},sensor};
                    operationsArray{n} = {newParamOperations{k},sensorOperations{i}};
                    factorsArray{n} = {paramFactors{k}{m},sensorFactors{i}{j}} ;
                    n = n +1 ;
                end
            end
        end
    end
    
end