
%% Figure S12 A
% Circular plot for adjusted RSFC group difference results
load ../Res_3_IntermediateData/RSFC_Adjusted_AdjMat.mat beta_NetMatrix NetName FlagNet FlagSC GordonName asegName

pos_NetMatrix = beta_NetMatrix .* (beta_NetMatrix>0);
neg_NetMatrix = beta_NetMatrix .* (beta_NetMatrix<0);

h=figure();
s_CircularPlot(beta_NetMatrix,NetName,'../Res_2_Results/Figure_S12_A_Left',spring(length(beta_NetMatrix)))
close(h);
h=figure();
s_CircularPlot(pos_NetMatrix,NetName,'../Res_2_Results/Figure_S12_A_Middle',hot(length(pos_NetMatrix)))
close(h);
h=figure();
s_CircularPlot(neg_NetMatrix,NetName,'../Res_2_Results/Figure_S12_A_Right',cool(length(neg_NetMatrix)))
close(h);
%% Figure S12 B
load ../Res_3_IntermediateData/RSFC_NonAdjusted_AdjMat.mat beta_NetMatrix NetName FlagNet FlagSC GordonName asegName
pos_NetMatrix = beta_NetMatrix .* (beta_NetMatrix>0);
neg_NetMatrix = beta_NetMatrix .* (beta_NetMatrix<0);

h=figure();
s_CircularPlot(beta_NetMatrix,NetName,'../Res_2_Results/Figure_S12_B_Left',spring(length(beta_NetMatrix)))
close(h);
h=figure();
s_CircularPlot(pos_NetMatrix,NetName,'../Res_2_Results/Figure_S12_B_Middle',hot(length(pos_NetMatrix)))
close(h);
h=figure();
s_CircularPlot(neg_NetMatrix,NetName,'../Res_2_Results/Figure_S12_B_Right',cool(length(neg_NetMatrix)))
close(h);
%% Figure S12 C
clear
load ../Res_3_IntermediateData/RSFC_Adjusted_AdjMat.mat beta_NetMatrix NetName FlagNet FlagSC GordonName asegName
NodeName = NetName;
EffectSizeMatSym = (beta_NetMatrix + beta_NetMatrix');
EffectSizeMatSym = EffectSizeMatSym./(diag(diag(ones(length(NodeName))))+ones(length(NodeName)));
% binarizing network
Full_G = graph(logical(EffectSizeMatSym),NodeName);
Neg_G = graph(logical(EffectSizeMatSym.*(EffectSizeMatSym<0)),NodeName);
Pos_G = graph(logical(EffectSizeMatSym.*(EffectSizeMatSym>0)),NodeName);
% calculate the node degree
Degree_T_All = s_GetDegree(Full_G);
Degree_T_Neg = s_GetDegree(Neg_G);
Degree_T_Pos = s_GetDegree(Pos_G);
h = s_PlotDegreeBar(Degree_T_All,Degree_T_Neg,Degree_T_Pos,'../Res_2_Results/Figure_S12_C');
close(gcf)
%% Figure S12 D
clear
load ../Res_3_IntermediateData/RSFC_NonAdjusted_AdjMat.mat beta_NetMatrix NetName FlagNet FlagSC GordonName asegName
NodeName = NetName;
EffectSizeMatSym = (beta_NetMatrix + beta_NetMatrix');
EffectSizeMatSym = EffectSizeMatSym./(diag(diag(ones(length(NodeName))))+ones(length(NodeName)));
Full_G = graph(logical(EffectSizeMatSym),NodeName);
Neg_G = graph(logical(EffectSizeMatSym.*(EffectSizeMatSym<0)),NodeName);
Pos_G = graph(logical(EffectSizeMatSym.*(EffectSizeMatSym>0)),NodeName);
Degree_T_All = s_GetDegree(Full_G);
Degree_T_Neg = s_GetDegree(Neg_G);
Degree_T_Pos = s_GetDegree(Pos_G);
h = s_PlotDegreeBar(Degree_T_All,Degree_T_Neg,Degree_T_Pos,'../Res_2_Results/Figure_S12_D');
close(gcf)




