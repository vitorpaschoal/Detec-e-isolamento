function [parameterResult,operationResult] = faultvalidation(obj,parameter,operation)
    %Validades Fault input for BoosFaultSimulation Object
    persistent p
    p = inputParser;
    
    expectedParameters = [obj.Sensors obj.Components];
    sensorFaults = [obj.SensorsCommonFaults obj.SensorsNoiseFault];
    
    faultsmap = containers.Map(expectedParameters,...
        {sensorFaults,sensorFaults,obj.ComponentsOperations,obj.ComponentsOperations},...
        'UniformValues',false);
    
    addRequired(p,'parameter', @(x) any(validatestring(x,expectedParameters)));
    parse(p,parameter);
    parameterResult = p.Results.parameter;
    addRequired(p,'operation',@(x) any(validatestring(x,faultsmap(parameterResult))));
    parse(p,parameter,operation);
    operationResult = p.Results.operation;
end