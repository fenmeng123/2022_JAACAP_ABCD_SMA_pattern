load ../Res_3_IntermediateData/Data_Screen_others.mat Screen_baseline
screen=Screen_baseline{:,10:23};
% screen=Data{:,Screen_VarFlag};
%% K-means Replications with different sample proportion 90%
clearvars -EXCEPT screen
RepTimes=500;
Proporation=0.9;
RepAllCluster=Screen_kmeans_Rep(screen,RepTimes,Proporation);
save ../Res_3_IntermediateData/Res_AllRep500_11817_0.9.mat RepAllCluster -v7.3
%% K-means Replications with different sample proportion 80%
clearvars -EXCEPT screen
RepTimes=500;
Proporation=0.8;
RepAllCluster=Screen_kmeans_Rep(screen,RepTimes,Proporation);
save ../Res_3_IntermediateData/Res_AllRep500_11817_0.8.mat RepAllCluster -v7.3
%% K-means Replications with different sample proportion 70%
clearvars -EXCEPT screen
RepTimes=500;
Proporation=0.7;
RepAllCluster=Screen_kmeans_Rep(screen,RepTimes,Proporation);
save ../Res_3_IntermediateData/Res_AllRep500_11817_0.7.mat RepAllCluster -v7.3
%% K-means Replications with different sample proportion 60%
clearvars -EXCEPT screen
RepTimes=500;
Proporation=0.6;
RepAllCluster=Screen_kmeans_Rep(screen,RepTimes,Proporation);

save ../Res_3_IntermediateData/Res_AllRep500_11817_0.6.mat RepAllCluster -v7.3
%% subfunctions
function RepAllCluster=Screen_kmeans_Rep(screen,RepTimes,Proporation)
for i=1:RepTimes
    RepIdx=randsample(size(screen,1),round(size(screen,1)*Proporation));
    RepSample=screen(RepIdx,:);
    Result=ml_kmeans_eva(RepSample,2:4,'Replicates',500);
    RepAllCluster(i).res=Result;
    RepAllCluster(i).RepIdx=RepIdx;
end
end
