load ../Res_3_IntermediateData/Res_Kmeans11103_year1.mat D
year1_screen=D{:,28:41};

clearvars -EXCEPT year1_screen
RepTimes=500;
Proporation=0.8;
RepAllCluster=Screen_kmeans_Rep(year1_screen,RepTimes,Proporation);

save('../Res_3_IntermediateData/Res_AllRep500_y1_11103_0.8.mat','RepAllCluster','-v7.3')

clearvars -EXCEPT year1_screen
RepTimes=500;
Proporation=0.6;
RepAllCluster=Screen_kmeans_Rep(year1_screen,RepTimes,Proporation);

save('../Res_3_IntermediateData/Res_AllRep500_y1_11103_0.6.mat','RepAllCluster','-v7.3')

clearvars -EXCEPT year1_screen
RepTimes=500;
Proporation=0.7;
RepAllCluster=Screen_kmeans_Rep(year1_screen,RepTimes,Proporation);

save('../Res_3_IntermediateData/Res_AllRep500_y1_11103_0.7.mat','RepAllCluster','-v7.3')

clearvars -EXCEPT year1_screen
RepTimes=500;
Proporation=0.9;
RepAllCluster=Screen_kmeans_Rep(year1_screen,RepTimes,Proporation);

save('../Res_3_IntermediateData/Res_AllRep500_y1_11103_0.9.mat','RepAllCluster','-v7.3')

function RepAllCluster=Screen_kmeans_Rep(screen,RepTimes,Proporation)
for i=1:RepTimes
    RepIdx=randsample(size(screen,1),round(size(screen,1)*Proporation));
    RepSample=screen(RepIdx,:);
    Result=ml_kmeans_eva(RepSample,2:4,'Replicates',500);
    RepAllCluster(i).res=Result;
    RepAllCluster(i).RepIdx=RepIdx;
end
end