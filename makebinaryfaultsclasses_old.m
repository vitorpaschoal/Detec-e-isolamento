function [newThTs] = makebinaryfaultsclasses_old(simTsgroup)
    %Makes table for faults classifications,
    %matrixData = zeros(size(thArray{1},1),length(thArray));
    thArray = simTsgroup.tsarray;
    lengthArray = length(thArray);
    newThTs = thArray;
    newThdata = thArray;
    
    for i = 1:lengthArray
        rowThsize = size(thArray{i},1);
        classArray =(i)*ones(rowThsize,1);
        classTs = timeseries(classArray,newThTs{i}.Time,'Name','Classe');
        newThTs{i} = newThTs{i}.addts(classTs);
        %Creates multiples tscollections with different times to concatenate
        %newThdata{i} = setuniformtime(newThTs{i},i*newThTs{i}.Time(1),i*newThTs{i}.Time(end));
    end
    
    % thTables = cellfun(@table,newThTs,'UniformOutput',false);
    % dataTable = vertcat(thTables{:,:});
    % % dataTable2 = tsc2tsc2(vertcat(newThdata{:,:}));
    % % dataTable2.Name = 'trainData';
    
    % matrixData1 = table2array(dataTable(:,2:end)); %Remove Time
    % matrixData = matrixData1(:,1:end-1);
    % matrixClasses = zeros(size(matrixData,1),lengthArray);
    
    % for i = 1:lengthArray
    %     matrixClasses(:,i) = matrixData1(:,end) == (i);
    % end
    
end

% function [matrixData,matrixClasses,dataTable,newThTs] = makebinaryfaultsclasses(simTsgroup)
%     %Makes table for faults classifications,
%     %matrixData = zeros(size(thArray{1},1),length(thArray));
%     thArray = simTsgroup.tsarray;
%     lengthArray = length(thArray);
%     newThTs = thArray;
%     newThdata = thArray;
    
%     for i = 1:lengthArray
%         rowThsize = size(thArray{i},1);
%         classArray =(i)*ones(rowThsize,1);
%         classTs = timeseries(classArray,newThTs{i}.Time,'Name','Classe');
%         newThTs{i} = newThTs{i}.addts(classTs);
%         %Creates multiples tscollections with different times to concatenate
%         newThdata{i} = setuniformtime(newThTs{i},i*newThTs{i}.Time(1),i*newThTs{i}.Time(end));
%     end
    
%     thTables = cellfun(@table,newThTs,'UniformOutput',false);
%     dataTable = vertcat(thTables{:,:});
%     % dataTable2 = tsc2tsc2(vertcat(newThdata{:,:}));
%     % dataTable2.Name = 'trainData';
    
%     matrixData1 = table2array(dataTable(:,2:end)); %Remove Time
%     matrixData = matrixData1(:,1:end-1);
%     matrixClasses = zeros(size(matrixData,1),lengthArray);
    
%     for i = 1:lengthArray
%         matrixClasses(:,i) = matrixData1(:,end) == (i);
%     end
    
% end








