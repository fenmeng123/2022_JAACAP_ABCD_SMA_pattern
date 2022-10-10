function [X_regressed,CovsAll]=CovsRegressOut(X,Demo,CovsName)
% Regress out nuisance covariates of X
% Based on the code from Jianfeng Feng et al.
% Written by Kunru Song 2021.11.13

if nargin == 2
    % default nuisance covariates in ABCD V3.0
    CovsName={'gender','eductionR','race','prntedu','prntemploy','famsizeR','anohouse','site','famincomeR'};
end
% recoding categorical variables
% CovsAll=zeros(size(Demo,1),1);
for i=1:length(CovsName)
    Flag=strcmp(Demo.Properties.VariableNames,CovsName{i});
    tmpNewCovs=Demo{:,Flag};
    if ~contains(CovsName{i},'R') && ~contains(CovsName{i},'age')
        tmpNewCovs=CategoryRecode(tmpNewCovs,'type','DummyCode','reference','default','method','MATLAB');
    end
    
    if i==1
        CovsAll=tmpNewCovs;
    else
        CovsAll=[CovsAll tmpNewCovs];
    end
end

b = regress(X,[CovsAll ones(size(CovsAll,1),1)]);
X_regressed = X - (b(1:end-1)'*CovsAll')';

