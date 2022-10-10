function compact_data = s_Preproc_LongitudinalRSFNC()
load I:\ABCDStudyNDA\ABCD_DataAnalysis\Code_ScreenAnalysis2021\Pipeline\JAACAP_Revision220920\Res_3_IntermediateData\ABCD4.0_IDmatched_AllWave_Demo_Brain_Behav.mat compact_data
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
end