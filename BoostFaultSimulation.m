classdef BoostFaultSimulation < handle
    %Class to config a fault simulation. The methods and configurations are
    %applied to a whole simulation time, but not for many different
    %simulations
    
    properties
        u = 190;%25 V;
        Ro = 100;%10? ;
        ie = 7.6251;
        ve = 380;

        StopTime = 3.20;%3.20;      %Was one
        AlarmDeadTime = 0.50; %Alarm dead time for when system is turning on
        %Fault threshold
        iLJth = 0.001;
        VcJth = 0.001;
        %set_param(modelName,'StopTime',StopTimeStr);
        TestType = [];
        LoadAddFactor = 0.30; % in '% of Load'
        LoadRemoveFactor = 0.30;
        SourceAddFactor =0.10;
        SourceRemoveFactor = 0.10;
        ReconfigDelay = 0;%0.20
        
%         FaultClassArray = [];
%         FaultClass = 1;
        FaultsTypes = {'noFault','iLOpen','iLGain','VcOpen','VcGain',...
            'Load','Source'};
        FaultsMap = containers.Map({'noFault','iLOpen','iLGain',...
            'VcOpen','VcGain','LoadAdd','LoadRemove','SourceAdd',...
            'SourceRemove'},[1 2 3 4 5 1 1 1 1]);
        %Load and source belongs to class Parameterchange!
        
        TestFaults = []; %{'iL','Open}
        FaultFactor = []; %Fault factor for any fault
        FaultFactorStr = [];
        %FaultClass = 1;
        
        %Turn swithcs on-off - 1 - Means uncertainties or fault
        %Fault Switch: 0 - No fault, 1 - Open Fault, 2 - Gain Fault
        iLFaultSwitch = 0;
        iLGainFaultFactor = 15; %1.1
        iLNoiseFaultSwitch = 0;
        ReconfigTime = 1.707; 
        VcFaultSwitch = 0;
        VcGainFaultFactor = 15;
        VcNoiseFaultSwitch = 0;
        
        %1 - Turns on Step
        LoadAddSwitch =0;
        LoadRemoveSignalSwitch = 1; % 1- Step
        LoadAddSignalSwitch = 1;
        LoadRemoveSwitch =0;
        SourceAddSwitch = 0;
        SourceAddSignalSwitch = 1;
        SourceRemoveSwitch = 0;
        SourceRemoveSignalSwitch = 1;
        ReconfigSwitch = 0;
        RMSfrequency = 47.61; %100
        
        %Times
        %Faults %Just the time, not the type
        observerOnTime = 0;
        iLFaultTime = 1.70; %0.50
        iLNoiseTime = 1.70;
        VcFaultTime = 1.70; % 0.50
        VcNoiseTime = 1.70;
        
        %General Default = 0.70s
        %Uncertainties
        LoadAddTime = 0.90; %0.50
        LoadRemoveTime = 0.90;
        SourceAddTime =0.90; %0.50
        SourceRemoveTime = 0.90;
        %For transient 
        LoadAddDuration = 0.20; %0.50
        LoadRemoveDuration = 0.20;
        SourceAddDuration =0.20; %0.50
        SourceRemoveDuration = 0.20;
        
        ModelName = 'boostObserver'
        FilePath = pwd;
        StartTime = 0;
        SimTimeSeries = [];
        SimResults = [];
        FaultTime = [];
        Sensors = {'iL','Vc'};
        Components = {'Load','Source'};
        SensorsCommonFaults = {'Open','Gain'};
        SensorsNoiseFault = {'Noise'};
        ComponentsOperations = {'Add','Remove'};
        FigPath;
        SimulationPath;
    end
    
    properties (Dependent)
        StopTimeStr;
        LoadAddResistor;
        LoadRemoveResistor;
        SourceAddVoltage ;
        SourceRemoveVoltage;
        ReconfigName;
        Events;
        FaultClass;
    end
    
    methods
        function obj = BoostFaultSimulation(varargin)
            p = inputParser;
            addParameter(p,'ModelName',obj.ModelName,@ischar);
%            addOptional(p,'FilePath',obj.FilePath,@ischar);
            addParameter(p,'StopTime',obj.StopTime,@isnumeric);
            addParameter(p,'ReconfigSwitch',obj.ReconfigSwitch,@isnumeric);
            parse(p,varargin{:});
            obj.ModelName = p.Results.ModelName;
         %   obj.FilePath = p.Results.FilePath;
            obj.StopTime = p.Results.StopTime;
            obj.ReconfigSwitch = p.Results.ReconfigSwitch;
            obj.SimulationPath = [obj.FilePath '\SimulationResults'];
            obj.FigPath = [obj.SimulationPath '\Figures'];
        end
        function Events = get.Events(obj)
            if isempty(obj.TestType)
                Events = [];
            else
                Events = split(obj.TestType,'_',1);
            end  
        end
        
        function FaultClass = get.FaultClass(obj)
            %FaultClass defines step for manual reconfiguration
            if isempty(obj.TestType)
                FaultClass = 1;
            else
                [~,tsClassNums] = testclass(obj,obj.TestType);
                if any(tsClassNums == 2 | tsClassNums ==3)
                    FaultClass = 1; %Or 3
                elseif  any(tsClassNums == 4 | tsClassNums == 5)
                    FaultClass = 2; %Or 4
                elseif tsClassNums == 6
                    FaultClass = 0;
                else
                    FaultClass = 0;
                end
            end
        end
        
        function SourceAddVoltage = get.SourceAddVoltage(obj)
            SourceAddVoltage = obj.SourceAddFactor*obj.u;
        end
        
        function ReconfigName = get.ReconfigName(obj)
            reconfigNames = {'noReconfiguration','Reconfiguration'};
            ReconfigName = reconfigNames(obj.ReconfigSwitch + 1);
        end
        
        function SourceRemoveVoltage = get.SourceRemoveVoltage(obj)
            SourceRemoveVoltage = obj.SourceRemoveFactor*obj.u;
        end
        
        function StopTimeStr = get.StopTimeStr(obj)
            StopTimeStr = num2str(obj.StopTime);
        end
        
        function LoadAddResistor = get.LoadAddResistor(obj)
            LoadAddResistor = obj.LoadAddFactor*obj.Ro;
        end
        function   LoadRemoveResistor = get.LoadRemoveResistor(obj)
            LoadRemoveResistor = obj.Ro*(1-obj.LoadRemoveFactor)/(obj.LoadRemoveFactor);
        end
        
        function reset(obj)
            mc = ?BoostFaultSimulation;            
            %Tests defaultValue
            [defaultNames,defaultValues] = getDefaultProperties(mc);
            
           cellfun(@(propName,value) obj.set(propName,value),...
                defaultNames,defaultValues,...
                'UniformOutput',false);
        end
        
        function set(obj,propName,value)
            obj.(propName) = value;
        end
        
        function assign(obj)
            %Assign in workspace all the class properties
            mc = ?BoostFaultSimulation;
            [~,propArrayNames] = getProperties(mc);
            cellfun(@(propName) assignin('base',propName,obj.(propName)),...
                propArrayNames,...
                'UniformOutput',false);
        end
        
        function setJth(obj)
            %Sets Threshold value
            iLJth = obj.SimTimeSeries.JiL.getsampleusingtime(obj.AlarmDeadTime,obj.StopTime).max;
            obj.iLJth = iLJth + 0.001*iLJth;
            assignin('base','iLJth',obj.iLJth);
            VcJth = obj.SimTimeSeries.JVc.getsampleusingtime(obj.AlarmDeadTime,obj.StopTime).max;
            obj.VcJth = VcJth + 0.001*VcJth;
            assignin('base','VcJth',obj.VcJth);
        end
        
        function [simTsCollection,simResults] = nofaulttest(obj,varargin)
            %Clear all possible faults and simulate. Sets Reconfiguration
            %During the execution time, there will be no fault or change in
            %the parameters
            obj.reset;
            obj.ReconfigSwitch = reconfigurationparser(varargin{:});
            obj.TestType = 'noFault';
            obj.assign;
            [simTsCollection,simResults] = obj.run();
           % obj.setJth();
        end
        
        function open(obj)
            run(obj.ModelName)
        end
        
        function write(obj)
            %Generates csvs files and data tables in respect to each
            %experiment (no fault, iL open fault, etc)
            simFolderCsvFaults = makefolder(obj.FilePath,obj.SimulationPath);
            tsTable = obj.SimTimeSeries.table();
            simName = obj.TestType;
            writetable(tsTable,fullfile(simFolderCsvFaults,'Original',[simName,'.csv']),...
                'Delimiter',',')
        end
        
        function [fighandle,plothandle,axeshandle] = plotreconfig(obj,param,varargin)
            %Param corresponds to a timeseries parametetr
            savefile = savesimfigparser(varargin{:});
            
            [fighandle,plothandle,axeshandle] = plotts(obj.SimTimeSeries,param);
            if obj.ReconfigSwitch == 1 
                rname = 'Reconfiguration';
                rcolor = 'b';
                rline = '-';
            else
                rname = 'No reconfiguration';
                rcolor = 'r';
                rline = '--';
            end
            lr = legend(axeshandle,rname);
            set(lr,'visible','on');
            set(plothandle,'Color',rcolor,'LineStyle',rline);
            
            %Verifies if user wants to save file
            fname = obj.SimTimeSeries.Name;
            figfolder = obj.FigPath;
            figname = [fighandle.Name '_' fname];
            fighandle.Name = figname;
            if strcmp(savefile,'y')
                savesimfigs(fighandle,'figname',figname,'figfolder',figfolder);
            end
         
        end

        function [fighandle,plothandle,axeshandle] = plot(obj,param,legendname,figcolor,figline,lineWidth,varargin)
            %Param corresponds to a timeseries parametetr
            savefile = savesimfigparser(varargin{:});
            
            [fighandle,plothandle,axeshandle] = plotts(obj.SimTimeSeries,param);
          
            rname = legendname;
            rcolor = figcolor;
            rline = figline;
            rlwidth = lineWidth;
            lr = legend(axeshandle,rname);
            set(lr,'visible','on','Interpreter','latex',...
            'FontSize',14,...
            'FontName','Latin Modern Roman',...
            'Location','best',...,
            'Color','none');
            set(plothandle,'Color',rcolor,'LineStyle',rline,'LineWidth',rlwidth);
            
            %Verifies if user wants to save file
            fname = obj.SimTimeSeries.Name;
            figfolder = obj.FigPath;
            figname = [fighandle.Name '_' fname];
            fighandle.Name = figname;
            if strcmp(savefile,'y')
                savesimfigs(fighandle,'figname',figname,'figfolder',figfolder);
            end
         
        end
        
        function setevents(obj)
            obj.SimTimeSeries = maketscevents(obj);
        end
        
        function settscname(obj)
            %Set the name of SimTimeSeries
            %Change name of collection
            factorstr = strjoin(arrayfun(@num2str,obj.FaultFactor,'UniformOutput',false),'_F');
            
            newfactorstr =  replace(factorstr,".","_");
            if isempty(obj.TestType)
                tscname = 'No Test'; 
            else
                tscname = obj.TestType;
            end
            obj.SimTimeSeries.Name = [tscname '_R' num2str(obj.ReconfigSwitch) '_F' newfactorstr];
        end
% % 

        function [simTsCollection,simResults] = run(obj)
            %simulationTime
            %Simulates Boost Converter and returns desired parameters
            %Maybe include fault time event in tscollection
            obj.assign();
            set_param(obj.ModelName,'StopTime',obj.StopTimeStr);
            simResults = sim(obj.ModelName,'SimulationMode',...,
                            'accelerator','SaveState','on','SaveOutput','on');
            simTsCollection = sim2tscollection(simResults);
            
            obj.SimResults = simResults;
            obj.SimTimeSeries = simTsCollection;
            obj.setclass();
          %  obj.setevents();
            obj.settscname();
            obj.setequilibrium();
            obj.setthresholds();
            simTsCollection = obj.SimTimeSeries;
            obj.assign();        
        end
        function setthresholds(obj)
            tout = obj.SimTimeSeries.time;
            lendata = length(tout);
            iLJthTs = timeseries(repmat(obj.iLJth,[lendata 1]),tout,'Name', 'iLJth');
            VcJthTs = timeseries(repmat(obj.VcJth,[lendata 1]),tout,'Name', 'VcJth');
            obj.SimTimeSeries = addts(obj.SimTimeSeries, {iLJthTs, VcJthTs});
        end
        function setequilibrium(obj)
        %myFun - Set equilibrium point time series;
        %
        % Syntax: setequilibrium(input)
        %
        % Long description
            tout = obj.SimTimeSeries.time;
            lendata = length(tout);
            ieTs = timeseries(repmat(obj.ie,[lendata 1]),tout,'Name', 'ie');
            veTs = timeseries(repmat(obj.ve,[lendata 1]),tout, 'Name','ve');
            obj.SimTimeSeries = addts(obj.SimTimeSeries, {ieTs, veTs});
        end
        function setclass(obj)
            %Return class due the kind of fault
            obj.SimTimeSeries = makefaultclass(obj,obj.SimTimeSeries);
        end
        
        function configfault(obj,parameter,operation,varargin)
            if (iscell(parameter))
                configmultiplefaults(obj,parameter,operation,varargin{:})
            else
                configSingleFault(obj,parameter,operation,varargin{:});
            end
        end        
    end
end
