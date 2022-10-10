clc
clear
diary ../Res_1_Logs/Log_cluster_1.txt
STQ = readtable('..\Res_3_IntermediateData\ABCD4.0_Merged_STQ.csv');
save ..\Res_3_IntermediateData\ABCD4.0_Merged_STQ.mat STQ
%% K-means clustering for ABCD baseline wave
% Extrace baseline wave data
STQ = STQ(strcmp(STQ.eventname,'baseline_year_1_arm_1'),:);
fprintf('Baseline STQ (before cleaning) N=%d\n',size(STQ,1));
[Miss_Flag,~] = miss_case(STQ{:,7:end});
TargetClusterNum=1:8;
screen = STQ{~Miss_Flag,7:end};
fprintf('Baseline STQ (after cleaning) N=%d\n',size(screen,1));
Result=ml_kmeans_eva(screen,TargetClusterNum,'Replicates',500,'Display','final');
save ..\Res_3_IntermediateData\ABCD4.0_Screen_Kmeans_y0.mat Result
STQ.Idx = nan(size(STQ,1),1);
STQ.Idx(~Miss_Flag) = Result(2).Index;
save ..\Res_3_IntermediateData\ABCD4.0_Screen_Cluster_y0.mat STQ

diary off