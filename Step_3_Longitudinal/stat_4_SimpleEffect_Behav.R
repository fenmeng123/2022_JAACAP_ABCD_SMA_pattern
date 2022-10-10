library(bruceR)
library(readxl)
library(lmerTest)
library(emmeans)
setwd("I:\\ABCDStudyNDA\\ABCD_DataAnalysis\\Code_ScreenAnalysis2021\\Pipeline\\JAACAP_Revision220920\\Res_3_IntermediateData")
source("I:\\ABCDStudyNDA\\ABCD_DataAnalysis\\Code_ScreenAnalysis2021\\Pipeline\\JAACAP_Revision220920\\Step_3_Longitudinal\\stat_4_subfunctions.R")
BAS<-read_xlsx("BAS_Sum.xlsx")
BIS<-read_xlsx("BIS_Sum.xlsx")
UPPS<-read_xlsx("UPPS_Sum.xlsx")
totprob<-read_xlsx("CBCL_syn_totprob_t.xlsx")
PPS<-read_xlsx("PPS_Severity_Sum.xlsx")
# modeling ----------------------------------------------------------------

totprob %>% ReorderFactorLevel() %>% LmeWithEmm_DiagCov() -> totprob_mdl
BIS %>% ReorderFactorLevel() %>% LmeWithEmm_DiagCov() -> BIS_mdl
BAS %>% ReorderFactorLevel() %>% LmeWithEmm_DiagCov() -> BAS_mdl
UPPS %>% ReorderFactorLevel() %>% LmeWithEmm_DiagCov() -> UPPS_mdl
PPS %>% ReorderFactorLevel() %>% LmeWithEmm_DiagCov() -> PPS_mdl
model_summary(UPPS_mdl[[1]],std=TRUE,file = "UPPS_LME_R_summary.doc")
model_summary(totprob_mdl[[1]],std=TRUE,file = "totprob_LME_R_summary.doc")
model_summary(BIS_mdl[[1]],std=TRUE,file = "BIS_LME_R_summary.doc")
model_summary(BAS_mdl[[1]],std=TRUE,file = "BAS_LME_R_summary.doc")
model_summary(PPS_mdl[[1]],std=TRUE,file = "PPS_LME_R_summary.doc")

print_table(UPPS_mdl[[2]]$contrasts,file = "UPPS_EMM_R_contrast.doc")
print_table(totprob_mdl[[2]]$contrasts,file = "totprob_EMM_R_contrast.doc")
print_table(BIS_mdl[[2]]$contrasts,file = "BIS_EMM_R_contrast.doc")
print_table(BAS_mdl[[2]]$contrasts,file = "BAS_EMM_R_contrast.doc")
print_table(PPS_mdl[[2]]$contrasts,file = "PPS_EMM_R_contrast.doc")
