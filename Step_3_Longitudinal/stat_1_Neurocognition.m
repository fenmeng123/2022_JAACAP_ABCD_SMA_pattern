clc
clear
% for Table S11
diary ../Res_1_Logs/Log_Longitudinal_stat_1.txt

%% load and preprocess the ABCD 4.0 longitudinal data
% The ABCD 4.0 longitudinal data have been preprocessed by R, here we will
% transform and recode the R-type data table to incorperate the MATLAB-type
% data table
data = readtable(['..\Res_3_IntermediateData\',...
    'ABCD4.0_Merged_AllWave_Demo_Brain_Behav.csv']);
data = removevars(data,'Var1');
fprintf('Summary: data points within different time waves')
tabulate(data.eventname)
if iscell(data.VGAS_Sum)
   data = removevars(data,{'VGAS_1','VGAS_2','VGAS_3','VGAS_4','VGAS_5','VGAS_6',...
       'SMAS_1','SMAS_2','SMAS_3','SMAS_4','SMAS_5','SMAS_6',...
       'MPIQ_1','MPIQ_2','MPIQ_3','MPIQ_4','MPIQ_5','MPIQ_6','MPIQ_7','MPIQ_8'}); 
   data.VGAS_Sum = str2double(data.VGAS_Sum);
   data.SMAS_Sum = str2double(data.SMAS_Sum);
   data.MPIQ_Sum = str2double(data.MPIQ_Sum);
end
data = s_CheckTableVartype(data);
% replace NA with the MATLAB standardize missing values
fprintf('Handling the NA values from R-code......\n')
fprintf('Replace NA with nan......\n')
miss_idx = ismissing(data,{NaN,777,999,'NA',' ','  ','   ','    '});
data = standardizeMissing(data,{777,999,'NA',' ','  ','   ','    '});
% Attach the k-means-derived cluster index to the data table
fprintf('Attaching the cluster index......\n')
load ..\Res_3_IntermediateData\ABCD4.0_Screen_Cluster_y0.mat
baseline = data(strcmp(data.eventname,'baseline_year_1_arm_1'),:);
STQ = removevars(STQ,'Var1');
baseline = removevars(baseline,{'weekday_TV', 'weekday_Video','weekday_Game','weekday_Text',...
    'weekday_SocialNet','weekday_VideoChat','weekend_TV','weekend_Video',...
    'weekend_Game','weekend_Text','weekend_SocialNet','weekend_VideoChat',...
    'screen13_y','screen14_y'});
fprintf('Key variables:\n')
disp(intersect(baseline.Properties.VariableNames,STQ.Properties.VariableNames))
baseline = outerjoin(STQ,baseline,'MergeKeys',true);
clearvars STQ
fprintf('Attach finished!\n')
% Recoding demographics
[baseline, ~] = Demographics_Recode_StandardMiss(baseline);
% Complete the demographic variables
fprintf('Complete the missing values (empty) in follow-up waves with baseline demographcis......\n')
FUyear1 = data(strcmp(data.eventname,'1_year_follow_up_y_arm_1'),:);
FUyear2 = data(strcmp(data.eventname,'2_year_follow_up_y_arm_1'),:);
FUyear3 = data(strcmp(data.eventname,'3_year_follow_up_y_arm_1'),:);
FUyear1 = Complete_Demographics(baseline,FUyear1);
FUyear2 = Complete_Demographics(baseline,FUyear2);
FUyear3 = Complete_Demographics(baseline,FUyear3);
fprintf('Complete finished!\n')
% save the new data table to the intermediate results
baseline.baseline_age = baseline.interview_age;
data = [baseline;FUyear1;FUyear2;FUyear3];
data = movevars(data,'interview_date','After','src_subject_id');
data = movevars(data,'sex','After','interview_date');
data = movevars(data,'eventname','After','sex');
data = movevars(data,'interview_age','After','eventname');
data = movevars(data,'Idx','After','eventname');
data = movevars(data,'baseline_age','After','interview_age');

save ..\Res_3_IntermediateData\ABCD4.0_Recoded_AllWave_Demo_Brain_Behav.mat data
% clean the MATLAB environment and reload the data table
clear
load ..\Res_3_IntermediateData\ABCD4.0_Recoded_AllWave_Demo_Brain_Behav.mat
% Check the ID mismatched subjects across all time waves
ID_counts = tabulate(data.src_subject_id);
fprintf('Subject ID repeatition times:\n')
tabulate([ID_counts{:,2}])
fprintf('Selected the subject ID with repatition times>=3 (baseline, 1-year, 2-year, 3-year)\n')
ID_selected = {ID_counts{[ID_counts{:,2}]>=3,1}};
compact_data  = data(contains(data.src_subject_id,ID_selected),:);
save ..\Res_3_IntermediateData\ABCD4.0_IDmatched_AllWave_Demo_Brain_Behav.mat compact_data
%% Longitudinal LME for neurocognition (trait measures):UPPS sum/BIS Sum/BAS Sum
clear
load ..\Res_3_IntermediateData\ABCD4.0_IDmatched_AllWave_Demo_Brain_Behav.mat
% specify the DVs used in LME longitudinal analysis 
Y_Name = {'UPPS_Sum','BIS_Sum','BAS_Sum'};
% Model settings
ModelSpec.CovsName='baseline_age+sex+Race_PrntRep+Ethnicity_PrntRep+ParentsEdu+ParentMarital+FamilyIncome+HouseholdSize+HouseholdStructure';
ModelSpec.RandomName='(Time|site_id_l)+(Time|site_id_l:src_subject_id)';
ModelSpec.X_name = 'Idx*Time';
% Run LME model in batch
[Res_traits,mdl_traits,T_traits] = s_ParaLongitudinalLME(compact_data,Y_Name,ModelSpec);
% save model results
save ..\Res_2_Results\Res_Longitudinal_traits.mat Res_traits mdl_traits T_traits
%% save Longitudinal Data for emmeans Simple Effect Analysis
clearvars -EXCEPT Y_Name 
load ..\Res_2_Results\Res_Longitudinal_traits.mat T_traits
for i=1:length(Y_Name)
   writetable(T_traits{i},['../Res_3_IntermediateData/' Y_Name{i} '.xlsx']); 
end
diary off


