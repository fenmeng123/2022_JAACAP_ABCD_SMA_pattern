clc
clear

%% Figure S17 A Left/Middle/Right
clear
load ../Res_3_IntermediateData/RSFC_Longitudinal_GroupMainEff.mat
pos_NetMatrix = beta_NetMatrix .* (beta_NetMatrix>0);
neg_NetMatrix = beta_NetMatrix .* (beta_NetMatrix<0);
h=figure();
s_CircularPlot(beta_NetMatrix,NetName,'../Res_2_Results/Figure_S17_A_Left',spring(length(beta_NetMatrix)))
close(h)

h=figure();
s_CircularPlot(pos_NetMatrix,NetName,'../Res_2_Results/Figure_S17_A_Middle',hot(length(pos_NetMatrix)))
close(h)

h=figure();
s_CircularPlot(neg_NetMatrix,NetName,'../Res_2_Results/Figure_S17_A_Right',cool(length(neg_NetMatrix)))
close(h)
%% Check the consistent between Cross-sectional and Longitudinal Results
% for Figure S17 B
clear
load ../Res_3_IntermediateData/RSFC_Longitudinal_GroupMainEff.mat Res_RSFNC beta_NetMatrix NetName
Long_NetMat = beta_NetMatrix;
load ../Res_3_IntermediateData/RSFC_Adjusted_AdjMat.mat
Cross_NetMat = beta_NetMatrix;
clearvars beta_NetMatrix
Overlap_NetMat = logical(Long_NetMat) + logical(Cross_NetMat);
Overlap_NetMat_Tri = triu(Overlap_NetMat);
OverlapRatio = sum( Overlap_NetMat_Tri==2 ,'all') / ( sum(Overlap_NetMat_Tri==1 ,'all') + sum(Overlap_NetMat_Tri==2 ,'all') );
fprintf('Overlap ratio = %.2f%% Overlap RSFC Number = %d\n',OverlapRatio*100,sum( Overlap_NetMat_Tri==2 ,'all'))
h=figure();
s_CircularPlot(double(Overlap_NetMat),NetName,'../Res_2_Results/Figure_S17_B',summer(length(Overlap_NetMat)))
close(h)
%% plot the circular graph using standardized beta about RSFNC
% for Figure 3 D
clear
Std_GroupMainEff = readtable('../Res_2_Results/Table_S15.xlsx');
load ../Res_3_IntermediateData/ABCD_RSFNC_VarName_NodeName.mat
Std_GroupMainEff = innerjoin(Std_GroupMainEff,RSFNC_VarName_Node,'LeftKeys','Y_Name','RightKeys','RSFC_Name');
% Extract the standardized beta of group main effect
Std_GroupMainEff = Std_GroupMainEff(strcmp(Std_GroupMainEff.Name,'Idx1'),:);
Std_GroupMainEff.Estimate = Std_GroupMainEff.std_beta_num;
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
beta_NetMatrix = s_GetAdjMatrix_Longitudinal(NetName,Std_GroupMainEff);
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
save ../Res_3_IntermediateData/RSFC_Longitudinal_GroupMainEff_StdBeta.mat Std_GroupMainEff beta_NetMatrix NetName

pos_NetMatrix = beta_NetMatrix .* (beta_NetMatrix>0);
neg_NetMatrix = beta_NetMatrix .* (beta_NetMatrix<0);

h=figure();
s_CircularPlot(beta_NetMatrix,NetName,'../Res_2_Results/Figure_S17_A_Left',spring(length(beta_NetMatrix)))
close(h)

h=figure();
s_CircularPlot(pos_NetMatrix,NetName,'../Res_2_Results/Figure_S17_A_Middle',hot(length(pos_NetMatrix)))
close(h)

h=figure();
s_CircularPlot(neg_NetMatrix,NetName,'../Res_2_Results/Figure_S17_A_Right',cool(length(neg_NetMatrix)))
close(h)

