function [fis,rulesTable] = createFuzzy(fuzzyName,filePath,paramArray,objArrayNames,simMatrix)

%Creates fuzzy system

accuracy = 0.25; %Fuzzy Interval
fuzzyNameStr = convertCharsToStrings(fuzzyName);
fis = mamfis('Name',fuzzyNameStr);
l_simMatrix = size(simMatrix,1);

switch l_simMatrix
    case 3
        msNames = ["ZE","ME","ON"];
    case 4 
         msNames = ["ZE","LO","ME","ON"];
    case 5
        msNames = ["ZE","LO","ME","HI","ON"];     
    otherwise
        msNames = ["ZE","EL","VL","LO","ML","ME","MH","HI","VH","EH","ON"];
end

% EL: Extremamente baixo
% VL: Muito baixo (Very Low)
% LO: Baixo (Low)
% ME: Médio (Medium)
% HI: High
% VH: Very High
% ZE: Zero
% EH: Extremaly High
% ML: Medium Low
% MH: Medium High
% ON: One

outNames = objArrayNames;
msIndexes = zeros(l_simMatrix,length(paramArray));

fis = addOutput(fis,[0 1],'Name',"Output");
outMax = 0.05;
outInterval = 0.075;

%Makes inputs and output membership functions
for i = 1:length(paramArray)
    fis = addInput(fis,[0 1],'Name',paramArray{i});
    [msArray,msIndexes(:,i)] = sort(simMatrix(:,i));
    for j = 1:length(msArray)
        if j == 1
            fis = addMF(fis,paramArray{i},"trapmf",[-0.1 0 msArray(j) (1+accuracy)*msArray(j)],'Name',msNames(j));
        elseif  j == length(msArray)
            fis = addMF(fis,paramArray{i},"trapmf",[(1-accuracy)*msArray(j) 0.85*msArray(j) msArray(j) 1.1],'Name',msNames(j));
        else
            fis = addMF(fis,paramArray{i},"trimf",[(1-accuracy)*msArray(j) msArray(j) (1+accuracy)*msArray(j)],'Name',msNames(j));
        end
    end
end


%Create inputs and output membership functions

for j = 1:size(simMatrix,1)
    if j == 1
        fis = addMF(fis,"Output","trapmf",[-0.1 0 outMax outInterval+outMax],'Name',outNames(j));
        outMax = outMax + outInterval;
    elseif  j == length(msArray)
        fis = addMF(fis,"Output","trapmf",[0.85 0.90 1 1.1],'Name',outNames(j));
    else
        fis = addMF(fis,"Output","trimf",[outMax-outInterval outMax outMax+outInterval],'Name',outNames(j));
        outMax = outMax + outInterval;
    end
end

rulesList = zeros(size(msIndexes,1),size(msIndexes,2)+3);

%Make rules
for i = 1:length(outNames)
    [indexFound,~] = find(msIndexes ==i);
    rulesList(i,:) = [indexFound' i 1 1];
end

%Make rules table
for i = 1:size(rulesList,1)
    for j = 1:size(rulesList,2)-3
        rulesTable(i,j) = msNames(rulesList(i,j));
    end
     rulesTable(i,size(rulesList,2)-2) = outNames(rulesList(i,size(rulesList,2)-2));
end

fis = addRule(fis,rulesList);
writeFIS(fis,[filePath fuzzyName]);

end