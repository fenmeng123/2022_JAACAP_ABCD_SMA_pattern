function demo = s_zscoreDemo(demo)
% Automatically z-scoreing the contiunous demographic variables in ABCD 4.0
% data table.
% Return a table with the same variable names but the values has been
% subtracted mean and divided by SD.

% Notes: List of the demographics in ABCD 4.0 data table
% {'src_subject_id'       } Character
% {'interview_date'       } Character
% {'interview_age'        } Contiunous +
% {'sex'                  } Categorical
% {'eventname'            } Character
% {'Race_PrntRep'         } Categorical
% {'Ethnicity_PrntRep'    } Categorical
% {'BirthCountry'         } Categorical
% {'ParentMarital'        } Categorical
% {'ParentsEdu'           } Categorical
% {'ParentsMaritalEmploy' } Categorical
% {'FamilyIncome'         } Rank +
% {'HouseholdSize'        } Rank +
% {'HouseholdStructure'   } Categorical
% {'FamilyID'             } Character
% {'Relationship'         } Categorical
% {'ACS_weight'           } ACS weights
% {'Handedness'           } Categorical
% {'BMI_calc'             } Contiunous +
% {'site_id_l'            } Character
% {'EducationR'           } Rank +
demo.interview_age = nanzscore(demo.interview_age);
demo.FamilyIncome = nanzscore(demo.FamilyIncome);
demo.HouseholdSize = nanzscore(demo.HouseholdSize);
demo.BMI_calc = nanzscore(demo.BMI_calc);
demo.EducationR = nanzscore(demo.EducationR);











end