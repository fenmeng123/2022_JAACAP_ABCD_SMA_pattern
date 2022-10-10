clc
clear
diary ../Res_1_Logs/Log_Longitudinal_stat_9.txt
load ../Res_3_IntermediateData/ABCD4.0_Screen_y0y1_transition.mat STQ_Transit
%% Prepare data for transition analysis
load ../Res_3_IntermediateData/ABCD4.0_Recoded_AllWave_Demo_Brain_Behav.mat
data = data(strcmp(data.eventname,'baseline_year_1_arm_1'),:);
% select the baseline variables for multi-nominal logistic regressin
% analysis
Flag = ismember(data.Properties.VariableNames,...
    {'src_subject_id','sex','baseline_age',...
    'Race_PrntRep','Ethnicity_PrntRep','ParentMarital','ParentsEdu','FamilyIncome',...
    'HouseholdSize','HouseholdStructure',...
    'CBCL_syn_internal_t','CBCL_syn_external_t','CBCL_syn_totprob_t',...
    'PPS_Severity_Sum','BIS_Sum','BAS_Sum','UPPS_Sum',...
    'NIHTB_totalcomp_ac','NIHTB_fluidcomp_ac','NIHTB_cryst_ac',...
    'imgincl_rsfmri_include',...
    'rsfmri_cor_ngd_sa_scs_vtdclh',...RSFC: Salience Network - Left Ventral DC
    'rsfmri_c_ngd_vta_ngd_ca',...RSFC: VAN - CPN
    'rsfmri_cor_ngd_df_scs_agrh',...RSFC: DMN - Right Amygdala
    'rsfmri_cor_ngd_vta_scs_cdelh',...RSFC: VAN - Left Caudate
    'site_id_l','FamilyID'});
data = data(:,Flag);
data = outerjoin(STQ_Transit,data,'Keys',{'src_subject_id','sex'},'MergeKeys',true);
% variable recoding
data.TrainsitionLabel_3level = removecats(data.TrainsitionLabel_3level,'NaN');
% clean the data table
Flag = ismissing(data.TrainsitionLabel_3level);
fprintf('# %d subjects have missing values in SMA Pattern Transition Label\n',sum(Flag))
fprintf('This may be caused by mismatched ID, missing values in STQ\n')
fprintf('Remove subjects with missing values in transition label...\n')
fprintf('# N=%d before removing\n',size(data,1))
data(Flag,:) = [];
fprintf('# N=%d After removing\n',size(data,1))
demographics = data(:,ismember(data.Properties.VariableNames,...
{'baseline_age','sex','Race_PrntRep','Ethnicity_PrntRep',...
'ParentMarital','ParentsEdu','FamilyIncome','HouseholdSize','HouseholdStructure'}));
Flag = ismissing(demographics);
fprintf('Missing values statistics in demographics\n')
disp([demographics.Properties.VariableNames;num2cell(sum(Flag,1))])
Flag = sum(Flag,2)~=0;
fprintf('# %d subjects have missing values in demographics\n',sum(Flag))
fprintf('Remove subjects with missing values in demographics...\n')
fprintf('# N=%d before removing\n',size(data,1))
data(Flag,:) = [];
fprintf('# N=%d After removing\n',size(data,1))
measures = data(:,ismember(data.Properties.VariableNames,...
{'CBCL_syn_internal_t';'CBCL_syn_external_t';'CBCL_syn_totprob_t';...
'PPS_Severity_Sum';'BIS_Sum';'NIHTB_fluidcomp_ac';'NIHTB_cryst_ac';...
'NIHTB_totalcomp_ac';'rsfmri_c_ngd_vta_ngd_ca';'rsfmri_cor_ngd_df_scs_agrh';...
'rsfmri_cor_ngd_sa_scs_vtdclh';'rsfmri_cor_ngd_vta_scs_cdelh';...
'imgincl_rsfmri_include';'UPPS_Sum';'BAS_Sum'}));
Flag = ismissing(measures);
fprintf('Missing values statistics in behavioral and brain RS measures\n')
disp([measures.Properties.VariableNames;num2cell(sum(Flag,1))])
Flag = sum(Flag,2)~=0;
fprintf('# %d subjects have missing values in measures\n',sum(Flag))
fprintf('Remove subjects with missing values in measures...\n')
fprintf('# N=%d before removing\n',size(data,1))
data(Flag,:) = [];
fprintf('# N=%d After removing\n',size(data,1))
%% Perform the RS-fMRI recommended inclusion criterion
Flag = ~data.imgincl_rsfmri_include;
fprintf('# %d subjects failed in RS-fMRI QC check (ABCD recommended inclusion)\n',sum(Flag))
fprintf('Remove subjects with missing values in measures...\n')
fprintf('# N=%d before removing\n',size(data,1))
data(Flag,:) = [];
fprintf('# N=%d After removing\n',size(data,1))
%% save data table for SPSS step-wise multinominal analyses
diary off
writetable(data,'../Res_3_IntermediateData/ABCD4.0_SMAtransition.xlsx')