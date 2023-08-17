function [c1,scores] = testCsvm(data3,theclass,C,kernelScale,kernelFunction)
    
    c1 = fitcsvm(data3(:,1:2),theclass,'KernelFunction',kernelFunction,...
        'Standardize',true,'BoxConstraint',C,'ClassNames',[-1,1],'KernelScale',kernelScale);
    d = 0.02;
    [x1Grid,x2Grid] = meshgrid(min(data3(:,1)):d:max(data3(:,1)),...
        min(data3(:,2)):d:max(data3(:,2)));
    xGrid = [x1Grid(:),x2Grid(:)];
    [~,scores] = predict(c1,xGrid);
    
    % Plot the data and the decision boundary
    figure;
    h(1:2) = gscatter(data3(:,1),data3(:,2),theclass,'rb','xo');
    hold on
    h(3) = plot(data3(c1.IsSupportVector,1),data3(c1.IsSupportVector,2),'ko');
    contour(x1Grid,x2Grid,reshape(scores(:,2),size(x1Grid)),[0 0],'k');
    legend(h,{'Classe -1','Classe +1','Vetores de Suporte'});
    
    gamma = kernelScale^(-2);
    if strcmp(kernelFunction,'rbf')
        
        title(['\gamma = ' num2str(gamma)]);
        saveas(gcf,['Figuras\fitcurvegamma' num2str(gamma) '.png']);
    else
        title(['C = ' num2str(C)]);
        saveas(gcf,['Figuras\fitcurveC' num2str(C) '.png']);
    end
    
    
    hold off
    
end

% %%
% %Multiple SVMs
% X = x';
% Y = table2cell(newdataTable(:,end));
% Y =cellfun(@num2str,Y,'UniformOutput',false);
% mdl = fitcecoc(X,Y);
% CVMdl = crossval(mdl);
% genError = kfoldLoss(CVMdl);
% %saveLearnerForCoder(mdl,'svmForboost');
% % SimMdlName = 'slexSVMIonospherePredictExample'; 
% % open_system(SimMdlName)
% %%