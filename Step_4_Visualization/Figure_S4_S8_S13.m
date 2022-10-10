
clc
clear

load RepRes211106.mat

%% create sensitivity table
SensTbl=GetSensTbl(HCPD_RepRes);
writetable(SensTbl,'SensitivityTable.xlsx','Sheet','HCPD_all624');
SensTbl=GetSensTbl(ABCDbase_RepRes);
writetable(SensTbl,'SensitivityTable.xlsx','Sheet','ABCD_baseline');
SensTbl=GetSensTbl(ABCDy1_RepRes);
writetable(SensTbl,'SensitivityTable.xlsx','Sheet','Abcd_year1');

%% plot cluster evaluation

MultiPlotEva(HCPD_RepRes,'HCP-D ','HCPD_ClusterEva_')
MultiPlotEva(ABCDbase_RepRes,'ABCD baseline ','ABCDbase_ClusterEva_')
MultiPlotEva(ABCDy1_RepRes,'ABCD 1-year follow-up ','ABCD_y1_ClusterEva_')

%% plot results for replication

MultiPlotCentroid(HCPD_RepRes,'HCP-D ','HCPD_RepCenter_');
MultiPlotCentroid(ABCDbase_RepRes,'ABCD baseline  ','ABCDbase_RepCenter_')
MultiPlotCentroid(ABCDy1_RepRes,'ABCD 1-year follow-up ','ABCD_y1_RepCenter_')

%% 
clc
clear
load RepResHCPYO.mat

MultiPlotCentroid(HCPD_YoungerRepRes,'HCP-D younger ','HCPD_Y_RepCenter_');
MultiPlotCentroid(HCPD_OlderRepRes,'HCP-D older  ','HCPD_O_RepCenter_')
%% 
MultiPlotEva(HCPD_YoungerRepRes,'HCP-D younger ','HCPD_Y_ClusterEva_')
MultiPlotEva(HCPD_OlderRepRes,'HCP-D older ','HCPD_O_ClusterEva_')

%% subfunctions
function Tbl=MultiPlotSQD(HCPD_RepRes,ABCDbase_RepRes,ABCDy1_RepRes)

SamplePercent=reshape(repmat([HCPD_RepRes.SamplePercent],size(HCPD_SQD_G1,1),1),[],1);
SamplePercent=strcat(num2str(SamplePercent),'%');

HCPD_SQD_G1=[sum(HCPD_RepRes(1).D_G1.^2,2) sum(HCPD_RepRes(2).D_G1.^2,2) sum(HCPD_RepRes(3).D_G1.^2,2) sum(HCPD_RepRes(4).D_G1.^2,2)];
HCPD_SQD_G1=reshape(HCPD_SQD_G1,[],1);

ABCDbase_SQD_G1=[sum(ABCDbase_RepRes(1).D_G1.^2,2) sum(ABCDbase_RepRes(2).D_G1.^2,2) sum(ABCDbase_RepRes(3).D_G1.^2,2) sum(ABCDbase_RepRes(4).D_G1.^2,2)];
ABCDbase_SQD_G1=reshape(ABCDbase_SQD_G1,[],1);

ABCDy1_SQD_G1=[sum(ABCDy1_RepRes(1).D_G1.^2,2) sum(ABCDy1_RepRes(2).D_G1.^2,2) sum(ABCDy1_RepRes(3).D_G1.^2,2) sum(ABCDy1_RepRes(4).D_G1.^2,2)];
ABCDy1_SQD_G1=reshape(ABCDy1_SQD_G1,[],1);

HCPD_SQD_G2=[sum(HCPD_RepRes(1).D_G2.^2,2) sum(HCPD_RepRes(2).D_G2.^2,2) sum(HCPD_RepRes(3).D_G2.^2,2) sum(HCPD_RepRes(4).D_G2.^2,2)];
ABCDbase_SQD_G2=[sum(ABCDbase_RepRes(1).D_G2.^2,2) sum(ABCDbase_RepRes(2).D_G2.^2,2) sum(ABCDbase_RepRes(3).D_G2.^2,2) sum(ABCDbase_RepRes(4).D_G2.^2,2)];
ABCDy1_SQD_G1=[sum(ABCDy1_RepRes(1).D_G2.^2,2) sum(ABCDy1_RepRes(2).D_G2.^2,2) sum(ABCDy1_RepRes(3).D_G2.^2,2) sum(ABCDy1_RepRes(4).D_G2.^2,2)];


end
function MultiPlotEva(RepRes,PlotName,FileName)
for i=1:length(RepRes)
    h=figure();
    PlotCriteria(RepRes(i).CHI,RepRes(i).DBI,RepRes(i).SH);
    suptitle([PlotName 'Sampling Percentage:' num2str(RepRes(i).SamplePercent) '%'])
    print([FileName num2str(RepRes(i).SamplePercent) '.tif'],'-dtiffn','-r300');
    close(h)
end
end

function SensTbl=GetSensTbl(RepRes)
SensTbl=table('Size',[length(RepRes) 13],...
    'VariableTypes',{'double','double','double','double','double','double','double',...
    'double','double','double',...
    'double','double','double'},...
    'VariableNames',{'SamplingPercentage','DBI_mean','DBI_std','CHI_mean','CHI_std','SH_mean','SH_std'...
    'p_KS2_DBI','p_KS2_CHI','p_KS2_SH',...
    'p_sr2_DBI','p_sr2_CHI','p_sr2_SH'});
for i=1:length(RepRes)
    SensTbl.SamplingPercentage(i)=RepRes(i).SamplePercent;
    SensTbl.DBI_mean(i,1:3)=mean(RepRes(i).DBI);
    SensTbl.DBI_std(i,1:3)=std(RepRes(i).DBI);
    SensTbl.CHI_mean(i,1:3)=mean(RepRes(i).CHI);
    SensTbl.CHI_std(i,1:3)=std(RepRes(i).CHI);
    SensTbl.SH_mean(i,1:3)=mean(RepRes(i).SH);
    SensTbl.SH_std(i,1:3)=std(RepRes(i).SH);
    SensTbl.p_KS2_DBI(i,1:3)=PariKStest2(RepRes(i).DBI);
    SensTbl.p_KS2_CHI(i,1:3)=PariKStest2(RepRes(i).CHI);
    SensTbl.p_KS2_SH(i,1:3)=PariKStest2(RepRes(i).SH);
    SensTbl.p_sr2_DBI(i,1:3)=PariSignrank(RepRes(i).DBI);
    SensTbl.p_sr2_CHI(i,1:3)=PariSignrank(RepRes(i).CHI);
    SensTbl.p_sr2_SH(i,1:3)=PariSignrank(RepRes(i).SH);
end
end

function P=PariKStest2(X)
[~,P(1)]=kstest2(X(:,1),X(:,2));
[~,P(2)]=kstest2(X(:,2),X(:,3));
[~,P(3)]=kstest2(X(:,1),X(:,3));
end
function P=PariSignrank(X)
P(1)=signrank(X(:,1),X(:,2));
P(2)=signrank(X(:,2),X(:,3));
P(3)=signrank(X(:,1),X(:,3));

end
function [pDBI_1,pDBI_2,pCHI_1,pCHI_2,pSH_1,pSH_2]=PlotCriteria(CHI,DBI,SH)
subplot(1,3,1)
errorbar([2 3 4],mean(DBI),std(DBI))
hold on
plot([2 3 4],mean(DBI),'.','MarkerSize',12)
hold off
set(gca,'XGrid','on')
set(gca,'XLim',[1.8 4.2])
% set(gca,'YLim',[1.45 1.9])
title('Davies-Bouldin Index')
xlabel('Cluster Number')

pDBI_1=signrank(DBI(:,1),DBI(:,2));
pDBI_2=signrank(DBI(:,2),DBI(:,3));
subplot(1,3,2)
errorbar([2 3 4],mean(CHI),std(CHI))
hold on
plot([2 3 4],mean(CHI),'.','MarkerSize',12)
set(gca,'XGrid','on')
set(gca,'XLim',[1.8 4.2])
% set(gca,'YLim',[2000 3700])

title('Calinski-Harabasz Index')
xlabel('Cluster Number')

pCHI_1=signrank(CHI(:,1),CHI(:,2));
pCHI_2=signrank(CHI(:,2),CHI(:,3));
subplot(1,3,3)
errorbar([2 3 4],mean(SH),std(SH))
hold on
plot([2 3 4],mean(SH),'.','MarkerSize',12)
set(gca,'XGrid','on')
set(gca,'XLim',[1.8 4.2])
% set(gca,'YLim',[0.36 0.58])

title('Silhouette Coef')
xlabel('Cluster Number')
pSH_1=signrank(SH(:,1),SH(:,2));
pSH_2=signrank(SH(:,2),SH(:,3));
end

function MultiPlotCentroid(RepRes,PlotName,FileName)

X_Labels={'TV or movies-Weekday','Videos-Weekday','Gaming-Weekday','Texting-Weekday','SocialNetworking-Weekday','VideoChat-Weekday',...
    'TV or movies-Weekend','Videos-Weekend','Gaming-Weekend','Texting-Weekend','SocialNetworking-Weekend','VideoChat-Weekend',...
    'Mature gaming','R-rated movies'};
for j=1:length(RepRes)
    h=figure();
    f=parallelcoords(RepRes(j).RawCenter,'group',{'G1','G2'},'labels',X_Labels);
    clr=lines(2);
    f(1).Color=clr(2,:);
    f(2).Color=clr(1,:);
    
    set(gca,'XTickLabelRotation',30);
    set(gca,'YGrid','on')
    set(gca,'YLim',[0 4]);
    set(gca,'YTick',0:1:4)
    legend off
    hold on
    set(gcf,'Position',[418         404        1103         420])
    
    for i=1:size(RepRes(j).RepCenter,1)
        if i<=size(RepRes(j).RepCenter,1)/2
            plot(RepRes(j).RepCenter(i,:),'Color',[f(1).Color 0.1],'LineStyle','--')
        else
            plot(RepRes(j).RepCenter(i,:),'Color',[f(2).Color 0.1],'LineStyle','--')
        end
    end
    legend('Subgroup 1: frequent screen use','SubGroup 2: infrequent screen use')
    ylabel('Screen Use Time (Item Score)')
    title([PlotName 'Sampling Percentage:' num2str(RepRes(j).SamplePercent) '%'])
    print([FileName num2str(RepRes(j).SamplePercent) '.tif'],'-dtiffn','-r300');
    close(h);
end
end