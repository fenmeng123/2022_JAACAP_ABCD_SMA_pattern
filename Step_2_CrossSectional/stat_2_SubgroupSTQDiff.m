clc
clear
% for Table S5
load ..\Res_3_IntermediateData\ABCD4.0_Recoded_Baseline_Demo_Behav.mat

%% Parallel Linear-Mixed Effect Modeling
% Model settings
Y_table = Demograph(:,contains(Demograph.Properties.VariableNames,{'weekday','weekend','screen'}));
Covs_table = Demograph(:,contains(Demograph.Properties.VariableNames,{'Idx','site_id_l','FamilyID','ACS_weight'}));
ModelSpec.X_name = 'Idx';
ModelSpec.CovsName='';
ModelSpec.RandomName='(1|site_id_l)+(1|site_id_l:FamilyID)';
Standardize = true;
AdjustCovs = 'adjusted';
% Run model
[stats,aov,fixedEffects]=s_ParaLME(Y_table,Covs_table,ModelSpec,Standardize,AdjustCovs);
% Save model results
Spec.AdjustCovs = AdjustCovs;
Spec.DigitNum = 2;
OutputFile = '..\Res_2_Results\Table_S5.xlsx';
s_printable(stats,Spec,OutputFile)




