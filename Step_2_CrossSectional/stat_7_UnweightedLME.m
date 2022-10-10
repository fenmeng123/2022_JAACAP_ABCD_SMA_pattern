clc
clear
% for Table S8
load ..\Res_3_IntermediateData\ABCD4.0_Recoded_Baseline_Demo_Behav.mat
%% unweighted Linear Mixed Effect Modeling for neurocognition
% Model settings
Y_table = Demograph(:,contains(Demograph.Properties.VariableNames,{'NIHTB_','UPPS_','BAS_','BIS_'}));
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
[stats_neurocog,~,~]=s_ParaLME_unweighted(Y_table,Covs_table,ModelSpec,Standardize,AdjustCovs);
% Save model results for neurocognition
% Spec.AdjustCovs = AdjustCovs;
% Spec.DigitNum = 2;
% OutputFile = 'I:\ABCDStudyNDA\ABCD_DataAnalysis\Code_ScreenAnalysis2021\Pipeline\JAACAP_Revision220920\Res_2_Results\Table_S8.xlsx';
% s_printable(stats_neurocog,Spec,OutputFile)
%% unweighted LME models for mental health
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
[stats_mental,~,~]=s_ParaLME_unweighted(Y_table,Covs_table,ModelSpec,Standardize,AdjustCovs);
% Save model results for neurocognition
Spec.AdjustCovs = AdjustCovs;
Spec.DigitNum = 2;
stats = vertcat(stats_neurocog,stats_mental);
OutputFile = '..\Res_2_Results\Table_UnweightedLME_behav.xlsx';
s_printable(stats,Spec,OutputFile)
%% unweighted LME for RSFNC
clc
clear
% Preprocess for RSFNC
% ABCD Recomended Image Inclusion Criterion
data = readtable(...
    ['..\Res_3_IntermediateData\',...
    'ABCD4.0_Merged_Baseline_Demo_Brain_Behav.csv']);
data = removevars(data,'Var1');
load ..\Res_3_IntermediateData\ABCD4.0_Screen_Cluster_y0.mat
data = removevars(data,{'weekday_TV', 'weekday_Video','weekday_Game','weekday_Text',...
    'weekday_SocialNet','weekday_VideoChat','weekend_TV','weekend_Video',...
    'weekend_Game','weekend_Text','weekend_SocialNet','weekend_VideoChat',...
    'screen13_y','screen14_y'});
fprintf('Key variables:\n')
disp(intersect(data.Properties.VariableNames,STQ.Properties.VariableNames))
data = outerjoin(STQ,data,'MergeKeys',true);
clearvars STQ
% recode demogrpahic variables
[data, MissFlag] = Demographics_Recode(data);
data = s_zscoreDemo(data);
% Apply the ABCD Recomended Inclusion Criterion
data.imgincl_rsfmri_include(isnan(data.imgincl_rsfmri_include)) = 0;
fprintf('%d subjects passed the rsfmri RecomendImgIncl\n',sum(data.imgincl_rsfmri_include))
% Clean the data table
MissFlag = removevars(MissFlag,{'PrntEmp_MissFlag','BirthCoun_MissFlag'});
DemoMiss_ImgFail_Flag = ( sum(MissFlag.Variables,2)~=0 ) | (data.imgincl_rsfmri_include==0);
fprintf('%d subjects left after demographics cleaning and image inclusion check\n',sum(~DemoMiss_ImgFail_Flag))
data(DemoMiss_ImgFail_Flag,:)=[];
% Linear Mixed Effect Modeling
% Model settings
Y_table = data(:,contains(data.Properties.VariableNames,{'rsfmri_c'}));
Covs_table = data(:,contains(data.Properties.VariableNames,...
    {'Idx','site_id_l','FamilyID','ACS_weight',...
    'interview_age','sex','Race_PrntRep','Ethnicity_PrntRep',...
    'ParentsEdu','ParentMarital','FamilyIncome','HouseholdSize',...
    'HouseholdStructure'}));
Covs_table.rsfmri_c_ngd_meanmotion = Y_table.rsfmri_c_ngd_meanmotion;
Y_table = removevars(Y_table,'rsfmri_c_ngd_meanmotion');
ModelSpec.X_name = 'Idx';
ModelSpec.CovsName = ['rsfmri_c_ngd_meanmotion+interview_age+sex+Race_PrntRep',...
    '+Ethnicity_PrntRep+ParentsEdu+ParentMarital+FamilyIncome',...
    '+HouseholdSize+HouseholdStructure'];
ModelSpec.RandomName='(1|site_id_l)+(1|site_id_l:FamilyID)';
Standardize = true;
AdjustCovs = 'both';
% Run LME model for neurocognition
[stats,~,~]=s_ParaLME_unweighted(Y_table,Covs_table,ModelSpec,Standardize,AdjustCovs);
load ../Res_3_IntermediateData/ABCD_RSFNC_VarName_NodeName.mat
stats = outerjoin(stats,RSFNC_VarName_Node,'LeftKeys','Y_Name','RightKeys','RSFC_Name','MergeKeys',true);
stats = movevars(stats,'Node2','After','Y_Name_RSFC_Name');
stats = movevars(stats,'Node1','After','Y_Name_RSFC_Name');
head(stats)
% Save model results for neurocognition
Spec.AdjustCovs = 'RSFNC';
Spec.DigitNum = 2;
OutputFile = '..\Res_2_Results\Table_UnweightedLME_RSFNC.xlsx';
s_printable(stats,Spec,OutputFile)