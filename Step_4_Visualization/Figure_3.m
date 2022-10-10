clc
clear
load ../Res_2_Results/Res_Longitudinal_traits.mat T_traits
load ../Res_2_Results/Res_Longitudinal_MH.mat T_MH
%% Figure 3A Left Panel (BIS\BAS\UPPS)
% the order of cell elements is consistent with the model settings in
% stat_1_Neurocognition.m
SimEffRes = readtable('../Res_2_Results/Table_S12.xlsx');
DV_VarName = {'UPPS_Sum','BIS_Sum','BAS_Sum'};

h=figure();
T_SubG = s_ExtractLongitudinalCell(T_traits,DV_VarName);
subplot(1,3,1)
s_BarPlotWithErrorLine(T_SubG.stats{2})
title('BIS Sum Score')
ylabel('z-scores')
subplot(1,3,2)
s_BarPlotWithErrorLine(T_SubG.stats{3})
title('BAS Sum Score')
subplot(1,3,3)
s_BarPlotWithErrorLine(T_SubG.stats{1})
title('UPPS Sum Score')
set(gcf,'Position',[312         400        1073         499])

h_bar1 = h.Children(1).Children(3);
h_bar2 = h.Children(1).Children(4);
s_drawSigLine_2wave(h,h_bar1,h_bar2,h.Children(1),SimEffRes)
h_bar1 = h.Children(2).Children(3);
h_bar2 = h.Children(2).Children(4);
s_drawSigLine_2wave(h,h_bar1,h_bar2,h.Children(2),SimEffRes)
h_bar1 = h.Children(3).Children(3);
h_bar2 = h.Children(3).Children(4);
s_drawSigLine_2wave(h,h_bar1,h_bar2,h.Children(3),SimEffRes)

print('../Res_2_Results/Figure3A_Left','-dtiffn','-r300')
print('../Res_2_Results/Figure3A_Left','-dsvg')

close(h)
%% Figure 3A Left Panel (CBCL\PPS)
% the order of cell elements is consistent with the model settings in
% stat_2_MentalHealth.m
DV_VarName = {'CBCL_syn_totprob_t','PPS_Severity_Sum'};
h=figure();
T_SubG = s_ExtractLongitudinalCell(T_MH,DV_VarName);
subplot(1,2,1)
s_BarPlotWithErrorLine(T_SubG.stats{1})
title('CBCL Total Problem Scale Score')
ylabel('z-scores')
subplot(1,2,2)
s_BarPlotWithErrorLine(T_SubG.stats{2})
title('PPS Severity Score')
set(gcf,'Position',[312         400        1073         499])

axes = h.Children(1);
h_bar1 = axes.Children(4);
h_bar2 = axes.Children(3);
s_drawSigLine_3wave(axes,h_bar1,h_bar2,SimEffRes)
axes = h.Children(2);
h_bar1 = axes.Children(4);
h_bar2 = axes.Children(3);
s_drawSigLine_3wave(axes,h_bar1,h_bar2,SimEffRes)

print('../Res_2_Results/Figure3A_Right','-dtiffn','-r300')
print('../Res_2_Results/Figure3A_Right','-dsvg')
close(h)
%% Figure 3B
load ../Res_3_IntermediateData/ABCD4.0_Screen_Kmeans_y0.mat Result
Result_y0 = Result;
load ../Res_3_IntermediateData/ABCD4.0_Screen_Kmeans_y1.mat Result
Result_y1 = Result;
 X_Labels={'TV or movies-Weekday','Videos-Weekday','Video Game-Weekday','Text Chat-Weekday','Social Network Site-Weekday','Video Chat-Weekday',...
    'TV or movies-Weekend','Videos-Weekend','Video Game-Weekend','Text Chat-Weekend','Social Network Site-Weekend','Video Chat-Weekend',...
    'Play Mature Game','View R-rated Movies'};
legends={'ABCD Baseline: SMA Subgroup 1','ABCD Baseline: SMA Subgroup 2','ABCD 1-year FU: SMA Subrgoup 1','ABCD 1-year FU: SMA Subgroup 2'};
clr=lines(2);clr=[clr [1 1]';clr [0.5 0.5]'];
% note that the group label did not match and I changed its order for y1
h=figure();
hold on
plot(Result_y0(2).Center(1,:)','Color',clr(1,:),'LineWidth',2);
plot(Result_y0(2).Center(2,:)','Color',clr(2,:),'LineWidth',2);
plot(Result_y1(2).Center(1,:)','Color',clr(3,:),'LineWidth',2);
plot(Result_y1(2).Center(2,:)','Color',clr(4,:),'LineWidth',2);
legend(legends,'NumColumns',2,'Location','north')
set(gca,'XTick',1:14)
set(gca,'YLim',[0 4])
set(gca,'YTick',0:1:4)
set(gca,'XTickLabel',X_Labels)
set(gca,'XTickLabelRotation',30);
set(gca,'YGrid','on')
ylabel('Screen Time Questionnaire: Item Score')
set(gcf,'Position',[418         404        1103         420])
print('../Res_2_Results/Figure3B','-dtiffn','-r300')
print('../Res_2_Results/Figure3B','-dsvg')
close(h)
%% Prepare data for Figure 3C
% clear
% load ../Res_3_IntermediateData/ABCD4.0_Screen_Kmeans_y0.mat Result
% Result_y0 = Result;
% load ../Res_3_IntermediateData/ABCD4.0_Screen_Kmeans_y1.mat Result
% Result_y1 = Result;
clearvars Result
load ../Res_3_IntermediateData/ABCD4.0_Merged_STQ.mat STQ
% generate Cluster index transition matrix
STQ_y0 = STQ(strcmp(STQ.eventname,'baseline_year_1_arm_1'),:);
STQ_y1 = STQ(strcmp(STQ.eventname,'1_year_follow_up_y_arm_1'),:);
STQ_y0.Idx_y0 = nan(size(STQ_y0,1),1);
STQ_y1.Idx_y1 = nan(size(STQ_y1,1),1);
[MissFlag_y0,~] = miss_case(STQ_y0{:,7:20});STQ_y0.Idx_y0(~MissFlag_y0) = Result_y0(2).Index;
[MissFlag_y1,~] = miss_case(STQ_y1{:,7:20});STQ_y1.Idx_y1(~MissFlag_y1) = Result_y1(2).Index;
STQ_y0 = removevars(STQ_y0,{'Var1','weekday_TV', 'weekday_Video','weekday_Game','weekday_Text',...
    'weekday_SocialNet','weekday_VideoChat','weekend_TV','weekend_Video',...
    'weekend_Game','weekend_Text','weekend_SocialNet','weekend_VideoChat',...
    'screen13_y','screen14_y'});
STQ_y1 = removevars(STQ_y1,{'Var1','weekday_TV', 'weekday_Video','weekday_Game','weekday_Text',...
    'weekday_SocialNet','weekday_VideoChat','weekend_TV','weekend_Video',...
    'weekend_Game','weekend_Text','weekend_SocialNet','weekend_VideoChat',...
    'screen13_y','screen14_y'});
STQ_Transit = outerjoin(STQ_y0,STQ_y1,'Keys',{'src_subject_id','sex'},'MergeKeys',true);
fprintf('Baseline cluster index:\n')
tabulate(STQ_Transit.Idx_y0)
fprintf('1-year FU cluster index:\n')
tabulate(STQ_Transit.Idx_y1)
% Notes:
% Cluster index 1 - SMA subgroup 2
% Cluster index 2 - SMA subgroup 1
STQ_Transit.TransitionLabel = STQ_Transit.Idx_y0 + STQ_Transit.Idx_y1;
% find those transit from SMA subgroup 2 to SMA subgroup 1
Flag_1to2 = STQ_Transit.TransitionLabel == 3 &...
    STQ_Transit.Idx_y0 == 1 &...
    STQ_Transit.Idx_y1 == 2;
STQ_Transit.TransitionLabel(Flag_1to2) = 5;
% find those transit from SMA subgroup 1 to SMA subgroup 2
Flag_2to1 = STQ_Transit.TransitionLabel == 3 &...
    STQ_Transit.Idx_y0 == 2 &...
    STQ_Transit.Idx_y1 == 1;
STQ_Transit.TransitionLabel(Flag_2to1) = 6;
% Rename the transition label
fprintf('4-Level Coding for SMA subgroup transition label:\n')
tabulate(num2str(STQ_Transit.TransitionLabel))
STQ_Transit.TrainsitionLabel_4level = ...
    categorical(replace(cellstr(num2str(STQ_Transit.TransitionLabel)),...
    {'2','4','5','6'},...
    {'Sustaining SMA SubG 2','Sustaning SMA SubG 1','SMA SubG 2 to 1','SMA SubG 1 to 2'}));
fprintf('4-Level Coding for Transition label (Renaming):\n')
tabulate(STQ_Transit.TrainsitionLabel_4level)

STQ_Transit.TrainsitionLabel_3level = ...
    categorical(replace(cellstr(num2str(STQ_Transit.TransitionLabel)),...
    {'2','4','5','6'},...
    {'Sustaining SMA SubG (1 or 2)','Sustaining SMA SubG (1 or 2)','SMA SubG 2 to 1','SMA SubG 1 to 2'}));
fprintf('3-Level Coding for Transition label (Renaming):\n')
tabulate(STQ_Transit.TrainsitionLabel_3level)
% save SMA Transition label
save ../Res_3_IntermediateData/ABCD4.0_Screen_y0y1_transition.mat STQ_Transit
%% Figure 3C
clear
load ../Res_3_IntermediateData/ABCD4.0_Screen_y0y1_transition.mat STQ_Transit
fprintf('Trainsition Matrix:\n')
tabulate(STQ_Transit.TrainsitionLabel_4level)
TransMat = nan(3,3);
TransCounts = tabulate(STQ_Transit.TrainsitionLabel_4level);
TransMat(1,1) = TransCounts{5,2};
TransMat(1,2) = TransCounts{2,2};
TransMat(2,1) = TransCounts{3,2};
TransMat(2,2) = TransCounts{4,2};
TransMat(3,:) = nansum(TransMat,1);
TransMat(:,3) = nansum(TransMat,2);
fprintf('Reconsturcted transition matrix:\n')
disp(TransMat)
fprintf('Percentage for transition matrix:\n')
disp(TransMat./TransMat(3,3))
h = heatmap(TransMat);
colorbar off
heatmapclrbar = h.Colormap;
h.CellLabelColor = [0.4 0.4 0.4];
h.CellLabelFormat = '%d';
h.FontSize=15;
h.XDisplayLabels = {'','',''};
h.YDisplayLabels = {'','',''};
h.GridVisible = 'off';
set(gcf,'Position',[413   250   752   713])
print('../Res_2_Results/Figure3C','-dtiffn','-r300')
print('../Res_2_Results/Figure3C','-dsvg')
close(gcf)
%% Figure 3D
% the barplot for estimated marginal means in longitudinally significant
% RSFNC
clear
load ../Res_3_IntermediateData/ABCD_RSFNC_VarName_NodeName.mat
SimEffRes = readtable('../Res_2_Results/Table_S16.xlsx');
SimEffRes = SimEffRes(SimEffRes.MeaningfulContrastFlag==1,:);
SimEffRes = SimEffRes(strcmp(SimEffRes.contrast,'Idx2Time1-Idx1Time1')|...
    strcmp(SimEffRes.contrast,'Idx2Time0-Idx1Time0'),:);
EmmFileList = dir('../Res_3_IntermediateData/rsfmri_*_EMM_R_means.doc');
EmmFileList = fullfile({EmmFileList.folder},{EmmFileList.name});
Res = cell(length(EmmFileList),1);
for i=1:length(EmmFileList)
   Res{i}  = s_ExtractEmmeansMean(EmmFileList{i});
   [~,filename,~] = fileparts(EmmFileList{i});
   Y_Name = strrep(filename,'_EMM_R_means','');
   Res{i}.Y_Name = repmat(cellstr(Y_Name),size(Res{i},1),1);
   Res{i} = innerjoin(Res{i},RSFNC_VarName_Node,'LeftKeys','Y_Name','RightKeys','RSFC_Name');
end
Res = vertcat(Res{:});
Res = movevars(Res,'Y_Name','Before','Idx');
Res = movevars(Res,'Node1','After','Y_Name');
Res = movevars(Res,'Node2','After','Node1');
Res = innerjoin(Res,SimEffRes(strcmp(SimEffRes.contrast,'Idx2Time1-Idx1Time1'),:),'Keys','Y_Name');
RSFC_Name = unique(Res.Y_Name);
for i=1:size(RSFC_Name,1)
    stats = Res(strcmp(Res.Y_Name,RSFC_Name{i}),:);
    h=figure();
    s_BarPlot_RSFNC(stats)
    title_text = strcat(stats.Node1(i), '-', stats.Node2(i));
    title_text = replace(title_text,...
        {'auditory network';'cingulo opercular network';...
    'cingulo parietal network';'default network';...
    'dorsal attention network';'fronto parietal network';...
    'none network';'retrosplenial temporal network';...
    'sensorimotor hand network';'sensorimotor mouth network';...
    'salience network';'ventral attention network';'visual network';...
    'left cerebellum cortex';'left thalamus proper';...
    'left caudate';'left putamen';'left pallidum';'brain stem';...
    'left hippocampus';'left amygdala';'left accumbens area';...
    'left ventraldc';'right cerebellum cortex';'right thalamus proper';...
    'right caudate';'right putamen';'right pallidum';'right hippocampus';...
    'right amygdala';'right accumbens area';'right ventraldc'},...
    {'AuN';'CON';...
    'CPN';'DMN';...
    'DAN';'FPN';...
    'none';'RsTN';...
    'SmHN';'SmMN';...
    'SN';'VAN';'ViN';...
    'Cerebellum_L';'Thalamus_L';...
    'Caudate_L';'Putamen_L';'Pallidum_L';'Brain stem';...
    'Hippocampus_L';'Amygdala_L';'Accumbens_L';...
    'Ventral DC_L';'Cerebellum_R';'Thalamus_R';...
    'Caudate_R';'Putamen_R';'Pallidum_R';'Hippocampus_R';...
    'Amygdala_R';'Accumbens_R';'Ventral DC_R'});
    if -stats.estimate(i) > 0
        title(title_text,'Color',[1.0000    0.1875         0])
    else
        title(title_text,'Color',[0.2118    0.7882    1.0000])
    end
    tmpRes = SimEffRes(strcmp(SimEffRes.Y_Name,RSFC_Name(i)),:);
    axes = h.Children(1);
    h_bar1 = axes.Children(4);
    h_bar2 = axes.Children(3);
    s_drawSigLine_2wave_RSFC_SingleAxes(axes,h_bar1,h_bar2,tmpRes)
    ylabel({'Functional Connection Strength';'(estimated marginal means)'})
    print(['../Res_2_Results/Figure3D_' title_text{1} ],'-dtiff','-r300')
    print(['../Res_2_Results/Figure3D_' title_text{1} ],'-dsvg')
    print(['../Res_2_Results/Figure3D_' title_text{1} ],'-dpdf')
    close(h)
end
legend({'Subgroup 1: Higher-frequency SMA','Subgroup 2: Lower-frequency SMA','Subgroup 1: Higher-frequency SMA','Subgroup 2: Lower-frequency SMA'},'NumColumns',4,'Location','southoutside')
print(['../Res_2_Results/Figure3D_legends' ],'-dtiff','-r300')
print(['../Res_2_Results/Figure3D_legends' ],'-dsvg')
print(['../Res_2_Results/Figure3D_legends' ],'-dpdf','-bestfit')
writetable(Res,'../Res_2_Results/Table_Fig3D.xlsx')