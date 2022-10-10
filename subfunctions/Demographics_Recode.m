function [demo, MissFlag] = Demographics_Recode(demo)
% By Kunru Song 2021.6
% Notes:
% 'Ethnicity' and 'handedness' didn't have any missing values
Rela_MissFlag=strcmp(demo.Relationship,'NA') | strcmp(demo.Relationship,'NA');
Edu_MissFlag=strcmp(demo.EducationR,'NA');
Race_MissFlag=strcmp(demo.Race_PrntRep,'NA');
PrntMari_MissFlag=strcmp(demo.ParentMarital,'NA');
PrntEmp_MissFlag=strcmp(demo.ParentsMaritalEmploy,'NA');
PrntEdu_MissFlag=strcmp(demo.ParentsEdu,'NA');
FamSize_MissFlag=isnan(demo.HouseholdSize);
AnoHouse_MissFlag=strcmp(demo.HouseholdStructure,'NA');
BirthCoun_MissFlag=strcmp(demo.BirthCountry,'NA');
FamIncome_MissFlag=strcmp(demo.FamilyIncome,'NA');
Idx_MissFlag = isnan(demo.Idx);

% Create MissFlag table for demographic variables
MissFlag=table(Idx_MissFlag,Rela_MissFlag,Edu_MissFlag,Race_MissFlag,...
    PrntMari_MissFlag,PrntEmp_MissFlag,PrntEdu_MissFlag,...
    FamSize_MissFlag,AnoHouse_MissFlag,BirthCoun_MissFlag,FamIncome_MissFlag);
fprintf('Missing number in the demographic variables\n')
disp([strrep(MissFlag.Properties.VariableNames,'_MissFlag','');num2cell(sum(MissFlag.Variables))])

fprintf('Recoding the demographics from R type to MATLAB type......\n')

demo.Relationship = categorical(replace(demo.Relationship,...
    {'single','sibling','twin','triplet'},...
    {'single','sibling','twin/triplet','twin/triplet'}),...
    {'single','sibling','twin/triplet'});
demo.EducationR = str2double(replace(demo.EducationR,...
    {'2ND GRADE or less','3RD GRADE','4TH GRADE','5TH GRADE','6TH GRADE or more','NA'},...
    {'1','2','3','4','5','nan'}));
demo.Race_PrntRep = categorical(demo.Race_PrntRep,...
    {'White','Black','Asian','Mixed/other'});
demo.Ethnicity_PrntRep = categorical(demo.Ethnicity_PrntRep,...
    {'Hispanic/Latino/Latina','No'});
demo.ParentMarital = categorical(demo.ParentMarital,...
    {'Single','Married or living with partner'});
demo.ParentsMaritalEmploy = categorical(demo.ParentsMaritalEmploy,...
    {'Married, 2 in LF','Married, 1 in LF', 'Married, 0 in LF','Single, in LF','Single, Not in LF'});
demo.ParentsEdu = categorical(replace(demo.ParentsEdu,...
    {'< HS Diploma','HS Diploma/GED', 'Some College','Bachelor','Post Graduate Degree'},...
    {'high school or less','high school or less','college education','college education','college education'}),...
    {'high school or less','college education'});
demo.HouseholdStructure = categorical(demo.HouseholdStructure,...
    {'Single household','Another household'});
demo.BirthCountry = categorical(demo.BirthCountry,...
    {'Other','USA'});
demo.FamilyIncome = str2double(replace(demo.FamilyIncome,...
    {'<$25k','$25k-$49k','$50k-$74k','$75k-$99k','$100k-$199k','$200k+','NA'},...
    {'1','2','3','4','5','6','nan'}));
% change the meanings of cluster index
% The kmeans function in MATLAB will randomly give the cluster index, thus,
% even for the same cluster centroid, the kmeans function will give
% different cluster index number at each it is performed. We need to check
% the cluster index in this k-means clustering result and change it if it
% is different from the SMA subgroup1 (higher frequency video-centric use, 
% cluster index number = 1) and subgroup2(lower frequency use, 
% cluster index number = 2)
fprintf('check and change the cluster index number......\n')
fprintf('raw cluster index number from kmeans')
tabulate(demo.Idx)
demo.Idx = demo.Idx - 1;
demo.Idx(demo.Idx == 0) = 2;
fprintf('new cluster index number')
tabulate(demo.Idx)
demo.Idx = categorical(demo.Idx,[2,1]);


fprintf('Recoding finished!\n')
end






