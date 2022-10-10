clc
clear
diary ../Res_1_Logs/Log_CrossSectional_stat_6.txt

% for Figure S11
%% Preprocess for RSFNC
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
%% Linear Mixed Effect Modeling
% Model settings
Y_table = data(:,contains(data.Properties.VariableNames,{'rsfmri_c'}));
Covs_table = data(:,contains(data.Properties.VariableNames,...
    {'Idx','site_id_l','FamilyID','ACS_weight',...
    'interview_age','sex','Handedness','Race_PrntRep','Ethnicity_PrntRep',...
    'ParentsEdu','ParentMarital','FamilyIncome','HouseholdSize',...
    'HouseholdStructure'}));
Covs_table.rsfmri_c_ngd_meanmotion = Y_table.rsfmri_c_ngd_meanmotion;
Y_table = removevars(Y_table,'rsfmri_c_ngd_meanmotion');
ModelSpec.X_name = 'Idx';
ModelSpec.CovsName = ['rsfmri_c_ngd_meanmotion+interview_age+sex+Handedness+Race_PrntRep',...
    '+Ethnicity_PrntRep+ParentsEdu+ParentMarital+FamilyIncome',...
    '+HouseholdSize+HouseholdStructure'];
ModelSpec.RandomName='(1|site_id_l)+(1|site_id_l:FamilyID)';
Standardize = true;
AdjustCovs = 'both';
% Run LME model for neurocognition
[stats,aov,fixedEffects]=s_ParaLME(Y_table,Covs_table,ModelSpec,Standardize,AdjustCovs);
load ../Res_3_IntermediateData/ABCD_RSFNC_VarName_NodeName.mat
stats = outerjoin(stats,RSFNC_VarName_Node,'LeftKeys','Y_Name','RightKeys','RSFC_Name','MergeKeys',true);
stats = movevars(stats,'Node2','After','Y_Name_RSFC_Name');
stats = movevars(stats,'Node1','After','Y_Name_RSFC_Name');
head(stats)
% Save model results for neurocognition
Spec.AdjustCovs = 'RSFNC';
Spec.DigitNum = 2;
OutputFile = '..\Res_2_Results\Table_FigS11.xlsx';
s_printable(stats,Spec,OutputFile)
diary off