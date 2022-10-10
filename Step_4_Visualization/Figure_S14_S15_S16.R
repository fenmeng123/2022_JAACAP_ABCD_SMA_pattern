

library(xlsx)
library(ggplot2)
library(ggExtra)
library(MASS)
library(pheatmap)
setwd('I:\\ABCDStudyNDA\\ABCD_DataAnalysis\\Code_ScreenAnalysis2021\\Pipeline\\R_Code')
# T <- read.csv('Table_BehavP1.xlsx')
#----
Data<-read.table('Table_BehavP1.txt',sep = '\t',header = TRUE)
Data$subgroup<-factor(Data$Idx,levels = c(1,2),labels = c('subgroup1','subgroup2'))
Data$TV_Video_GameTime<-Data$SMA_TVTime+Data$SMA_VideoTime+Data$SMA_GameTime
#-------
margin_scatter_plot<-function(Data,filename='test.tiff',xlabel='x',ylabel='y',...){
  p<-ggplot(data=Data,
            mapping=aes(...)
  )+
    geom_point(na.rm = TRUE)+
    scale_colour_manual(values = alpha(
      c(subgroup1=rgb(0.85,0.325,0.098),subgroup2=rgb(0,0.447,0.741)),0.5)
    )+
    stat_smooth(method = 'gam',na.rm = TRUE,size=1,fullrange = FALSE)+
    labs(x=xlabel,y=ylabel)+
    theme_classic()+
    theme(legend.position = "bottom")
  p<-ggMarginal(p, type = "density", groupColour = TRUE, groupFill = TRUE)
  show(p)
  ggsave(filename, p, device = "tiff", dpi = 300)
}


#cognition total#---------
# Cognition Total Score
margin_scatter_plot(Data,'scatter_CognitionTot_SMATot.tiff',
                    x=SMA_TotTime,
                    y=Cognition.Total.Composite.Score,
                    xlabel = 'Typical Day SMA Total Time (Week-average)',
                    ylabel = 'Cognition Total Composite Score (NIH Toolbox)',
                    color=subgroup)

margin_scatter_plot(Data,'scatter_CognitionTot_TV.tiff',
                    x=SMA_TVTime,
                    y=Cognition.Total.Composite.Score,
                    xlabel = 'Typical Day SMA Watching TV Time (Week-average)',
                    ylabel = 'Cognition Total Composite Score (NIH Toolbox)',
                    color=subgroup)

margin_scatter_plot(Data,'scatter_CognitionTot_Game.tiff',
                    x=SMA_GameTime,
                    y=Cognition.Total.Composite.Score,
                    xlabel = 'Typical Day SMA Playing Video Game Time (Week-average)',
                    ylabel = 'Cognition Total Composite Score (NIH Toolbox)',
                    color=subgroup)

margin_scatter_plot(Data,'scatter_CognitionTot_Video.tiff',
                    x=SMA_VideoTime,
                    y=Cognition.Total.Composite.Score,
                    xlabel = 'Typical Day SMA Watching Video Time (Week-average)',
                    ylabel = 'Cognition Total Composite Score (NIH Toolbox)',
                    color=subgroup)

margin_scatter_plot(Data,'scatter_CognitionTot_TVVideoGane.tiff',
                    x=TV_Video_GameTime,
                    y=Cognition.Total.Composite.Score,
                    xlabel = 'Typical Day SMA TV+Video+Game Time (Week-average)',
                    ylabel = 'Cognition Total Composite Score (NIH Toolbox)',
                    color=subgroup)
#BIS#---------
# BIS sum score
margin_scatter_plot(Data,'scatter_BIS_Video.tiff',
                    x=TV_Video_GameTime,
                    y=BIS.Sum.modified.,
                    xlabel = 'Typical Day SMA TV+Video+Game Time (Week-average)',
                    ylabel = 'BIS Sum Score',
                    color=subgroup)

margin_scatter_plot(Data,'scatter_BIS_TotTime.tiff',
                    x=SMA_TotTime,
                    y=BIS.Sum.modified.,
                    xlabel = 'Typical Day SMA Total Time (Week-average)',
                    ylabel = 'BIS Sum Score',
                    color=subgroup)

#---------------
# UPPS sum score
margin_scatter_plot(Data,'scatter_UPPS_Video.tiff',
                    x=TV_Video_GameTime,
                    y=UPPS.Sum,
                    xlabel = 'Typical Day SMA TV+Video+Game Time (Week-average)',
                    ylabel = 'UPPS Sum Score',
                    color=subgroup)

margin_scatter_plot(Data,'scatter_UPPS_TotTime.tiff',
                    x=SMA_TotTime,
                    y=UPPS.Sum,
                    xlabel = 'Typical Day SMA Total Time (Week-average)',
                    ylabel = 'UPPS Sum Score',
                    color=subgroup)

#---------
# BAS sum score
margin_scatter_plot(Data,'scatter_BAS_TotTime.tiff',
                    x=SMA_TotTime,
                    y=BAS.Sum.modified.,
                    xlabel = 'Typical Day SMA Total Time (Week-average)',
                    ylabel = 'BAS Sum Score',
                    color=subgroup)
#---------
Data<-read.table('Table_BehavP2.txt',sep = '\t',header = TRUE)
Data$subgroup<-factor(Data$Idx,levels = c(1,2),labels = c('subgroup1','subgroup2'))
Data$TV_Video_GameTime<-Data$SMA_TVTime+Data$SMA_VideoTime+Data$SMA_GameTime

#PPS CBCL#--------
margin_scatter_plot(Data,'scatter_PPS_Video.tiff',
                    x=TV_Video_GameTime,
                    y=Prodromal.Psychosis.Scale.Serverity.Score,
                    xlabel = 'Typical Day SMA TV+Video+Game Time (Week-average)',
                    ylabel = 'PPS serverity',
                    color=subgroup)
margin_scatter_plot(Data,'scatter_PPS_TotTime.tiff',
                    x=SMA_TotTime,
                    y=Prodromal.Psychosis.Scale.Serverity.Score,
                    xlabel = 'Typical Day SMA Total Time (Week-average)',
                    ylabel = 'PPS serverity',
                    color=subgroup)

margin_scatter_plot(Data,'scatter_CBCLtotprob_Video.tiff',
                    x=TV_Video_GameTime,
                    y=TotProb.CBCL.Syndrome.Scale,
                    xlabel = 'Typical Day SMA TV+Video+Game Time (Week-average)',
                    ylabel = 'CBCL TotProb (t-score)',
                    color=subgroup)
margin_scatter_plot(Data,'scatter_CBCLtotprob_TotTime.tiff',
                    x=SMA_TotTime,
                    y=TotProb.CBCL.Syndrome.Scale,
                    xlabel = 'Typical Day SMA Total Time (Week-average)',
                    ylabel = 'CBCL TotProb (t-score)',
                    color=subgroup)


#---------

#---------
convert_T2df<-function(beta.table){
  SMAtype<-unique(beta.table$Name)
  LMM_Res_df<-matrix(0,length(unique(beta.table$YName)),length(unique(beta.table$Name)))
  for (i in 1:length(SMAtype)){
    LMM_Res_df[,i]<-beta.table$Estimate[beta.table$Name==SMAtype[i]]
  }
  LMM_Res_df<-as.data.frame(LMM_Res_df,row.names = unique(beta.table$YName) )
  colnames(LMM_Res_df)<-as.list(SMAtype)
  return(LMM_Res_df)
}
##### plot settings
bk=seq(-0.1,0.1,0.001)
######
beta.table<- read.xlsx('..\\Table\\BehavP2_TimeSMAtype.xlsx',sheetName = 'SubG1')
LMM_Res_df<-convert_T2df(beta.table)
pheatmap(t(LMM_Res_df),
         display_numbers = TRUE,cluster_cols = F,cluster_rows = F,
         cellwidth = 25, cellheight = 20,
         angle_col = "315",main = "Mental Health: Standardized Beta in Subgroup 1",
         color = colorRampPalette(c('royalblue','white','firebrick3'))(length(bk)),
         breaks = bk,
         filename = "behavP2_SubG1.tiff")
######
beta.table<- read.xlsx('..\\Table\\BehavP2_TimeSMAtype.xlsx',sheetName = 'SubG2')
LMM_Res_df<-convert_T2df(beta.table)
pheatmap(t(LMM_Res_df),
         display_numbers = TRUE,cluster_cols = F,cluster_rows = F,
         cellwidth = 25, cellheight = 20,
         angle_col = "315",main = "Mental Health: Standardized Beta in Subgroup 2",
         color = colorRampPalette(c('royalblue','white','firebrick3'))(length(bk)),
         breaks = bk,
         filename = "behavP2_SubG2.tiff")
##### plot settings
bk=seq(-0.15,0.15,0.001)
######
beta.table<- read.xlsx('..\\Table\\BehavP1_TimeSMAtype.xlsx',sheetName = 'SubG1')
LMM_Res_df<-convert_T2df(beta.table)
pheatmap(t(LMM_Res_df),
         display_numbers = TRUE,cluster_cols = F,cluster_rows = F,
         cellwidth = 25, cellheight = 20,
         angle_col = "315",main = "Neurocognition: Standardized Beta in Subgroup 1",
         color = colorRampPalette(c('royalblue','white','firebrick3'))(length(bk)),
         breaks = bk,
         filename = "behavP1_SubG1.tiff")
######
beta.table<- read.xlsx('..\\Table\\BehavP1_TimeSMAtype.xlsx',sheetName = 'SubG2')
LMM_Res_df<-convert_T2df(beta.table)
pheatmap(t(LMM_Res_df),
         display_numbers = TRUE,cluster_cols = F,cluster_rows = F,
         cellwidth = 25, cellheight = 20,
         angle_col = "315",main = "Neurocognition: Standardized Beta in Subgroup 2",
         color = colorRampPalette(c('royalblue','white','firebrick3'))(length(bk)),
         breaks = bk,
         filename = "behavP1_SubG2.tiff")

         # color = colorRampPalette(colors = c("blue","white","red"))(100))