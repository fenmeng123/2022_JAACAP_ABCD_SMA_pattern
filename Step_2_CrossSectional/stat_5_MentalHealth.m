clc
clear
% for Table S9
load ..\Res_3_IntermediateData\ABCD4.0_Recoded_Baseline_Demo_Behav.mat
%% Linear Mixed Effect Modeling
% Model settings
Y_table = Demograph(:,contains(Demograph.Properties.VariableNames,{'CBCL_','PPS_Number','PPS_Severity'}));
Covs_table = Demograph(:,contains(Demograph.Properties.VariableNames,...
    {'Idx','site_id_l','FamilyID','ACS_weight',...
    'interview_age','sex','Race_PrntRep','Ethnicity_PrntRep',...
    'ParentsEdu','ParentMarital','FamilyIncome','HouseholdSize',...
    'HouseholdStructure'}));
ModelSpec.X_name = 'Idx';
ModelSpec.CovsName='interview_age+sex+Race_PrntRep+Ethnicity_PrntRep+ParentsEdu+ParentMarital+FamilyIncome+HouseholdSize+HouseholdStructure';
ModelSpec.RandomName='(1|site_id_l)+(1|site_id_l:FamilyID)';
Standardize = true;
AdjustCovs = 'both';
% Run LME model for neurocognition
[stats,aov,fixedEffects]=s_ParaLME(Y_table,Covs_table,ModelSpec,Standardize,AdjustCovs);
% Save model results for neurocognition
Spec.AdjustCovs = AdjustCovs;
Spec.DigitNum = 2;
OutputFile = '..\Res_2_Results\Table_S9.xlsx';
s_printable(stats,Spec,OutputFile)