%% 500 times replications with 70% proporation sampling
load ../Res_3_IntermediateData/HCPD_ScreenUse.mat ScreenUse
screen=ScreenUse{:,6:19};
RepTimes=500;
Proporation=0.7;
RepAllCluster=Screen_kmeans_Rep(screen,RepTimes,Proporation);
save('../Res_3_IntermediateData/Kmeans_AllRep500_0.7.mat','RepAllCluster','-v7.3')

%% 500 times replications with 60% proporation sampling
clearvars -EXCEPT screen
% screen=ScreenUse{:,6:19};
RepTimes=500;
Proporation=0.6;
RepAllCluster=Screen_kmeans_Rep(screen,RepTimes,Proporation);

save('../Res_3_IntermediateData/Kmeans_AllRep500_0.6.mat','RepAllCluster','-v7.3')
%% 80% sample
clearvars -EXCEPT screen
% screen=ScreenUse{:,6:19};
RepTimes=500;
Proporation=0.8;
RepAllCluster=Screen_kmeans_Rep(screen,RepTimes,Proporation);

save('../Res_3_IntermediateData/Kmeans_AllRep500_0.8.mat','RepAllCluster','-v7.3')
%% 90% sample
clearvars -EXCEPT screen
RepTimes=500;
Proporation=0.9;
RepAllCluster=Screen_kmeans_Rep(screen,RepTimes,Proporation);

save('../Res_3_IntermediateData/Kmeans_AllRep500_0.9.mat','RepAllCluster','-v7.3')
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

