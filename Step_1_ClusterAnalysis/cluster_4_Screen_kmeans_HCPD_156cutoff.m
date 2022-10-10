clc
clear

%% age smaller or equal to 156 months
load ../Res_3_IntermediateData/HCPD_ScreenUse.mat ScreenUse

age=str2double(ScreenUse.interview_age);
TargetClusterNum=1:8;
Flag=age<=156;
fprintf('# %d subjects age <= 156 months \n',sum(Flag))
ScreenUse=ScreenUse(Flag,:);
screen=ScreenUse{:,6:19};

ResultYounger=ml_kmeans_eva(screen,TargetClusterNum,'Replicates',500);
[DBI,CHI,SH]=Plot_ClusterIndex(ResultYounger,TargetClusterNum);
print('../Res_2_Result/HCPD_Younger_ClusterIndex.tiff','-dtiffn','-r300')

PlotParallelWithSD(ResultYounger,screen)
set(gcf,'Position',[418         404        1103         420])
print('../Res_2_Result/HCPD_Younger_Centroid.tiff','-dtiffn','-r300')


%% %% age larger than 156 months
load ../Res_3_IntermediateData/HCPD_ScreenUse.mat ScreenUse
age=str2double(ScreenUse.interview_age);

TargetClusterNum=1:8;
Flag=age>156;
fprintf('# %d subjects age > 156 months \n',sum(Flag))
ScreenUse=ScreenUse(Flag,:);
screen=ScreenUse{:,6:19};
ResultOlder=ml_kmeans_eva(screen,TargetClusterNum,'Replicates',500);
[DBI,CHI,SH]=Plot_ClusterIndex(ResultOlder,TargetClusterNum);
print('../Res_2_Result/HCPD_Older_ClusterIndex.tiff','-dtiffn','-r300')
PlotParallelWithSD(ResultOlder,screen)
set(gcf,'Position',[418         404        1103         420])
print('../Res_2_Result/HCPD_Older_Centroid.tiff','-dtiffn','-r300')

save ../Res_3_IntermediateData/Kmeans_allHCPD_156cutoff.mat ResultYounger ResultOlder
%% comparison with ABCD
clearvars
load ../Res_3_IntermediateData/Kmeans_allHCPD_156cutoff.mat
ABCD=load('Res_Kmeans11817.mat');

clr=lines(6);

figure()
hold on
plot(ABCD.Result(2).Center(1,:)','LineWidth',2,'Color',clr(2,:))
plot(ABCD.Result(2).Center(2,:)','LineWidth',2,'Color',clr(1,:))
plot(ResultYounger(2).Center(1,:)','LineWidth',2,'Color',[clr(3,:) 0.5])
plot(ResultYounger(2).Center(2,:)','LineWidth',2,'Color',[clr(4,:) 0.5])


plot(ResultOlder(2).Center(1,:)','LineWidth',2,'Color',[clr(5,:) 0.5])
plot(ResultOlder(2).Center(2,:)','LineWidth',2,'Color',[clr(6,:) 0.5])
legend({'ABCD Subgroup1 (frequent using)','ABCD Subgroup 2 (infrequent using)','HCPD younger Subgroup 1','HCPD younger Subgroup 2','HCPD older Subgroup 1','HCPD older Subgroup 2'},...
    'NumColumns',3,'Location','best')
X_Labels={'TV or movies-Weekday','Watch Videos-Weekday','Gaming-Weekday','Texting-Weekday','SocialNetworking-Weekday','VideoChat-Weekday',...
    'TV or movies-Weekend','Watch Videos-Weekend','Gaming-Weekend','Texting-Weekend','SocialNetworking-Weekend','VideoChat-Weekend',...
    'Mature gaming','R-rated movies'};
set(gca,'XTick',1:14)
set(gca,'XTickLabel',X_Labels)
set(gca,'XTickLabelRotation',30);
set(gca,'YGrid','on')
set(gca,'YLim',[0 4])
set(gcf,'Position',[418         404        1103         420])
ylabel('Screen Use Time (Item Score)')
print('.\Figure\HCPD_YO_ABCD_Centroid.tiff','-dtiffn','-r300')

figure()
CenterMat=[ABCD.Result(2).Center' ResultYounger(2).Center' ResultOlder(2).Center'];
disp(CenterMat)
% R_Mat=corr(CenterMat);
D_Mat=squareform(pdist(CenterMat'));
labels={'ABCD Subgroup1','ABCD Subgroup 2','HCPD younger Subgroup 1','HCPD younger Subgroup 2','HCPD older Subgroup 1','HCPD older Subgroup 2'};
heatmap(labels,labels,D_Mat)
% set(gca,'XTickLabelRotation',15);
colormap(flipud(jet))
print('../Res_2_Result/HCPD_YO_ABCD_PairSQD.tiff','-dtiffn','-r300')

%% re-clustering with k=4
load ../Res_3_IntermediateData/HCPD_ScreenUse.mat ScreenUse
screen=ScreenUse{:,6:19};
ResultK4=ml_kmeans_eva(screen,4,'Replicates',500);
save ../Res_3_IntermediateData/K4_allHCPD.mat ResultK4
%% age in 4 subgroup
clearvars
load ../Res_3_IntermediateData/K4_allHCPD.mat
load ../Res_3_IntermediateData/Kmeans_allHCPD_156cutoff.mat
load ../Res_3_IntermediateData/HCPD_ScreenUse.mat ScreenUse

age=str2double(ScreenUse.interview_age);
fprintf('Subgroup 1 proporation: %d (%.4f) ; Age in Subgroup 1 with K=4 \n Min:%d Max:%d Mean:%.2f SD:%.2f\n',...
    sum(ResultK4.Index==3),mean(ResultK4.Index==3),min(age(ResultK4.Index==3)),...
    max(age(ResultK4.Index==3)),mean(age(ResultK4.Index==3)),std(age(ResultK4.Index==3)));
fprintf('Subgroup 2 proporation: %d (%.4f) ; Age in Subgroup 2 with K=4 \n Min:%d Max:%d Mean:%.2f SD:%.2f\n',...
    sum(ResultK4.Index==1),mean(ResultK4.Index==1),min(age(ResultK4.Index==1)),...
    max(age(ResultK4.Index==1)),mean(age(ResultK4.Index==1)),std(age(ResultK4.Index==1)));
fprintf('Subgroup 3 proporation: %d (%.4f) ; Age in Subgroup 3 with K=4 \n Min:%d Max:%d Mean:%.2f SD:%.2f\n',...
    sum(ResultK4.Index==2),mean(ResultK4.Index==2),min(age(ResultK4.Index==2)),...
    max(age(ResultK4.Index==2)),mean(age(ResultK4.Index==2)),std(age(ResultK4.Index==2)));
fprintf('Subgroup 4 proporation: %d (%.4f) ; Age in Subgroup 4 with K=4 \n Min:%d Max:%d Mean:%.2f SD:%.2f\n',...
    sum(ResultK4.Index==4),mean(ResultK4.Index==4),min(age(ResultK4.Index==4)),...
    max(age(ResultK4.Index==4)),mean(age(ResultK4.Index==4)),std(age(ResultK4.Index==4)));
fprintf('Proporation of age <= 156 months in Subgroup 1: %.4f; age > 156 months: %.4f\n',...
    mean(age(ResultK4.Index==3)<=156),mean(age(ResultK4.Index==3)>156))
fprintf('Proporation of age <= 156 months in Subgroup 2: %.4f; age > 156 months: %.4f\n',...
    mean(age(ResultK4.Index==1)<=156),mean(age(ResultK4.Index==1)>156))
fprintf('Proporation of age > 156 months in Subgroup 3: %.4f; age <= 156 months: %.4f\n',....
    mean(age(ResultK4.Index==2)>156),mean(age(ResultK4.Index==2)<=156))
fprintf('Proporation of age > 156 months in Subgroup 4: %.4f; age <= 156 months: %.4f\n',...
    mean(age(ResultK4.Index==4)>156),mean(age(ResultK4.Index==4)<=156))
[tbl,chi2,p,labels]=crosstab(ResultK4.Index,age<=156);
sum(tbl(1:2,2))/sum(tbl(:,2))
sum(tbl(3:4,2))/sum(tbl(:,2))

sum(tbl(1:2,1))/sum(tbl(:,1))
sum(tbl(3:4,1))/sum(tbl(:,1))
%% plot the results comparsion between k=4 and Young-Old seperate
clr=lines(6);clr(1:2,:)=[];
%ordet is index 3 1 2 4 (subgroup 1 2 3 4)
% macth Younger Subrgoup 1; Younger Subgroup 2; Older Subgroup 1; Older Subgroup 2
figure()
subplot (2,1,1)
hold on
plot(ResultK4.Center(3,:)','Color',clr(1,:))
plot(ResultK4.Center(1,:)','Color',clr(2,:))
plot(ResultK4.Center(2,:)','Color',clr(3,:))
plot(ResultK4.Center(4,:)','Color',clr(4,:))


legend({'Subgroup 1','Subgroup 2','Subgroup 3','Subgroup 4'},...
    'NumColumns',4,'Location','north')
X_Labels={'TV or movies-Weekday','Watch Videos-Weekday','Gaming-Weekday','Texting-Weekday','SocialNetworking-Weekday','VideoChat-Weekday',...
    'TV or movies-Weekend','Watch Videos-Weekend','Gaming-Weekend','Texting-Weekend','SocialNetworking-Weekend','VideoChat-Weekend',...
    'Mature gaming','R-rated movies'};
set(gca,'YLim',[0 4]);
set(gca,'XTick',1:14)
set(gca,'XTickLabel',X_Labels)
set(gca,'XTickLabelRotation',30);
set(gca,'YTick',[0 1 2 3 4])
set(gca,'YGrid','on')
set(gcf,'Position',[418         101        1103         840])
ylabel('Item Score')
% title('Re-clusting all HCPD k=4')

subplot(2,1,2)
hold on

plot(ResultYounger(2).Center(1,:)','Color',clr(1,:))
plot(ResultYounger(2).Center(2,:)','Color',clr(2,:))
plot(ResultOlder(2).Center(1,:)','Color',clr(3,:))
plot(ResultOlder(2).Center(2,:)','Color',clr(4,:))

legend({'HCPD Younger: Subgroup 1 ','HCPD Younger: Subgroup 2 ','HCPD Older: Subgroup 1','HCPD Older: Subgroup 2'},...
    'NumColumns',4,'Location','north')
set(gca,'YLim',[0 4]);
set(gca,'XTick',1:14)
set(gca,'YTick',[0 1 2 3 4])
set(gca,'YGrid','on')
set(gca,'XTickLabel',X_Labels)
set(gca,'XTickLabelRotation',30);
ylabel('Item Score')
% title('Sparatedly clustering in Younger and Older subsample')
print('../Res_2_Result/HCPD_YO_K4_Centroid.tiff','-dtiffn','-r300')
figure()
C_Mat=[ResultK4.Center(3,:)' ResultK4.Center(1,:)' ResultK4.Center(2,:)' ResultK4.Center(4,:)' ResultYounger(2).Center' ResultOlder(2).Center'];
% R_Mat=corr(C_Mat);
D_Mat=squareform(pdist(C_Mat'));
xlabels={'Subgroup 1','Subgroup 2','Subgroup 3','Subgroup 4'};
ylabels={'Younger Subgroup 1','Younger Subgroup 2','Older Subgroup 1','Older Subgroup 2'};
heatmap(xlabels,ylabels,D_Mat(1:4,5:end))
colormap(flipud(jet))
% title('Pari-wise correlation between K=4 and Separate Young-Old')
set(gcf,'Position',[681   389   763   590])
print('../Res_2_Result/HCPD_YO_K4_PairSQD.tiff','-dtiffn','-r300')

%% subfunctions
function [DBI,CHI,SH]=Plot_ClusterIndex(Result,TargetClusterNum)

for i=1:length(Result)
    DBI(i)=Result(i).Eval.DBI.CriterionValues;
    CHI(i)=Result(i).Eval.CHI.CriterionValues;
    SH(i)=Result(i).Eval.SH.CriterionValues;
end
figure();
subplot(1,3,1)
plot(TargetClusterNum,DBI,'.-','MarkerSize',12)
title('Davies-Bouldin Index')
set(gca,'XTick',TargetClusterNum)
set(gca,'XGrid','on')
xlabel('Cluster Number')

subplot(1,3,2)
plot(TargetClusterNum,CHI,'.-','MarkerSize',12)
title('Calinski-Harabasz Index')
set(gca,'XTick',TargetClusterNum)
xlabel('Cluster Number')
set(gca,'XGrid','on')

subplot(1,3,3)
plot(TargetClusterNum,SH,'.-','MarkerSize',12)
title('Silhouette Coef')
set(gca,'XTick',TargetClusterNum)
set(gca,'XGrid','on')
xlabel('Cluster Number')



end

function PlotParallelWithSD(Result,screen)

figure
X_Labels={'TV or movies-Weekday','Watch Videos-Weekday','Gaming-Weekday','Texting-Weekday','SocialNetworking-Weekday','VideoChat-Weekday',...
    'TV or movies-Weekend','Watch Videos-Weekend','Gaming-Weekend','Texting-Weekend','SocialNetworking-Weekend','VideoChat-Weekend',...
    'Mature gaming','R-rated movies'};
draw_ShadedErrorBar([],Result(2).Center(1,:),std(screen(Result(2).Index==1,:)),'lineProps',{'-','color',[0, 0.4470, 0.7410]})
hold on
draw_ShadedErrorBar([],Result(2).Center(2,:),std(screen(Result(2).Index==2,:)),'lineProps',{'-','color',[0.8500, 0.3250, 0.0980]})
hold off
set(gca,'XTick',1:14)
set(gca,'XTickLabel',X_Labels)
set(gca,'XTickLabelRotation',30);
set(gca,'YGrid','on')
ylabel('Screen Use Time (Item Score)')


end