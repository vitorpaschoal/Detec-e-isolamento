%Network tests
data2treat = simTsgroup;
features1 = {'JiL','JVc','Class'};
dataOutNet = keepfeatures(data2treat,features1);
[xfault,tfault,labelsfault] = getnndata(dataOutNet,100);
[faultnet,faulttr] = trainfaultnetwork(xfault,tfault,labelsfault,'OnlyDetection',20,'save','y');
%%
features2 = {'JiL','JVc','JiLR','JVcR','Class'};
dataOutNet2 = keepfeatures(data2treat,features2);
[xfault2,tfault2,labelsfault2] = getnndata(dataOutNet2,100);
[faultnet2,faulttr2] = trainfaultnetwork(xfault2,tfault2,labelsfault2,'WithReconfiguration',20,'save','y');

%%
%faultsCategory = {'\textbf{NOFT}';'\textbf{ILOP}';...
 %   '\textbf{ILHG}';'\textbf{VLOP}';'\textbf{VC$HG}'};
%%

%Performance test for nominal conditions
[testX,testT,testY,cr,cm] = testnetwork(faultnet,faulttr,xfault,tfault);
[testX2,testT2,testY2,cr2,cm2] = testnetwork(faultnet2,faulttr2,xfault2,tfault2);

%ctable = array2table(cmreconfig2,'RowNames',faultsCategory,'VariableNames',faultsCategory);
%table2latex(ctable,[pwd '\confusion.tex'])
% save(['SimulationResults\trainednetwork' 'bigdata' datestr(now,'dd-mm-yyyy-HH-MM') '.mat'],...
%     'reconfignet2','reconfigtr2','xreconfig2','treconfig2','labelsreconfig2','-v7.3');
%save([filePath 'simResultsWS' datestr(now,'dd-mm-yyyy-HH-MM') '.mat']);