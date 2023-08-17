%Boost paramters
clear;clc;
%filePath = 'C:\Users\d13go\Desktop\Controle Não Linear\Projeto Controle Chaveado\Swtiched Boost\Switched-Control-Figures\';
%filePath2 = 'C:\Users\d13go\Desktop\Controle Não Linear\Projeto Controle Chaveado\Swtiched Boost\';
L = 1e-3; %1mH
C = 1e-3;%1 mF
u = 25;%25 V;
Ro = 10;%10? ;
R = 0.1;%0.1?.
ve = 100;

%Data from article
% L = 500e-6; %1mH
% C = 470e-6;%1 mF
% u = 100;%25 V;
% Ro = 50;%10? ;
% R = 2;%0.1?.
% ve = 250;

digits(4); %Latex digits
boost = BoostController(Ro,R,L,C,u);
symBoost = BoostController(); %Symbolical Boost

%Verify stability
[stable,Plyap,rA1,rA2] = boost.isStable();
PstLatex = newtexcommand('Plyap',matrix2latex(Plyap,'d'));
rA1Latex = newtexcommand('rAone',matrix2latex(rA1,'d'));
rA2Latex = newtexcommand('rAtwo',matrix2latex(rA2,'d'));

%Get all X_e attainable
X_e = symBoost.X_e();
X_e_Latex = newtexcommand('Xe',matrix2latex(X_e));
I_e = symBoost.I_e();
I_e_Latex = newtexcommand('Ie',matrix2latex(I_e));

P = boost.calculateP();

%Matrix de controle
zeta = boost.control_matrix(P);
zetaLatex = newtexcommand('zetaMatrix',matrix2latex(zeta,'d'));
zeta_e = boost.controllaw(P,ve);
zeta_eLatex = newtexcommand('zetaeMatrix',matrix2latex(zeta_e,'d'));

%Send to simulink
boost_parameters = boost.parameters();
boost_Amatrices = boost.A_matrices();
boost_Bmatrices = boost.B_matrices();

%%
A1Latex = newtexcommand('Aoneboost',matrix2latex(boost.A1,'d'));
A2Latex = newtexcommand('Atwoboost',matrix2latex(boost.A2,'d'));
B1Latex = newtexcommand('Boneboost',matrix2latex(boost.B1,'d'));


%%
%Run Simulink in this part
save([filePath2 'boostWorkspace']);
%plot results of V_c

% close all;
% plotResults(VoutputFix,'V_c (V)');
% plotResults(Voutput,'V_c (V)');
% plotResults(VoutputDisturb,'V_c (V)');
% plotResults(VoutputAdapt,'V_c (V)');
% 
% %Plot results of iL
% plotResults(iLoutputFix,'i_L (A)','r');
% plotResults(iLoutput,'i_L (A)','r');
% plotResults(iLoutputDisturb,'i_L (A)','r');
% plotResults(iLoutputAdapt,'i_L (A)','r');
% 
% 
% %Plot compation to slidingmode
% %%
% close all;
% load('corrente');
% load('tensao');
% load('boostWorkspace');
% %Voltage
% plotResults(VoutputAdapt,'V_c (V)');
% hold on;
% plotSimpleResults(vot,'V_c (V)','r');
% legend(gca,'Chaveado','Referência','Sliding-Mode','Location','southeast');
% matlab2tikz([filePath 'comparacaoTensao.tex'],'width','6cm');
% %Current
% plotResults(iLoutputAdapt,'i_L (A)','b');
% hold on;
% plotSimpleResults(ilt,'i_L','r');
% legend(gca,'Chaveado','Referência','Sliding-Mode','Location','northeast');
% matlab2tikz([filePath 'comparacaoCorrente.tex'],'width','6cm');

%Comparte phase plane

