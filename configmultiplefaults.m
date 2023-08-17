        function configmultiplefaults(obj,parameters,operations,varargin)
            %Receive an array of faults during same simulation
            p = inputParser;
            defaultFaultTimeArray{numel(parameters)} = [];
            defaultFaultFactorArray{numel(parameters)} = [];
            
            for i = 1:numel(parameters)
                [~,faultTimeSwitch,faultFactorSwitch,~] = getdefaultswitches(obj,parameters{i},operations{i});
                defaultFaultFactorArray{i} = obj.(faultFactorSwitch);
                defaultFaultTimeArray{i} = obj.(faultTimeSwitch);
            end
            
            addOptional(p,'faultTime',defaultFaultTimeArray,@iscell);
            addOptional(p,'factor',defaultFaultFactorArray,@iscell);
            parse(p,varargin{:});
            
            faultTimeArray = p.Results.faultTime;
            faultFactorArray = p.Results.factor;
            
            cellfun(@(parameter,operation,faultTime,faultFactor) configfault(obj,parameter,operation,faultTime,faultFactor),...
                parameters,operations,faultTimeArray,faultFactorArray,'UniformOutput',false);
            
        end