clc
clear
%% Longitudinal LME for mental health (trait measures)
% CBCL TotProb PPS severity
load ..\Res_3_IntermediateData\ABCD4.0_IDmatched_AllWave_Demo_Brain_Behav.mat
% remove the 3-year follow-up
% the 3-year follow-up wave in the ABCD 4.0 is incomplete, thus, we will
% remove this measurement wave in the subsequent longitudinal analysis
compact_data(strcmp(compact_data.eventname,'3_year_follow_up_y_arm_1'),:)=[];
% specify the DVs used in LME longitudinal analysis 
Y_Name = {'CBCL_syn_totprob_t','PPS_Severity_Sum'};
% Model settings
ModelSpec.CovsName='baseline_age+sex+Race_PrntRep+Ethnicity_PrntRep+ParentsEdu+ParentMarital+FamilyIncome+HouseholdSize+HouseholdStructure';
ModelSpec.RandomName='(Time|site_id_l)+(Time|site_id_l:src_subject_id)';
ModelSpec.X_name = 'Idx*Time';
% Run LME model in batch
[Res_MH,mdl_MH,T_MH] = s_ParaLongitudinalLME(compact_data,Y_Name);
save ..\Res_2_Results\Res_Longitudinal_MH.mat Res_MH mdl_MH T_MH
% Notes: All CBCL variable names
% {'CBCL_syn_anxdep_t','CBCL_syn_withdep_t','CBCL_syn_somatic_t','CBCL_syn_social_t',...
% 'CBCL_syn_thought_t','CBCL_syn_attention_t','CBCL_syn_rulebreak_t','CBCL_syn_aggressive_t',...
% 'CBCL_syn_internal_t','CBCL_syn_external_t','CBCL_syn_totprob_t','CBCL_dsm5_depress_t',...
% 'CBCL_dsm5_anxdisord_t','CBCL_dsm5_somaticpr_t','CBCL_dsm5_adhd_t','CBCL_dsm5_opposit_t',...
% 'CBCL_dsm5_conduct_t','CBCL_07_sct_t','CBCL_07_ocd_t','CBCL_07_stress_t',...
% 'PLE_BadEvent_Sum','PPS_Number_Sum','PPS_Severity_Sum'}
%% save Longitudinal Data for emmeans Simple Effect Analysis
clearvars -EXCEPT Y_Name 
load ..\Res_2_Results\Res_Longitudinal_MH.mat T_MH
for i=1:length(Y_Name)
   writetable(T_MH{i},['../Res_3_IntermediateData/' Y_Name{i} '.xlsx']); 
end
%% Extract the p-values from the longitudinal LME of behavioral measures
clear
load ..\Res_2_Results\Res_Longitudinal_traits.mat Res_traits
load ..\Res_2_Results\Res_Longitudinal_MH.mat Res_MH
Res_behav = [Res_traits;Res_MH];
clearvars Res_traits Res_MH
disp(Res_behav)
fprintf('Perfroming BH-FDR correction......\n')
IV_VarName = {'Time','Idx_1','Time:Idx_1'};
Res_behav.FDR_pvals = nan(size(Res_behav,1),1);
for i=1:length(IV_VarName)
    Flag = strcmp(Res_behav.Name,IV_VarName{i});
    pvals = Res_behav.pValue(Flag);
    Res_behav.FDR_pvals(Flag) = mafdr(pvals,'BHFDR',true);
end
fprintf('FDR correction finished!\n')
writetable(Res_behav,...
    '..\Res_2_Results\Table_S11.xlsx')
