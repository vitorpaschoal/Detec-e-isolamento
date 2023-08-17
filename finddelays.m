function times = finddelays(netbfsgroupReconfig,nettscreconfig)
%myFun - Description
%
% Syntax: times = finddelays(Bf)
%
% Long description
%Export results from simulation, to Latex or external folders of neural network delay


iLOpenTest = netbfsgroup.iLOpen_R0_F15;
Vc1OpenTest = netbfsgroup.Vc1Open_R0_F15;
iLGainTest = netbfsgroup.iLGain_R0_F15;
Vc1GainTest = netbfsgroup.Vc1Gain_R0_F15;

% iLOpenTest = simbfsgroup.iLOpen_R0_F1;
% Vc1OpenTest = simbfsgroup.Vc1Open_R0_F1;
% iLGainTest = simbfsgroup.iLGain_R0_F20;
% Vc1GainTest = simbfsgroup.Vc1Gain_R0_F20;

RiLOpenTest = netbfsgroupReconfig.iLOpen_R1_F15;
RVc1OpenTest = netbfsgroupReconfig.Vc1Open_R1_F15;
RiLGainTest = netbfsgroupReconfig.iLGain_R1_F15;
RVc1GainTest = netbfsgroupReconfig.Vc1Gain_R1_F15;

RiLOpenTest = nettscreconfig.iLOpen_R1_F15;
RiLGainTest = nettscreconfig.iLGain_R1_F15;
RVc1OpenTest = nettscreconfig.VcOpen_R1_F15;
RVc1GainTest = nettscreconfig.VcGain_R1_F15;
%%
t2 =  RiLOpenTest.networkOutput.Time(find(RiLOpenTest.networkOutput.Data == 2,1,'first')) 
t3  = RiLGainTest.networkOutput.Time(find(RiLGainTest.networkOutput.Data == 3,1,'first')) 
t4 = RVc1OpenTest.networkOutput.Time(find(RVc1OpenTest.networkOutput.Data == 4,1,'first')) 
t5 = RVc1GainTest.networkOutput.Time(find(RVc1GainTest.networkOutput.Data == 5,1,'first')) 

end