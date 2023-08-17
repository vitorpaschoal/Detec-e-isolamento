function [parametersArray,operationsArray,factorsArray]  = makeFaultsOperations(param,paramOperations,paramFactors)
%Returns the array of parameters and operations with a composition of given
%data
%paramOperations,paramFactors
nfTotal = sum(cellfun(@numel,paramFactors));
parametersArray = repmat(param,[1,nfTotal]);

operationsArray = getArray(paramFactors,paramOperations);
factorsArray = extractArray(paramFactors);

end

function array2return = getArray(factorArray,infoArray)
    nfTotal = sum(cellfun(@numel,factorArray));
    array2return = cell(1,nfTotal);
    k = 1 ;
    for i =1:numel(factorArray)
        for j = 1:numel(factorArray{i})
             array2return{k} = infoArray{i};
             k = k +1 ;
        end
    end

end



function array2return = extractArray(factorArray)
    nfTotal = sum(cellfun(@numel,factorArray));
    array2return = cell(1,nfTotal);
    k = 1 ;
    for i =1:numel(factorArray)
        for j = 1:numel(factorArray{i})
             array2return{k} = factorArray{i}{j};
             k = k +1 ;
        end
    end

end