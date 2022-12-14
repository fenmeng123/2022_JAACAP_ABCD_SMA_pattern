clc
clear
%% Figure S11 A
% Adjusted LME results for RSFC
Res_RSFNC = readtable('../Res_2_Results/Table_FigS11.xlsx');
GordonName={'auditory network';'cingulo opercular network';...
    'cingulo parietal network';'default network';...
    'dorsal attention network';'fronto parietal network';...
    'none network';'retrosplenial temporal network';...
    'sensorimotor hand network';'sensorimotor mouth network';...
    'salience network';'ventral attention network';'visual network'};
asegName={'left cerebellum cortex';'left thalamus proper';...
    'left caudate';'left putamen';'left pallidum';'brain stem';...
    'left hippocampus';'left amygdala';'left accumbens area';...
    'left ventraldc';'right cerebellum cortex';'right thalamus proper';...
    'right caudate';'right putamen';'right pallidum';'right hippocampus';...
    'right amygdala';'right accumbens area';'right ventraldc'};
NetName=[GordonName;asegName];
[beta_NetMatrix,~] = s_GetAdjMatrix(NetName,Res_RSFNC(Res_RSFNC.FDR_pvals<0.05,:));
GordonName={'AuN';'CON';...
    'CPN';'DMN';...
    'DAN';'FPN';...
    'none';'RsTN';...
    'SmHN';'SmMN';...
    'SN';'VAN';'ViN'};
asegName={'cerebellum_L';'thalamus_L';...
    'caudate_L';'putamen_L';'pallidum_L';'brain stem';...
    'hippocampus_L';'amygdala_L';'accumbens_L';...
    'ventraldc_L';'cerebellum_R';'thalamus_R';...
    'caudate_R';'putamen_R';'pallidum_R';'hippocampus_R';...
    'amygdala_R';'accumbens_R';'ventraldc_R'};
NetName=[GordonName;asegName];
% extract the cortical network and cortical-subcortical network
FlagNet=contains(NetName,GordonName);
FlagSC=contains(NetName,asegName);
save ../Res_3_IntermediateData/RSFC_Adjusted_AdjMat.mat beta_NetMatrix NetName FlagNet FlagSC GordonName asegName
% Plot settings
OutputFileName = '../Res_2_Results/Figure_S11_A_Left';
PlotSpec.FigStyle = 'Triu';
PlotSpec.DisplayOpt = 'on';
PlotSpec.XVarNames = GordonName;
PlotSpec.YVarNames = GordonName;
PlotSpec.TextColor = 'k';
PlotSpec.Colorbar = 'on';
PlotSpec.TickFontSize = 16;
s_MatrixPlot(beta_NetMatrix(FlagNet,FlagNet),OutputFileName,PlotSpec)

OutputFileName = '../Res_2_Results/Figure_S11_A_Right';
PlotSpec.FigStyle = 'Auto';
PlotSpec.XVarNames = asegName;
PlotSpec.YVarNames = GordonName;
s_MatrixPlot(beta_NetMatrix(FlagNet,FlagSC),OutputFileName,PlotSpec)
%% Figure S11 B
GordonName={'auditory network';'cingulo opercular network';...
    'cingulo parietal network';'default network';...
    'dorsal attention network';'fronto parietal network';...
    'none network';'retrosplenial temporal network';...
    'sensorimotor hand network';'sensorimotor mouth network';...
    'salience network';'ventral attention network';'visual network'};
asegName={'left cerebellum cortex';'left thalamus proper';...
    'left caudate';'left putamen';'left pallidum';'brain stem';...
    'left hippocampus';'left amygdala';'left accumbens area';...
    'left ventraldc';'right cerebellum cortex';'right thalamus proper';...
    'right caudate';'right putamen';'right pallidum';'right hippocampus';...
    'right amygdala';'right accumbens area';'right ventraldc'};
NetName=[GordonName;asegName];
[~,beta_NetMatrix] = s_GetAdjMatrix(NetName,Res_RSFNC(Res_RSFNC.noAdj_FDR_pvals<0.05,:));
GordonName={'AuN';'CON';...
    'CPN';'DMN';...
    'DAN';'FPN';...
    'none';'RsTN';...
    'SmHN';'SmMN';...
    'SN';'VAN';'ViN'};
asegName={'cerebellum_L';'thalamus_L';...
    'caudate_L';'putamen_L';'pallidum_L';'brain stem';...
    'hippocampus_L';'amygdala_L';'accumbens_L';...
    'ventraldc_L';'cerebellum_R';'thalamus_R';...
    'caudate_R';'putamen_R';'pallidum_R';'hippocampus_R';...
    'amygdala_R';'accumbens_R';'ventraldc_R'};
NetName=[GordonName;asegName];
save ../Res_3_IntermediateData/RSFC_NonAdjusted_AdjMat.mat beta_NetMatrix NetName FlagNet FlagSC GordonName asegName

OutputFileName = '../Res_2_Results/Figure_S11_B_Left';
PlotSpec.FigStyle = 'Triu';
PlotSpec.DisplayOpt = 'on';
PlotSpec.XVarNames = GordonName;
PlotSpec.YVarNames = GordonName;
PlotSpec.TextColor = 'k';
PlotSpec.Colorbar = 'on';
PlotSpec.TickFontSize = 16;
s_MatrixPlot(beta_NetMatrix(FlagNet,FlagNet),OutputFileName,PlotSpec)

OutputFileName = '../Res_2_Results/Figure_S11_B_Right';
PlotSpec.FigStyle = 'Auto';
PlotSpec.XVarNames = asegName;
PlotSpec.YVarNames = GordonName;
s_MatrixPlot(beta_NetMatrix(FlagNet,FlagSC),OutputFileName,PlotSpec)