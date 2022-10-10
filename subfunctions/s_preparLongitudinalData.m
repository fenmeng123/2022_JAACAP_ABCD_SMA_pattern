function compact_tmp = s_preparLongitudinalData(data,DV_VarName)
% Prepare the data for longitudinal LME analysis
% for ABCD4.0 Merged&Recoded data table
% By Kunru Song 2022.9.24
fprintf('Preparing DV:%s......\n',DV_VarName)
eval(['DV = data.' DV_VarName ';']);
Flag = isnan(DV);
fprintf('Change the DV variable name from %s to Y\n',DV_VarName)
data.Y = DV;
data = removevars(data,DV_VarName);
fprintf('# %d data points have missing values in DV (Total: %d)\n',sum(Flag),size(data,1))
tmp = data(~Flag,:);
fprintf('Time waves after removing missing values:\n')
tabulate(tmp.eventname)
Num_Waves = length(unique(tmp.eventname));
ID_counts = tabulate(tmp.src_subject_id);
fprintf('Subject ID repeatition times after removing missing values:\n')
tabulate([ID_counts{:,2}])
fprintf('Selected the subject ID with repatition times>=%d (all avaiable waves: baseline, 1-year, 2-year, 3-year)\n',NumWaves)
ID_selected = {ID_counts{[ID_counts{:,2}]==Num_Waves,1}};
compact_tmp  = tmp(contains(tmp.src_subject_id,ID_selected),:);
fprintf('Time waves after matching ID across time waves:\n')
tabulate(compact_tmp.eventname)
fprintf('Recoding eventname to numric time waves (VarName:Time)......\n')
if any(strcmp(compact_tmp.eventname,'baseline_year_1_arm_1')) &&...
        any(strcmp(compact_tmp.eventname,'1_year_follow_up_y_arm_1')) &&...
        any(strcmp(compact_tmp.eventname,'2_year_follow_up_y_arm_1')) &&...
        any(strcmp(compact_tmp.eventname,'3_year_follow_up_y_arm_1'))
    Time = str2double(replace(compact_tmp.eventname,...
        {'baseline_year_1_arm_1','1_year_follow_up_y_arm_1','2_year_follow_up_y_arm_1','3_year_follow_up_y_arm_1'},...
        {'0','1','2','3'}));
elseif any(strcmp(compact_tmp.eventname,'baseline_year_1_arm_1')) && ...
        any(strcmp(compact_tmp.eventname,'2_year_follow_up_y_arm_1')) && ...
        ~any(strcmp(compact_tmp.eventname,'1_year_follow_up_y_arm_1'))
    Time = str2double(replace(compact_tmp.eventname,...
        {'baseline_year_1_arm_1','2_year_follow_up_y_arm_1'},...
        {'0','1'}));
else 
    Time = str2double(replace(compact_tmp.eventname,...
        {'baseline_year_1_arm_1','1_year_follow_up_y_arm_1','2_year_follow_up_y_arm_1'},...
        {'0','1','2'}));
end
tabulate(Time)
compact_tmp.Time = Time;
compact_tmp = movevars(compact_tmp,'Time','After','eventname');
compact_tmp = movevars(compact_tmp,'Y','After','Time');
% the effect-coding in MATLAB will treat the last category as reference
% level, so we need to reorder the 'Idx' categorical variable to make a
% comparison SMA subgroup1 - SMA subgroup2
compact_tmp.Idx = reordercats(compact_tmp.Idx,{'1','2'});
compact_tmp.sex = categorical(compact_tmp.sex,{'F','M'});

end