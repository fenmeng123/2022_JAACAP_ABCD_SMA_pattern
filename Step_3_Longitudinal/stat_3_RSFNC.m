clc
clear
diary ../Res_1_Logs/Log_Longitudinal_stat_3.txt
%% Longitudinal LME for RSFNC: preprocessing
load ..\Res_3_IntermediateData\ABCD4.0_IDmatched_AllWave_Demo_Brain_Behav.mat
% remove the 1-year follow-up and 3-year follow-up
% in these measurement waves, the Brain image scanning is not administrited
compact_data(...
    strcmp(compact_data.eventname,'1_year_follow_up_y_arm_1') | ...
    strcmp(compact_data.eventname,'3_year_follow_up_y_arm_1'),:)=[];
% cleaning the dataset using the RS-fMRI recomended image inclusion
% criterion (imgincl_rsfmri_include)
compact_data.imgincl_rsfmri_include(isnan(compact_data.imgincl_rsfmri_include)) = 0;% replace the nan with 0 (failed QC)
fprintf('# %d data points failed in rsfmri QC\n',sum(compact_data.imgincl_rsfmri_include))
excluded_ID = unique(compact_data.src_subject_id(~compact_data.imgincl_rsfmri_include));
fprintf('# which is equivalent to %d subjects ID will be removed\n',length(excluded_ID))
fprintf('These data points will be removed and the retained subjects ID will be matched across two time waves\n')
fprintf('Befor RS-fMRI QC checking (recomended inclusion): # %d number of data points\n',size(compact_data,1))
compact_data(~compact_data.imgincl_rsfmri_include,:) = [];
fprintf('After RS-fMRI QC checking (recomended inclusion): # %d number of data points\n',size(compact_data,1))
%% Longitudinal LME for RSFNC: build LME models
% Model settings
ModelSpec.CovsName='baseline_age+sex+Handedness+Race_PrntRep+Ethnicity_PrntRep+ParentsEdu+ParentMarital+FamilyIncome+HouseholdSize+HouseholdStructure+RSfMRI_MeanFD';
ModelSpec.RandomName='(Time|site_id_l)+(Time|site_id_l:src_subject_id)';
ModelSpec.X_name = 'Idx*Time';
% specify the DVs used in LME longitudinal analysis 
Y_Name = compact_data.Properties.VariableNames(contains(compact_data.Properties.VariableNames,'rsfmri_'));
Y_Name = strrep(Y_Name,'rsfmri_c_ngd_meanmotion','');% remove head motion columns
Y_Name = strrep(Y_Name,'imgincl_rsfmri_include','');% remove head motion columns
Y_Name(ismissing(Y_Name))=[];
% run LME in batch (cut in slice for memory saving)
[Res_RSFNC_p1,mdl_RSFNC_p1] = s_ParaLongitudinalLME_LowMemory(compact_data,Y_Name(1:100),ModelSpec);
[Res_RSFNC_p2,mdl_RSFNC_p2] = s_ParaLongitudinalLME_LowMemory(compact_data,Y_Name(101:200),ModelSpec);
[Res_RSFNC_p3,mdl_RSFNC_p3] = s_ParaLongitudinalLME_LowMemory(compact_data,Y_Name(201:300),ModelSpec);
[Res_RSFNC_p4,mdl_RSFNC_p4] = s_ParaLongitudinalLME_LowMemory(compact_data,Y_Name(301:end),ModelSpec);
Res_RSFNC = [Res_RSFNC_p1;Res_RSFNC_p2;Res_RSFNC_p3;Res_RSFNC_p4];
mdl_RSFNC = [mdl_RSFNC_p1;mdl_RSFNC_p2;mdl_RSFNC_p3;mdl_RSFNC_p4];
save ..\Res_2_Results\Res_Longitudinal_RSFNC.mat Res_RSFNC mdl_RSFNC
%% FDR correction for longitudinal RSFNC
clear
load ..\Res_2_Results\Res_Longitudinal_RSFNC.mat Res_RSFNC
fprintf('Perfroming BH-FDR correction......\n')
IV_VarName = {'Time','Idx_1','Time:Idx_1'};
Res_RSFNC.FDR_pvals = nan(size(Res_RSFNC,1),1);
for i=1:length(IV_VarName)
    Flag = strcmp(Res_RSFNC.Name,IV_VarName{i});
    pvals = Res_RSFNC.pValue(Flag);
    Res_RSFNC.FDR_pvals(Flag) = mafdr(pvals,'BHFDR',true);
end
fprintf('FDR correction finished!\n')
load ..\Res_3_IntermediateData\ABCD_RSFNC_VarName_NodeName.mat
Res_RSFNC = outerjoin(Res_RSFNC,RSFNC_VarName_Node,'LeftKeys','Y_Name','RightKeys','RSFC_Name');
Res_RSFNC = movevars(Res_RSFNC,'RSFC_Name','Befor','Name');
Res_RSFNC = movevars(Res_RSFNC,'Node1','After','RSFC_Name');
Res_RSFNC = movevars(Res_RSFNC,'Node2','After','RSFC_Name');
writetable(Res_RSFNC,...
    '..\Res_2_Results\Table_LongitudinalRSFNC.xlsx')
%% Inspect the Longitudinal RSFNC LME results (for the Time*Idx interaction)
RSFNC_Interaction = Res_RSFNC(strcmp(Res_RSFNC.Name,'Time:Idx_1'),:);
RSFNC_MainEff_Time = Res_RSFNC(strcmp(Res_RSFNC.Name,'Time'),:);
RSFNC_MainEff_Idx = Res_RSFNC(strcmp(Res_RSFNC.Name,'Idx_1'),:);
fprintf('# RSFNC Interaction Effect: # %d FCs uncorrected-p<0.05  # %d FCs FDR-corrected p<0.05\n',...
    sum(RSFNC_Interaction.pValue < 0.05),sum(RSFNC_Interaction.FDR_pvals < 0.05));
fprintf('# RSFNC Time Main Effect: # %d FCs uncorrected-p<0.05  # %d FCs FDR-corrected p<0.05\n',...
    sum(RSFNC_MainEff_Time.pValue < 0.05),sum(RSFNC_MainEff_Time.FDR_pvals < 0.05));
fprintf('# RSFNC Idx Main Effect: # %d FCs uncorrected-p<0.05  # %d FCs FDR-corrected p<0.05\n',...
    sum(RSFNC_MainEff_Idx.pValue < 0.05),sum(RSFNC_MainEff_Idx.FDR_pvals < 0.05));

diary off