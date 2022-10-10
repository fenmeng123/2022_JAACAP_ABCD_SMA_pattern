function compact_tmp = s_preparLongitudinalRSFNC(data)
% Prepare the data for ploting RSFNC longitudinal results
% for ABCD4.0 Merged&Recoded data table
% By Kunru Song 2022.9.27
fprintf('Time waves for the input data table:\n')
tabulate(data.eventname)
Num_Waves = length(unique(data.eventname));
ID_counts = tabulate(data.src_subject_id);
fprintf('Subject ID repeatition times after removing missing values:\n')
tabulate([ID_counts{:,2}])
fprintf('Selected the subject ID with repatition times>= the number of waves\n')
ID_selected = {ID_counts{[ID_counts{:,2}]==Num_Waves,1}};
compact_tmp  = data(contains(data.src_subject_id,ID_selected),:);
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
end