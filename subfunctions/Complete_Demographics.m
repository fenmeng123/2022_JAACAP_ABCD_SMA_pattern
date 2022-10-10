function complete_target = Complete_Demographics(anchor,target)
% Complete the demographics in the ABCD 4.0 follow-up waves
% replace empty with baseline demographic variables
% By Kunru Song 2022.9.23
% Input:
% anchor - the baseline data table with the following demographics
% target - a certain follow-up wave data table (only accept a single time point dataset)
demoVarName = {'Race_PrntRep';'Ethnicity_PrntRep';'BirthCountry';'ParentMarital';...
    'ParentsEdu';'ParentsMaritalEmploy';'FamilyIncome';'HouseholdSize';...
    'HouseholdStructure';'FamilyID';'Relationship';'Handedness';'BMI_calc';...
    'site_id_l';'EducationR'};
fprintf('Demographics variable list:\n')
disp(demoVarName);
Flag = contains(anchor.Properties.VariableNames,[{'src_subject_id';'sex';'Idx'};demoVarName]);
compact_anchor = anchor(:,Flag);
compact_anchor.baseline_age = anchor.interview_age;
target = removevars(target,demoVarName);
complete_target = innerjoin(compact_anchor,target,'Keys',{'src_subject_id','sex'});
complete_target = movevars(complete_target,'interview_date','After','src_subject_id');
complete_target = movevars(complete_target,'sex','After','interview_date');
complete_target = movevars(complete_target,'eventname','After','sex');
complete_target = movevars(complete_target,'interview_age','After','eventname');
complete_target = movevars(complete_target,'Idx','After','eventname');
complete_target = movevars(complete_target,'baseline_age','After','interview_age');

end