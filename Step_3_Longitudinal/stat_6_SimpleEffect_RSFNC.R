library(bruceR)
library(readxl)
library(lmerTest)
library(emmeans)
setwd("I:\\ABCDStudyNDA\\ABCD_DataAnalysis\\Code_ScreenAnalysis2021\\Pipeline\\ABCD_SMA_Code_JAACAP2022\\Res_3_IntermediateData")
source("I:\\ABCDStudyNDA\\ABCD_DataAnalysis\\Code_ScreenAnalysis2021\\Pipeline\\ABCD_SMA_Code_JAACAP2022\\Step_3_Longitudinal\\stat_4_subfunctions.R")
source("I:\\ABCDStudyNDA\\ABCD_DataAnalysis\\Code_ScreenAnalysis2021\\Pipeline\\ABCD_SMA_Code_JAACAP2022\\Step_3_Longitudinal\\stat_6_subfunctions.R")

RSFC <- read_xlsx("RSFC_GroupMainEffSig.xlsx")
RSFC <- ReorderFactorLevel(RSFC)
RSFC_Name <- colnames(RSFC)[grep('rsfmri_',colnames(RSFC))]
for (i in RSFC_Name)
{
  LME_formula = paste(i,
                      "~baseline_age+sex+Race_PrntRep+Ethnicity_PrntRep",
                      "+ParentsEdu+ParentMarital+HouseholdSize+FamilyIncome+HouseholdStructure+Idx*Time",
                      "+RSfMRI_MeanFD","+(Time||site_id_l/src_subject_id)",sep='')
  print(LME_formula)
  
  mdl <- LmeWithEmm_DiagCov_RSFC(RSFC,LME_formula)

  model_summary(mdl[[1]],std=TRUE,
                file = paste(i,"_LME_R_summary.doc",sep=''))

  print_table(mdl[[2]]$contrasts,
              file = paste(i,"_EMM_R_contrast.doc",sep=''))
  
}

# LME_formula = paste(i,
#                     "~baseline_age+sex+Race_PrntRep+Ethnicity_PrntRep+ParentsEdu+ParentMarital+HouseholdSize+FamilyIncome+HouseholdStructure+Idx",
#                     "+(1|site_id_l/FamilyID)",sep='')
# RSFC %>% subset(eventname == '2_year_follow_up_y_arm_1') %>% 
#   lmer(formula = as.formula(LME_formula),
#             control = lmerControl(optimizer = "Nelder_Mead",
#                                   # check.nobs.vs.nRE = "ignore",
#                                   optCtrl = list(maxfun=2e4))) -> res
# summary(res)
Sig_RSFC_Name <- c('rsfmri_c_ngd_vta_ngd_ca','rsfmri_cor_ngd_df_scs_agrh',
                   'rsfmri_cor_ngd_sa_scs_vtdclh','rsfmri_cor_ngd_vta_scs_cdelh')
for (i in Sig_RSFC_Name)
{
  LME_formula = paste(i,
                      "~baseline_age+sex+Race_PrntRep+Ethnicity_PrntRep",
                      "+ParentsEdu+ParentMarital+HouseholdSize+FamilyIncome+HouseholdStructure+Idx*Time",
                      "+RSfMRI_MeanFD","+(Time||site_id_l/src_subject_id)",sep='')
  print(LME_formula)
  
  mdl <- LmeWithEmm_DiagCov_RSFC(RSFC,LME_formula)
  
  print_table(mdl[[2]]$emmeans,
              file = paste(i,"_EMM_R_means.doc",sep=''))
  
}