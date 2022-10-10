clc
clear
 %% Figure 1A
 load ../SM_Results/RepRes211106.mat ABCDbase_RepRes
 RepRes = ABCDbase_RepRes(3);
 X_Labels={'TV or movies-Weekday','Videos-Weekday','Video Game-Weekday','Text Chat-Weekday','Social Network Site-Weekday','Video Chat-Weekday',...
    'TV or movies-Weekend','Videos-Weekend','Video Game-Weekend','Text Chat-Weekend','Social Network Site-Weekend','Video Chat-Weekend',...
    'Play Mature Game','View R-rated Movies'};
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
    legend('Subgroup 1: Higher-frequency SMA','Subgroup 2: Lower-frequency SMA')
    ylabel('Screen Time Questionnaire: Item Score')
    title(['ABCD Baseline Wave (Sampling Proportion:' num2str(RepRes(j).SamplePercent) '%)'])
    print('Figure_1_A.tiff','-dtiffn','-r300');
    print('Figure_1_A.emf','-dmeta');
    close(h);
end
%% Figure 1B
h=figure();
subplot(1,3,1)
errorbar([2 3 4],mean(RepRes.DBI),std(RepRes.DBI))
hold on
plot([2 3 4],mean(RepRes.DBI),'.','MarkerSize',12)
hold off
set(gca,'XGrid','on')
set(gca,'XLim',[1.8 4.2])
title('Davies-Bouldin Index')
xlabel('Cluster Number')

subplot(1,3,2)
errorbar([2 3 4],mean(RepRes.CHI),std(RepRes.CHI))
hold on
plot([2 3 4],mean(RepRes.CHI),'.','MarkerSize',12)
set(gca,'XGrid','on')
set(gca,'XLim',[1.8 4.2])
set(gca,'YLim',[2000 3800])
title('Calinski-Harabasz Index')
xlabel('Cluster Number')

subplot(1,3,3)
errorbar([2 3 4],mean(RepRes.SH),std(RepRes.SH))
hold on
plot([2 3 4],mean(RepRes.SH),'.','MarkerSize',12)
set(gca,'XGrid','on')
set(gca,'XLim',[1.8 4.2])
set(gca,'YLim',[0.36 0.58])
title('Silhouette Coef')
xlabel('Cluster Number')

print('Figure_1_B.tiff','-dtiffn','-r300');
print('Figure_1_B.emf','-dmeta');
close(h);
%% Figure 1C
clc
clear
load ../Kmeans_allHCPD_156cutoff.mat
load ../Res_Kmeans11817.mat
clr=lines(6);
h=figure();
hold on
plot(Result(2).Center(1,:)','LineWidth',2,'Color',clr(2,:))
plot(Result(2).Center(2,:)','LineWidth',2,'Color',clr(1,:))
plot(ResultYounger(2).Center(1,:)','LineWidth',2,'Color',[clr(3,:) 0.5])
plot(ResultYounger(2).Center(2,:)','LineWidth',2,'Color',[clr(4,:) 0.5])
plot(ResultOlder(2).Center(1,:)','LineWidth',2,'Color',[clr(5,:) 0.5])
plot(ResultOlder(2).Center(2,:)','LineWidth',2,'Color',[clr(6,:) 0.5])
legend({'ABCD Subgroup 1',...
    'ABCD Subgroup 2',...
    'HCPD younger Subgroup 1',...
    'HCPD younger Subgroup 2',...
    'HCPD older Subgroup 1',...
    'HCPD older Subgroup 2'},...
    'NumColumns',3,'Location','best')
 X_Labels={'TV or movies-Weekday','Videos-Weekday','Video Game-Weekday','Text Chat-Weekday','Social Network Site-Weekday','Video Chat-Weekday',...
    'TV or movies-Weekend','Videos-Weekend','Video Game-Weekend','Text Chat-Weekend','Social Network Site-Weekend','Video Chat-Weekend',...
    'Play Mature Game','View R-rated Movies'};
set(gca,'XTick',1:14)
set(gca,'XTickLabel',X_Labels)
set(gca,'XTickLabelRotation',30);
set(gca,'YGrid','on')
set(gca,'YLim',[0 4])
set(gca,'YTick',0:1:4)
set(gcf,'Position',[418         404        1103         420])
ylabel('Screen Time Questionnaire: Item Score')
print('Figure_1_C.tiff','-dtiffn','-r300')
print('Figure_1_C.emf','-dmeta')
close(h)
%% Figure 1 D
h=figure();
load HCPD_ScreenUse.mat ScreenUse
screen=ScreenUse{:,6:19};
load ../Res_Kmeans11817.mat
sumD_G1=sum(( screen-Result(2).Center(1,:) ).^2,2);
sumD_G2=sum(( screen-Result(2).Center(2,:) ).^2,2);
% distance away G1/Total distance is the probability that this point is not
% attributed to G1, thus 1-(distance away G1/Total distance ) is the
% probability that this points is attributed to G1
sumD_propG1=sumD_G2./(sumD_G1 + sumD_G2);
age=str2double(ScreenUse.interview_age);
clr=flipud(lines(2));
colororder(clr);
yyaxis left
plot(age,sumD_G1,'.','MarkerSize',9,'MarkerFaceColor','auto','Color',[clr(1,:) 0.8])
ylabel('Individual SQD to SMA Subgroup 1')
text(157,93,'age = 156 months (13 years-old)','Color',[0.2 0.2 0.2])
yyaxis right
plot(age,sumD_G2,'.','MarkerSize',9,'Color',[clr(2,:) 0.8])
ylabel('Individual SQD to SMA Subgroup 2')
line([156 156],[0 200],'Color',[0.5 0.5 0.5],'LineStyle','--','LineWidth',2)
xlabel('age (months)')
set(gca,'XLim',[min(age)-5 max(age)+5])
title('SQD Values for HCP-D Participants to ABCD SMA Subgroups')
print('Figure_1_D.tiff','-dtiffn','-r300')
print('Figure_1_D.emf','-dmeta')
close(h);