clc
clear
diary ../Res_1_Logs/Log_CrossSectional_stat_1.txt

load ..\Res_3_IntermediateData\ABCD4.0_Screen_Cluster_y0.mat
Demograph = readtable(...
    '..\Res_3_IntermediateData\ABCD4.0_Merged_Baseline_Demo_Behav.csv');
%% Clean and Join two data table
Demograph = removevars(Demograph,'Var1');
STQ = removevars(STQ,'Var1');
Demograph = removevars(Demograph,{'weekday_TV', 'weekday_Video','weekday_Game','weekday_Text',...
    'weekday_SocialNet','weekday_VideoChat','weekend_TV','weekend_Video',...
    'weekend_Game','weekend_Text','weekend_SocialNet','weekend_VideoChat',...
    'screen13_y','screen14_y'});
fprintf('Key variables:\n')
disp(intersect(Demograph.Properties.VariableNames,STQ.Properties.VariableNames))
Demograph = outerjoin(STQ,Demograph,'MergeKeys',true);
clearvars STQ
% recode demogrpahic variables
[Demograph, MissFlag] = Demographics_Recode(Demograph);
%% Calculate the SMA subgroup demographic difference analysis
demoGD=table('Size',[14, 8],...
    'VariableNames',{'VarName','t_chi2','df','N','p','effect_size','CI_es','others'},...
    'VariableTypes',{'string','double','double','double','double','double','double','cell'});
Idx = double(Demograph.Idx);
stats=stat_GDiff_Effect(Demograph.interview_age,Idx);
demoGD.VarName(1)='Age';
demoGD.N(1) = sum(~isnan(Idx));
demoGD=AutoCalc_GD(1,stats,demoGD);
% Gender
stats=stat_GDiff_Effect(Demograph.sex,Idx);
demoGD.VarName(2)='Gender';
demoGD.N(2) = sum(~isnan(Idx));
demoGD=AutoCalc_GD(2,stats,demoGD);
% Handness
stats=stat_GDiff_Effect(Demograph.Handedness,Idx);
demoGD.VarName(3)='Handedness';
demoGD.N(3) = sum(~isnan(Idx));
demoGD=AutoCalc_GD(3,stats,demoGD);
% Relationship
stats=stat_GDiff_Effect(Demograph.Relationship(~MissFlag.Rela_MissFlag),Idx(~MissFlag.Rela_MissFlag));
demoGD.VarName(4)='Relathionship in family';
demoGD.N(4) = sum(~MissFlag.Rela_MissFlag&~isnan(Idx));
demoGD=AutoCalc_GD(4,stats,demoGD);
% Education (rank)
stats=stat_GDiff_Effect(Demograph.EducationR(~MissFlag.Edu_MissFlag),Idx(~MissFlag.Edu_MissFlag));
demoGD.VarName(5)='EducationR';
demoGD.N(5) = sum(~MissFlag.Edu_MissFlag&~isnan(Idx));
demoGD=AutoCalc_GD(5,stats,demoGD);
% Race
stats=stat_GDiff_Effect(Demograph.Race_PrntRep(~MissFlag.Race_MissFlag),Idx(~MissFlag.Race_MissFlag));
demoGD.VarName(6)='Race';
demoGD.N(6) = sum(~MissFlag.Race_MissFlag&~isnan(Idx));
demoGD=AutoCalc_GD(6,stats,demoGD);
% Ethnicity
stats=stat_GDiff_Effect(Demograph.Ethnicity_PrntRep,Idx);
demoGD.VarName(7)='Ethnicity';
demoGD.N(7) = sum(~isnan(Idx));
demoGD=AutoCalc_GD(7,stats,demoGD);
% Parents Marrital Status
stats=stat_GDiff_Effect(Demograph.ParentMarital(~MissFlag.PrntMari_MissFlag),Idx(~MissFlag.PrntMari_MissFlag));
demoGD.VarName(8)='Parents Marrital Status';
demoGD.N(8) = sum(~MissFlag.PrntMari_MissFlag&~isnan(Idx));
demoGD=AutoCalc_GD(8,stats,demoGD);
% Parents Highest Education
stats=stat_GDiff_Effect(Demograph.ParentsEdu(~MissFlag.PrntEdu_MissFlag),Idx(~MissFlag.PrntEdu_MissFlag));
demoGD.VarName(9)='Parents Highest Education';
demoGD.N(9) = sum(~MissFlag.PrntEdu_MissFlag&~isnan(Idx));
demoGD=AutoCalc_GD(9,stats,demoGD);
% Parents Employment Status
stats=stat_GDiff_Effect(Demograph.ParentsMaritalEmploy(~MissFlag.PrntEmp_MissFlag),Idx(~MissFlag.PrntEmp_MissFlag));
demoGD.VarName(10)='Parents Employment Status';
demoGD.N(10) = sum(~MissFlag.PrntEmp_MissFlag&~isnan(Idx));
demoGD=AutoCalc_GD(10,stats,demoGD);
% Household Size (Family Size)
stats=stat_GDiff_Effect(Demograph.HouseholdSize(~MissFlag.FamSize_MissFlag),Idx(~MissFlag.FamSize_MissFlag));
demoGD.VarName(11)='Family Size R';
demoGD.N(11) = sum(~MissFlag.FamSize_MissFlag&~isnan(Idx));
demoGD=AutoCalc_GD(11,stats,demoGD);
% Household Structure (Single/Another Household)
stats=stat_GDiff_Effect(Demograph.HouseholdStructure(~MissFlag.AnoHouse_MissFlag),Idx(~MissFlag.AnoHouse_MissFlag));
demoGD.VarName(12)='Household Structure';
demoGD=AutoCalc_GD(12,stats,demoGD);
demoGD.N(12) = sum(~MissFlag.AnoHouse_MissFlag&~isnan(Idx));
% Birth at Country
stats=stat_GDiff_Effect(Demograph.BirthCountry(~MissFlag.BirthCoun_MissFlag),Idx(~MissFlag.BirthCoun_MissFlag));
demoGD.VarName(13)='Country of Birth';
demoGD.N(13) = sum(~MissFlag.BirthCoun_MissFlag&~isnan(Idx));
demoGD=AutoCalc_GD(13,stats,demoGD);
% Combine Total Family Income
stats=stat_GDiff_Effect(Demograph.FamilyIncome(~MissFlag.FamIncome_MissFlag),Idx(~MissFlag.FamIncome_MissFlag));
demoGD.VarName(14)='FamIncome R';
demoGD.N(14) = sum(~MissFlag.FamIncome_MissFlag&~isnan(Idx));
demoGD=AutoCalc_GD(14,stats,demoGD);

%% convert demographic group difference table to cell
tabulate(Idx)

demoGD.VarName = cellstr(demoGD.VarName);
demoGD.LowCI = demoGD.CI_es(:,1);
demoGD.UpCI = demoGD.CI_es(:,2);
demoGD = removevars(demoGD,'CI_es');
NewDemoGD = removevars(demoGD,'others');
NewDemoGD = [NewDemoGD.Properties.VariableNames; table2cell(NewDemoGD)];
Flag = ~cellfun(@isempty,demoGD.others);
CatVarName = demoGD.VarName(Flag);
for i=1:length(CatVarName)
    Index = find(strcmp(NewDemoGD(:,1),CatVarName{i}));
    Index_raw = find(strcmp(demoGD.VarName,CatVarName{i}));
    crossT = [demoGD.others{Index_raw}.Properties.RowNames,fliplr(table2cell(demoGD.others{Index_raw}))];
    NewDemoGD(Index+1+size(crossT,1):end+size(crossT,1),:) = NewDemoGD(Index+1:end,:);
    NewDemoGD(Index+1:Index+1+size(crossT,1)-1,:) = cell(size(crossT,1),8);
    NewDemoGD(Index+1:Index+1+size(crossT,1)-1,1:size(crossT,2)) = crossT;
end
NewDemoGD{2,end+1} = mean(Demograph.interview_age(Idx==2));
NewDemoGD{2,end+1} = std(Demograph.interview_age(Idx==2));
NewDemoGD{2,end+1} = mean(Demograph.interview_age(Idx==1));
NewDemoGD{2,end+1} = std(Demograph.interview_age(Idx==1));

writecell(NewDemoGD,...
    '..\Res_2_Results\Table1.xlsx')

%% save recoded data
% According to the tabulated counts of cluster index, in the current
% k-means results, the index 1 indicates the subgroup 2 (N=8664) while the
% index 2 indicates the subgroup 1 (N=3151). Thus, we need to exchange the
% raw cluster indexes to match the previous results from the ABCD 3.0 Data
% release

save ..\Res_3_IntermediateData\ABCD4.0_Recoded_Baseline_Demo_Behav.mat Demograph
save ..\Res_3_IntermediateData\ABCD4.0_Demo_MissFlag.mat MissFlag

diary off
