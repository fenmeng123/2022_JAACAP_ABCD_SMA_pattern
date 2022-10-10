clc
clear
diary ../Res_1_Logs/Log_cluster_2.txt
load ..\Res_3_IntermediateData\ABCD4.0_Merged_STQ.mat
%% K-means for ABCD 1-year follow-up wave
STQ = STQ(strcmp(STQ.eventname,'1_year_follow_up_y_arm_1'),:);
fprintf('1-year FU STQ (before cleaning) N=%d\n',size(STQ,1));
[Miss_Flag,~] = miss_case(STQ{:,7:end});
screen = STQ{~Miss_Flag,7:end};
fprintf('1-year FU STQ (after cleaning) N=%d\n',size(screen,1));
% K-means settings
TargetClusterNum=1:8;
Result=ml_kmeans_eva(screen,TargetClusterNum,'Replicates',500,'Display','final');
fprintf('Cluster index from K-means function:\n')
tabulate(Result(2).Index)
save ..\Res_3_IntermediateData\ABCD4.0_Screen_Kmeans_y1.mat Result
diary off