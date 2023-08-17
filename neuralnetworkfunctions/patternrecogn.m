function [net,tr] = patternrecogn(x,t)
%Função que configura e retorna a rede treinada
% Solve a Pattern Recognition Problem with a Neural Network
% Script generated by Neural Pattern Recognition app
% Created 13-May-2021 20:36:05
%
% This script assumes these variables are defined:
%
%   matrixData - input data.
%   matrixClasses - target data.
% 
% x = matrixData';
% t = matrixClasses';

% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.

trainFcn = 'trainscg';  % Scaled conjugate gradient backpropagation.

% Create a Pattern Recognition Network
hiddenLayerSize = 4; %6
net = patternnet(hiddenLayerSize, trainFcn);
%net=feedforwardnet([10 11 12]);
% Choose Input and Output Pre/Post-Processing Functions
% For a list of all processing functions type: help nnprocess
net.input.processFcns = {'removeconstantrows','mapminmax'};

% Setup Division of Data for Training, Validation, Testing
% For a list of all data division functions type: help nndivision
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

% Choose a Performance Function
% For a list of all performance functions type: help nnperformance
net.performFcn = 'crossentropy';  % Cross-Entropy

% net.performFcn = 'mse';  % Erro médio quadrático
% net.trainParam.lr = 0.1;
%net.trainParam.min_grad = 10^-3;
%net.layers{1}.transferFcn = 'elliotsig';
% net.layers{2}.transferFcn = 'tamh';

% Choose Plot Functions
% For a list of all plot functions type: help nnplot
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
    'plotconfusion', 'plotroc'};

% Train the Network
[net,tr] = train(net,x,t);

end

% Sigmoid Symmetric Transfer Function
function a = tansig_apply(n,~)
    a = 2 ./ (1 + exp(-2*n)) - 1;
  end
  
