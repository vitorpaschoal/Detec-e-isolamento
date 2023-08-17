function [faultSwitch,faultTimeSwitch,faultFactorSwitch,faultCommand] = getdefaultswitches(obj,item,operation)
            %Gets fault time accordingly to parameter and operation
            [parameterResult,operationResult] = faultvalidation(obj,item,operation);
            faultSwitch = [parameterResult operationResult];
            
            sensorFaultsNumbers = containers.Map({'Open','Gain'},[1,2]);
            
            if ismember(parameterResult,obj.Sensors)
                faultFactorSwitch = [parameterResult 'GainFaultFactor'];
                
                if ~strcmp(operationResult,'Noise')
                    faultSwitch = [parameterResult 'Fault'];
                    faultCommand =  sensorFaultsNumbers(operationResult);
                end
                
            else
                faultFactorSwitch = [faultSwitch 'Factor'];
                faultCommand = 1;
            end
            
            faultTimeSwitch = [faultSwitch 'Time'];
        end