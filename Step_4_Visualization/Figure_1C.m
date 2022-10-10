% Figure 1C
load I:\ABCDStudyNDA\ABCD_DataAnalysis\Code_ScreenAnalysis2021\Pipeline\JAACAP_Revision220920\Res_3_IntermediateData\ABCD4.0_Screen_Cluster_y0.mat STQ
load Kmeans_allHCPD_156cutoff.mat
clr=lines(6);
h=figure();
hold on
plot(Result(2).Center(1,:)','LineWidth',2,'Color',clr(1,:))
plot(Result(2).Center(2,:)','LineWidth',2,'Color',clr(2,:))
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
print('../Res_2_Results/Figure_1_C.tiff','-dtiffn','-r300')
print('../Res_2_Results/Figure_1_C.svg','-dsvg')
close(h)