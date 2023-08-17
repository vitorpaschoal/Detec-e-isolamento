function [upperBound,lowerBound] = getUpperLower(faultArray)
    diffArray = arrayfun(@(fault)(faultArray - fault),faultArray,'UniformOutput',false);
    %Returns upper and lower bound for thresholds
    maximum = 2*max(faultArray);
    minimum = 0.090;%min(faultArray);
    upperBound{length(diffArray)} = {};
    lowerBound{length(diffArray)} = {};
    for i = 1:length(diffArray)
        fault = diffArray{i};
        if isempty(min(fault(fault>0)))
            upperBound{i} = maximum;
        else
            upperBound{i} =  min(fault(fault>0));
        end
        if isempty(min(fault(fault<0)))
            lowerBound{i} = minimum;
        else
            lowerBound{i} =  max(fault(fault<0));
        end
    end
    upperBound = cell2mat(upperBound);
    lowerBound = cell2mat(lowerBound);
end