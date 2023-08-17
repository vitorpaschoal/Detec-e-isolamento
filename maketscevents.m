function tscout = maketscevents(obj)
    %Add events to tscollecion
    tscin = obj.SimTimeSeries;

    eventsnames = [{'SimulationStarts'},obj.Events',{'SimulationEnds'}];
    if isempty(obj.FaultTime)
        FaultTime = 0;
    else
         FaultTime = obj.FaultTime ;
    end
    eventstimes = [obj.StartTime FaultTime obj.StopTime];
    
    for i = 1:numel(eventsnames)
      tscin = addevent(tscin,eventsnames{i},eventstimes(i));
    end
    
    tscout = tscin;    
    
end