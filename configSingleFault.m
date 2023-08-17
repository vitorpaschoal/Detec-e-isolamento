function configSingleFault(obj,parameter,operation,varargin)
    %Config just one fault during simulation. If wants two or more,
    %see confgiMultiplefaults
    
    persistent p
    p = inputParser;
    
    [faultSwitch,faultTimeSwitch,faultFactorSwitch,faultCommand] = getdefaultswitches(obj,parameter,operation);
    [parameterResult,operationResult] = faultvalidation(obj,parameter,operation);
    
    defaultFaultFactor = obj.(faultFactorSwitch);
    defaultFaultTime = obj.(faultTimeSwitch);
    addOptional(p,'faultTime',defaultFaultTime,@isnumeric);
    addOptional(p,'factor',defaultFaultFactor,@isnumeric);
    parse(p,varargin{:});
    
    obj.([faultSwitch 'Switch']) = faultCommand;
    obj.(faultTimeSwitch) = p.Results.faultTime;
    obj.(faultFactorSwitch) = p.Results.factor;
    obj.FaultTime  = [obj.FaultTime p.Results.faultTime];
    obj.FaultFactor = [obj.FaultFactor p.Results.factor];
    
    testName = [parameterResult operationResult];
    
    if isempty(obj.TestType)
        obj.TestType = testName;
    else
        obj.TestType = [obj.TestType '_' testName];
    end
    
end