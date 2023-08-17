function tscout = makefaultclass(obj,simTscollection)
    %Make class for timeseries accordingly to test with 
    %BoostFaultSimulation object
    [FaultTime,Idx] = sort(obj.FaultTime);
    
    if ~isempty(obj.Events)
        eventsArray = obj.Events;
        eventsArray = eventsArray(Idx);
    else
        eventsArray = {'noFault'};
    end
    
    tscin = simTscollection;
    
    startTime = 0;
    startName = 'noFault';
    tsTime = tscin.Time;
    classType = [];

    if ~isempty(FaultTime)
        for i = 1:length(FaultTime) + 1
            if i == length(FaultTime) + 1
                faultinterval = tscin.Time(tscin.Time >= startTime) ;
                classNum = testclass(obj,startName)*ones(length(faultinterval),1);
            else
                faultinterval = tsTime(tsTime >=startTime & tsTime < FaultTime(i));
                classNum = testclass(obj,startName)*ones(length(faultinterval),1);
                startTime = FaultTime(i);
                startName = eventsArray{i};
            end
            
            % faultTime = [faultTime;faultInterval];
            classType = [classType;classNum];
        end
        
        tsClass = timeseries(classType,tsTime,'Name',"Class");
    else
        tsClassNum = testclass(obj,'noFault');
        tsClass = timeseries(tsClassNum*ones(length(tsTime),1),tsTime,'Name',"Class");
    end
    
    tscout = tscin.updatets(tsClass);
end