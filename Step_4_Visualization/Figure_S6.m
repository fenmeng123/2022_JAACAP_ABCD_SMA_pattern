clc
clear

Hierarchy =load('Res_HierarchicalCluster11817.mat');
Kmeans = load('../Res_Kmeans11817.mat');
LPA.Res = readtable('../R_Code/Screen_baseline_LPA_profile.xlsx');

Hierarchy.Centroid(1,:)=mean(Hierarchy.Screen_baseline{Hierarchy.idx==1,10:23});
Hierarchy.Centroid(2,:)=mean(Hierarchy.Screen_baseline{Hierarchy.idx==2,10:23});
Hierarchy.Centroid = sortrows(Hierarchy.Centroid,'descend');
LPA.Centroid(1,:)=LPA.Res.Estimate(strcmp(LPA.Res.Class,'1'))';
LPA.Centroid(2,:)=LPA.Res.Estimate(strcmp(LPA.Res.Class,'2'))';
LPA.Centroid = sortrows(LPA.Centroid,'descend');
AllCentroid = [Kmeans.Result(2).Center;Hierarchy.Centroid;LPA.Centroid];
%% plot figure

figure()
set(gcf,'Position',[418         404        1103         420])
myclr=lines(2);
plot(AllCentroid(1,:),'Color',[myclr(2,:) 1],'LineWidth',2,'Marker','.','MarkerSize',15);
hold on
plot(AllCentroid(3,:),'Color',[myclr(2,:) 0.75],'LineWidth',2,'Marker','x','MarkerSize',10,'MarkerEdgeColor',1-0.75+myclr(2,:).*0.75);
plot(AllCentroid(5,:),'Color',[myclr(2,:) 0.5],'LineWidth',2,'Marker','d','MarkerSize',6,'MarkerEdgeColor',1-0.5+myclr(2,:).*0.5);
plot(AllCentroid(2,:),'Color',[myclr(1,:) 1],'LineWidth',2,'Marker','.','MarkerSize',15);
plot(AllCentroid(4,:),'Color',[myclr(1,:) 0.75],'LineWidth',2,'Marker','x','MarkerSize',10,'MarkerEdgeColor',1-0.75+myclr(1,:).*0.75);
plot(AllCentroid(6,:),'Color',[myclr(1,:) 0.5],'LineWidth',2,'Marker','d','MarkerSize',6,'MarkerEdgeColor',1-0.5+myclr(1,:).*0.5);
hold off
X_Labels={'TV or movies-Weekday','Videos-Weekday','Gaming-Weekday','Texting-Weekday','SocialNetworking-Weekday','VideoChat-Weekday',...
    'TV or movies-Weekend','Videos-Weekend','Gaming-Weekend','Texting-Weekend','SocialNetworking-Weekend','VideoChat-Weekend',...
    'Mature gaming','R-rated movies'};
set(gca,'XTick',1:14)
set(gca,'XTickLabel',X_Labels)
set(gca,'XTickLabelRotation',30);
set(gca,'YTick',0:4)
set(gca,'YGrid','on')
ylabel('Screen Use Time (Item Score)')
legend({'K-means Subgroup 1','Hierarchical Subgroup1',...
    'LPA Subgroup 1','K-means Subgroup 2',...
    'Hierarchical Subgroup 2','LPA Subgroup 2'},...
    'NumColumns',2,...
    'Location','best')
box off
print('.\CompMethod_Centroid.tiff','-dtiffn','-r300')
%%
figure()
xvalues={'K-means Subgroup 1','K-means Subgroup 2',...
    'Hierarchical Subgroup1','Hierarchical Subgroup 2',...
    'LPA Subgroup 1','LPA Subgroup 2'};
heatmap(xvalues,xvalues,squareform(pdist(AllCentroid)))
colormap(flipud(jet))
print('.\CompMethod_SQD.tiff','-dtiffn','-r300')

