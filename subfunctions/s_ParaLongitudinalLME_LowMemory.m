function [Res,mdl] = s_ParaLongitudinalLME_LowMemory(compact_data,Y_Name,ModelSpec)
% batch function for the parallel LME for the longitudinal analysis
% only for the ABCD 4.0 data table
% Input:
% compact_data - a data table from Kunru Song's preprocessing pipeline
% Y_Name - a n-by-1 cell string, contains the DV variable names
% ModelSpect - a struct contains the LME Formula
% for example
% ModelSpec.CovsName='age+gender+race+Handness+prntemploy+prntedu+famsizeR+anohouse+famincomeR';
% ModelSpec.RandomName='(1|site)+(1|site:familyID)';
% ModelSpec.X_name = 'SMAclusterIndex';
fprintf('==================Start Longitudinal LME=======================\n')
Num_DV = length(Y_Name);
fprintf('# %d DVs are needed to be entered into LME model\n',Num_DV)
Res = cell(Num_DV,1);
mdl = cell(Num_DV,1);
% T_DV = cell(Num_DV,1);
LME_CovsName = ConcatFormula(ModelSpec);
LME_Formula=strcat('Y~',ModelSpec.X_name,'+',LME_CovsName);
fprintf('LME formula:%s\n',LME_Formula)
fprintf('Notes: Y is the DV_VarName\n')
parfor i=1:Num_DV
T = s_preparLongitudinalData(compact_data,Y_Name{i});
T.RSfMRI_MeanFD = T.rsfmri_c_ngd_meanmotion;% for RSFNC longitudinal analysis
T = T(:,~contains(T.Properties.VariableNames,{'NIHTB','CBCL','PPS',...
    'rsfmri','screen','weekday','weekend','BIS','BAS','PLE',...
    'VGAS','SMAS','MPIQ'}));
fprintf('Fitting LME model for DV:%s......\n',Y_Name{i})
mdl{i} = fitlme(T,...
    LME_Formula,...
    'FitMethod','REML','DummyVarCoding','effects','CovariancePattern',{'Diagonal','Diagonal'});
fprintf('# %d number of data points (%d for subjects) for DV:%s\n',mdl{i}.NumObservations,mdl{i}.NumObservations/length(unique(T.Time)),Y_Name{i})
% disp(mdl{i})
fprintf('# DV:%s LME fitting finished!\n',Y_Name{i})
Flag = contains(mdl{i}.Coefficients.Name,{'Idx','Time'});
Res{i} = dataset2table(mdl{i}.Coefficients(Flag,:));
Res{i}.Y_Name = repmat(Y_Name(i),sum(Flag),1);
Res{i}.Included_N = repmat(mdl{i}.NumObservations/length(unique(T.Time)),sum(Flag),1);
% T_DV{i} = T;
end
Res = vertcat(Res{:});
fprintf('==================End Longitudinal LME=======================\n')
end

function LMM_CovsName = ConcatFormula(ModelSpec)
if isempty(ModelSpec.CovsName)
    LMM_CovsName=ModelSpec.RandomName;
else
    LMM_CovsName=strcat(ModelSpec.CovsName,'+',ModelSpec.RandomName);
end
end