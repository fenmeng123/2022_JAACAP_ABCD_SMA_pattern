* Encoding: UTF-8.

DATASET ACTIVATE DataSet1.


NOMREG TrainsitionLabel_3level (BASE='Sustaining SMA SubG(1 or 2)' ORDER=ASCENDING) BY sex 
    Race_PrntRep Ethnicity_PrntRep ParentMarital ParentsEdu HouseholdStructure WITH baseline_age 
    FamilyIncome HouseholdSize CBCL_syn_internal_t CBCL_syn_external_t CBCL_syn_totprob_t 
    PPS_Severity_Sum BIS_Sum BAS_Sum UPPS_Sum NIHTB_fluidcomp_ac NIHTB_cryst_ac NIHTB_totalcomp_ac 
    rsfmri_c_ngd_vta_ngd_ca rsfmri_cor_ngd_df_scs_agrh rsfmri_cor_ngd_sa_scs_vtdclh 
    rsfmri_cor_ngd_vta_scs_cdelh
  /CRITERIA CIN(95) DELTA(0) MXITER(100) MXSTEP(5) CHKSEP(20) LCONVERGE(0) PCONVERGE(0.000001) 
    SINGULAR(0.00000001)
  /MODEL=sex Race_PrntRep Ethnicity_PrntRep ParentMarital ParentsEdu HouseholdStructure 
    baseline_age FamilyIncome HouseholdSize | FORWARD=CBCL_syn_internal_t CBCL_syn_external_t 
    CBCL_syn_totprob_t PPS_Severity_Sum BIS_Sum BAS_Sum UPPS_Sum NIHTB_fluidcomp_ac NIHTB_cryst_ac 
    NIHTB_totalcomp_ac rsfmri_c_ngd_vta_ngd_ca rsfmri_cor_ngd_df_scs_agrh rsfmri_cor_ngd_sa_scs_vtdclh 
    rsfmri_cor_ngd_vta_scs_cdelh
  /STEPWISE=PIN(.05) POUT(0.1) MINEFFECT(0) RULE(SINGLE) ENTRYMETHOD(LR) REMOVALMETHOD(LR)
  /INTERCEPT=INCLUDE
  /PRINT=FIT PARAMETER SUMMARY LRT CPS STEP MFI IC
  /SAVE ESTPROB PREDCAT PCPROB.


*Generalized Linear Mixed Models. 
GENLINMIXED
  /DATA_STRUCTURE SUBJECTS=site_id_l*FamilyID*src_subject_id
  /FIELDS TARGET=TrainsitionLabel_3level TRIALS=NONE OFFSET=NONE
  /TARGET_OPTIONS REFERENCE='Sustaining SMA SubG (1 or 2)'  DISTRIBUTION=MULTINOMIAL LINK=LOGIT
  /FIXED  EFFECTS=sex baseline_age Race_PrntRep Ethnicity_PrntRep ParentMarital ParentsEdu 
    FamilyIncome HouseholdSize HouseholdStructure CBCL_syn_internal_t CBCL_syn_external_t 
    CBCL_syn_totprob_t PPS_Severity_Sum BIS_Sum BAS_Sum UPPS_Sum NIHTB_fluidcomp_ac NIHTB_cryst_ac 
    NIHTB_totalcomp_ac rsfmri_c_ngd_vta_ngd_ca rsfmri_cor_ngd_df_scs_agrh rsfmri_cor_ngd_sa_scs_vtdclh 
    rsfmri_cor_ngd_vta_scs_cdelh USE_INTERCEPT=TRUE
  /RANDOM USE_INTERCEPT=TRUE SUBJECTS=site_id_l COVARIANCE_TYPE=VARIANCE_COMPONENTS SOLUTION=FALSE 
  /RANDOM USE_INTERCEPT=TRUE SUBJECTS=site_id_l*FamilyID COVARIANCE_TYPE=VARIANCE_COMPONENTS 
    SOLUTION=FALSE 
  /BUILD_OPTIONS TARGET_CATEGORY_ORDER=ASCENDING INPUTS_CATEGORY_ORDER=ASCENDING MAX_ITERATIONS=100 
    CONFIDENCE_LEVEL=95 DF_METHOD=RESIDUAL COVB=MODEL PCONVERGE=0.000001(ABSOLUTE) SCORING=0 
    SINGULAR=0.000000000001
  /EMMEANS_OPTIONS SCALE=ORIGINAL PADJUST=LSD.
