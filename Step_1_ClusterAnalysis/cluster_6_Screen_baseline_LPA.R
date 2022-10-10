library(tidyLPA)
library(ggplot2)
library(xlsx)
# library(MplusAutomation)
# library(mclust)
# source("I:/ABCDStudyNDA/ABCD_DataAnalysis/R_Code/LPA_calc_lrt.R")

setwd("I:\\ABCDStudyNDA\\ABCD_DataAnalysis\\Code_ScreenAnalysis2021\\Pipeline\\R_Code")
Data<-read.table('screen_baseline11817.txt',sep=',',header=TRUE)

mdl<-estimate_profiles(df=Data,n_profiles = c(1:6),
                       models = 3,
                       package = 'mclust')
mdl_fit<-get_fit(mdl)
mdl_class<-get_data(mdl)
mdl_estimate<-get_estimates(mdl)
source("I:/ABCDStudyNDA/ABCD_DataAnalysis/R_Code/LPA_calc_lrt.R")
LMRresult_p1<-LPA_calc_lrt(mdl_fit,ncol(Data),nrow(Data))
latentprofile<-mdl_estimate[which(mdl_estimate$Classes==2),]
centroid <- latentprofile[which(latentprofile$Category=='Means'),]
centroid$Class<-as.factor(centroid$Class)
centroid$Parameter<-factor(centroid$Parameter,levels = c("screen1_wkdy_y","screen2_wkdy_y", "screen3_wkdy_y",  "screen4_wkdy_y",  "screen5_wkdy_y",  "screen_wkdy_y",  
                                                         "screen7_wknd_y","screen8_wknd_y", "screen9_wknd_y",  "screen10_wknd_y", "screen11_wknd_y", "screen12_wknd_y",
                                                         "screen13_y","screen14_y"))
labels<-mdl_class[which(mdl_class$classes_number==2),]
labels<-labels[which(labels$Class_prob==1),]

ggplot(data = centroid, mapping = aes(x = Parameter, y = Estimate, group = Class, colour=Class)) + 
  geom_line()+
  theme_bw()+
  coord_cartesian(ylim = c(0, 4))+
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        panel.grid.major = element_blank(),
        axis.line = element_line(colour = "black"),
        panel.border = element_blank())
write.xlsx(centroid,"Screen_baseline_LPA_profile.xlsx")
write.xlsx(mdl_fit,"Screen_baseline_LPA_fitIndex.xlsx")
