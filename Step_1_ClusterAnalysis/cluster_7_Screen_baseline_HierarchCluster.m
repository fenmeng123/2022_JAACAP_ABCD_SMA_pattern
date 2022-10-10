clc
clear

load ../Res_3_IntermediateData/Data_Screen_others.mat Screen_baseline
screen=Screen_baseline{:,10:23};

idx = clusterdata(screen,'Criterion','distance','maxclust',2,'linkage','ward');
tabulate(idx)
save ../Res_3_IntermediateData/Res_HierarchicalCluster11817.mat idx Screen_baseline
CHI = evalclusters(screen,'linkage','CalinskiHarabasz','KList',[2:8]);
DBI = evalclusters(screen,'linkage','DaviesBouldin','KList',[2:8]);
SH = evalclusters(screen,'linkage','silhouette','KList',[2:8]);
%% plot figure cluster evaluation
figure()
subplot(1,3,1)
plot(DBI.InspectedK,DBI.CriterionValues,'.-','MarkerSize',13)
title('Davies-Bouldin Index')
set(gca,'XTick',2:8)
set(gca,'XGrid','on')
xlabel('Cluster Number')
subplot(1,3,2)
plot(CHI.InspectedK,CHI.CriterionValues,'.-','MarkerSize',13)
title('Calinski-Harabasz Index')
set(gca,'XGrid','on')
set(gca,'XTick',2:8)
xlabel('Cluster Number')
subplot(1,3,3)
plot(SH.InspectedK,SH.CriterionValues,'.-','MarkerSize',13)
title('Silhouette Coef')
set(gca,'XGrid','on')
set(gca,'XTick',2:8)
xlabel('Cluster Number')
print('../Res_2_Result/HirerachicalClusterEva.tiff','-dtiffn','-r300')
%% plot centroid
figure()
plot(mean(screen(idx==1,:)))
hold on
plot(mean(screen(idx==2,:)))
hold off
X_Labels={'TV or movies-Weekday','Videos-Weekday','Gaming-Weekday','Texting-Weekday','SocialNetworking-Weekday','VideoChat-Weekday',...
    'TV or movies-Weekend','Videos-Weekend','Gaming-Weekend','Texting-Weekend','SocialNetworking-Weekend','VideoChat-Weekend',...
    'Mature gaming','R-rated movies'};
set(gca,'XTick',1:14)
set(gca,'XTickLabel',X_Labels)
set(gca,'XTickLabelRotation',30);
set(gca,'YLim',[0 4]);
set(gca,'YTick',0:4)
set(gca,'YGrid','on')
ylabel('Screen Use Time (Item Score)')
% legend('Subgroup 1: frequent screen use','SubGroup 2: infrequent screen use')
set(gcf,'Position',[418         404        1103         420])
print('../Res_2_Result/HirerachicalClusterCentroid.tiff','-dtiffn','-r300')
