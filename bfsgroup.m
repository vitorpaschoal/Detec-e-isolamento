classdef bfsgroup < dynamicprops
    %%Boost Fault Simulation Group
    %Class of multiple fault simualtion objects
    properties
        Bfsarray;
        Timeseriesnames;
        FaultsMap;
        FaultsTypes;
    end
    methods
        function obj = bfsgroup(bfsarray)
            obj.Bfsarray = bfsarray;
            
            propArray = cellfun(@(bfs) addprop(obj,bfs.SimTimeSeries.Name),bfsarray,'UniformOutput',false);
            propNames = cellfun(@(prop) prop.Name,propArray,'UniformOutput',false);
            
            obj.Timeseriesnames = bfsarray{1}.SimTimeSeries.gettimeseriesnames;
            obj.FaultsMap = bfsarray{1}.FaultsMap;
            obj.FaultsTypes = bfsarray{1}.FaultsTypes;  
            try
                cellfun(@(name,bfs) obj.setname(name,bfs),propNames,bfsarray,'UniformOutput',false);
            catch
                propNames = strseq('Var',1:numel(propArray));
                cellfun(@(name,bfs) obj.setname(name,bfs),propNames,bfsarray,'UniformOutput',false);
            end
            %[propArray,propArrayNames] = getProperties(mc);
            %obj.propArray = propArray;
            %obj.propNames = propNames;
        end
        
        function tscoutArray = gettscollections(obj)
            %Returns array of time series collections of all boost fault
            %simulation; 
            tscoutArray = cellfun(@(bfs) bfs.SimTimeSeries,obj.Bfsarray,'UniformOutput',false);
        end
        
        function tscgroupOut = gettscgroup(obj)
            %Returns tscgroup with all tscollections 
            tscgroupOut = tscgroup(obj.gettscollections());
        end
        
        function setname(obj,propname,value)
            obj.(propname) = value;
        end
        
        function setFaultsMap(obj,newFaultsMap)
            %Change FaultsMap in each object
            obj.FaultsMap = newFaultsMap;
            cellfun(@(bfs) set(bfs,'FaultsMap',newFaultsMap),obj.Bfsarray,'UniformOutput',false);
            obj.setclassesnames();
        end
        
        function setclassesnames(obj)
            %Change name of classes in each object
             cellfun(@(bfs) bfs.setclass,obj.Bfsarray,'UniformOutput',false);
        end
        
        
         function setsim2tscollection(obj)
            %Change name of classes in each object
            cellfun(@(bfs) bfs.set('SimTimeSeries',sim2tscollection(bfs.SimResults)),obj.Bfsarray,'UniformOutput',false);
            cellfun(@(bfs) bfs.settscname,obj.Bfsarray,'UniformOutput',false);
            obj.setclassesnames;
        end
        
    end
end