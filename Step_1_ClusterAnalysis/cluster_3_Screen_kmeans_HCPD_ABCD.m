% k-means clustering analysis for 9-10 years old subjects in HCP-D using
% screen use time questionnaire, and compare with ABCD results
% 
% 
% Written by Kunru Song
clc
clear

InputDataDir='I:\HCPD\HCPD\behavior';

DependentVarFileName='screentime01.txt';

DependentVarDir=fullfile(InputDataDir,DependentVarFileName);

ScreenUse=ReadNDAdata(DependentVarDir,'table',false);

ScreenUse=PreprocScreenUse(ScreenUse);
fprintf('HCP-D Baseline screen use time values processing......\n')
ScreenUse=Var_MissingProcess(ScreenUse);

save ../Res_3_IntermediateData/HCPD_ScreenUse.mat ScreenUse
screen=ScreenUse{:,6:19};
%% K-means for all in HCP-D
TargetClusterNum=1:8;
Result=ml_kmeans_eva(screen,TargetClusterNum,'Replicates',500);
save ../Res_3_IntermediateData/Kmeans_allHCPD.mat Result

%% K-means for baseline and 1-year follow-up exactly age-matched subsample
load ../Res_3_IntermediateData/HCPD_ScreenUse.mat ScreenUse
age=str2double(ScreenUse.interview_age);
Flag=(age>=107) & (age<=149);
fprintf('# %d subjects in HCP-D is matched with ABCD in interview_age\n',sum(Flag))
ScreenUse=ScreenUse(Flag,:);
screen=ScreenUse{:,6:19};
TargetClusterNum=1:8;
Result=ml_kmeans_eva(screen,TargetClusterNum,'Replicates',500);
save ../Res_3_IntermediateData/Kmeans_agemacthHCPD.mat Result
%% compare centorid between age-mathced HCPD and baseline ABCD
load ../Res_3_IntermediateData/Kmeans_agemacthHCPD.mat Result
HCPD_Result=Result;
[DBI,CHI,SH]=Plot_ClusterIndex(HCPD_Result,TargetClusterNum);
print('../Res_2_Result/HCPD_agematch_ClusterIdx.tiff','-dtiffn','-r300')

PlotParallelWithSD(HCPD_Result,screen)
set(gcf,'Position',[418         404        1103         420])
title('Subgroup Centroid with Standard Deviation (age-matched subsample from HCP-D cohort)')
legend('Subgroup 1: frequent screen used','SubGroup 2: infrequent screen used')
print('../Res_2_Result/HCPD_agematch_Centroid.tiff','-dtiffn','-r300')

load ../Res_3_IntermediateData/Res_Kmeans11817.mat Result
ABCD_Result=Result;

figure()
CenterMat=[ABCD_Result(2).Center' HCPD_Result(2).Center'];
disp(CenterMat)
D_Mat=squareform(pdist(CenterMat'));
labels={'ABCD Subgroup1','ABCD Subgroup 2','age-matched HCPD Subgroup 1','age-matched HCPD Subgroup 2'};
heatmap(labels,labels,D_Mat)
colormap(flipud(jet))
print('../Res_2_Result/HCPD_agematch_ABCD_PairSQD.tiff','-dtiffn','-r300')

%% subfunctions
function D=PreprocScreenUse(D)
Flag=contains(D.comqother,'subject about self');
D=D(Flag,:);
D=removevars(D,{'collection_id','screentime01_id','dataset_id','collection_title'});
for i=6:19
    eval(['D.' D.Properties.VariableNames{i} '=str2double(D.' D.Properties.VariableNames{i} ');'])
end
D.Total=sum(D{:,6:17},2);
D.TVshows=D.screentime1_wkdy_y+D.screentime7_wknd_y;
D.videos=D.screentime2_wkdy_y+D.screentime8_wknd_y;
D.game=D.screentime3_wkdy_y+D.screentime9_wknd_y;
D.text=D.screentime4_wkdy_y+D.screentime10_wknd_y;
D.social=D.screentime5_wkdy_y+D.screentime11_wknd_y;
D.vchat=D.screentime6_wkdy_y+D.screentime12_wknd_y;
end

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
draw_ShadedErrorBar([],Result(2).Center(1,:),std(screen(Result(2).Index==1,:)),'lineProps',{'-','color',[0.8500, 0.3250, 0.0980]})
hold on
draw_ShadedErrorBar([],Result(2).Center(2,:),std(screen(Result(2).Index==2,:)),'lineProps',{'-','color',[0, 0.4470, 0.7410]})
hold off
set(gca,'XTick',1:14)
set(gca,'XTickLabel',X_Labels)
set(gca,'XTickLabelRotation',30);
set(gca,'YGrid','on')
set(gca,'YLim',[-1 5])
set(gca,'YTick',-1:1:5)
ylabel('Screen Use Time (Item Score)')


end