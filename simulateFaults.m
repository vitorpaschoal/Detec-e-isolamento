function [simTimeSeries,simObjs] = simulateFaults(paramArray,operationArray,varargin)
    %Makes many instances of BoosfFaultSimulation and then config faults 
    %Each cell corresponds to a multiple fault configuration
    
    simObjs =  cellfun(@(param) BoostFaultSimulation,paramArray,'UniformOutput',false);
   
    
    [faultTimeArray,faultFactorArray,reconfigSwitch,StopTime] = faultsparamparser(simObjs,paramArray,operationArray,varargin{:});
    %
    % %Config faults
    cellfun(@(simObj,param,operation,time,factor)  simObj.configfault(param,operation,time,factor),...
        simObjs,paramArray,operationArray,faultTimeArray,faultFactorArray,...
        'UniformOutput',false);
    
    %Config Reconfiguration
    cellfun(@(simObj)  set(simObj,"ReconfigSwitch",reconfigSwitch),...
        simObjs,'UniformOutput',false);
    %Set StopTime
    cellfun(@(simObj)  set(simObj,"StopTime",StopTime),...
        simObjs,'UniformOutput',false);
        %
    %Run
    simTimeSeries = cellfun(@(simObj)  (simObj.run()),...
        simObjs,'UniformOutput',false);    

end


