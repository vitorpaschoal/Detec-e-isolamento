function [finalnet,tr] = trainfaultnetwork(x,t,labels,varargin)
    
    %%
    %labels = newThTable.timeseriesnames;
    %data = matrixData(:,2:end);
    p = inputParser;
    addOptional(p,'filename','net',@ischar);
    addOptional(p,'iterations',20,@isnumeric);
    addOptional(p,'savenet','no',@(x) any(validatestring(x,{'yes','no','y','n'})));
    parse(p,varargin{:});
    filename = p.Results.filename;
    iterations = p.Results.iterations;
    savenet = p.Results.savenet;
    %%
    %Test with ANN - MLP
    [net,tr] = patternrecogn(x,t);
    [~,~,~,incorrectPercent] = testnetwork(net,tr,x,t);
    newC = 100*(1-incorrectPercent);
    finalnet = net;
    
    % Test multiples nn
    for i = 1:iterations
        [net,~] = patternrecogn(x,t);
        [~,~,~,incorrectPercent] = testnetwork(net,tr,x,t);
        if newC <  100*(1-incorrectPercent)
            newC = 100*(1-incorrectPercent);
            finalnet = net;
        end
    end
    
    %gensim(finalnet,-1)
    
    if strcmp(savenet,'yes') || strcmp(savenet,'y') 
        save(['trainednetwork' filename datestr(now,'dd-mm-yyyy-HH-MM') '.mat'],'finalnet','tr','-v7.3');
    end
end


