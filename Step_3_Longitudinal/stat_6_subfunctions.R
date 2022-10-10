LmeWithEmm_DiagCov_RSFC <- function(df,formula_text){
  res<-lmer(data = df,
            formula = as.formula(formula_text),
            control = lmerControl(optimizer = "Nelder_Mead",
                                  # check.nobs.vs.nRE = "ignore",
                                  optCtrl = list(maxfun=2e4)))
  if ( length(unique(df$Time)) ==2 ) {
    TimeCut<-list(Time=c(0,1))
  }else{
    TimeCut<-list(Time=c(0,1,2))
  }
  emm<- emmeans(res, 
                specs = pairwise ~ Idx*Time,
                at=TimeCut,
                adjust="tukey",
                lmer.df = "satterthwaite",weights = "proportional")
  return(list(res,emm))
  
}