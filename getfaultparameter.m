function faultparameter = getfaultparameter(obj,item,operation,parameter)
    %parameter = 't' =time or 'f' = factor
    numparam = numel(item);
    if ~iscell(item)
        [~,faultTimeSwitch,faultFactorSwitch] = getdefaultswitches(obj,item,operation);
        fparam = containers.Map({'t','f'},{faultTimeSwitch,faultFactorSwitch},...
            'UniformValues',false);
        faultparameter = obj.(fparam(parameter));
    else
        faultparameter{numparam} = [];
        for i = 1:numparam
            [~,faultTimeSwitch,faultFactorSwitch] = getdefaultswitches(obj,item{i},operation{i});
            fparam = containers.Map({'t','f'},{faultTimeSwitch,faultFactorSwitch},...
                'UniformValues',false);
            faultparameter{i} = obj.(fparam(parameter));
        end
    end
end