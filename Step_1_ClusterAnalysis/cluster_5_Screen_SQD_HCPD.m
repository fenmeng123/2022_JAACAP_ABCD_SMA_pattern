% calculate the sum of squared distance for HCP-D 624 subjects with
% reference to ABCD 11817 k-means result
% 
% Written by Kunru Song 2021.11.3

load ../Res_3_IntermediateData/HCPD_ScreenUse.mat ScreenUse
screen=ScreenUse{:,6:19};

ABCD=load('../Res_3_IntermediateData/Res_Kmeans11817.mat');
% %% compare cluster centoid between ABCD 11134 and HCPD 630
% load Kmeans_allHCPD_impute.mat
% C_Mat=[ABCD.Result(2).Center' HCPD.Result(2).Center(2,:)' HCPD.Result(2).Center(1,:)'];
% figure()
% plot(C_Mat);
% legend({'ABCD Subgroup 1','ABCD Subgroup 2','HCPD-630 Subgroup 1','HCPD-630 Subgroup 2'})
% X_Labels={'TV or movies-Weekday','Watch Videos-Weekday','Gaming-Weekday','Texting-Weekday','SocialNetworking-Weekday','VideoChat-Weekday',...
%     'TV or movies-Weekend','Watch Videos-Weekend','Gaming-Weekend','Texting-Weekend','SocialNetworking-Weekend','VideoChat-Weekend',...
%     'Mature gaming','R-rated movies'};
% set(gca,'XTick',1:14)
% set(gca,'XTickLabel',X_Labels)
% set(gca,'XTickLabelRotation',30);
% set(gcf,'Position',[418         404        1103         420])
% ylabel('Screen Use Time (Item Score)')
% figure()
% labels={'ABCD Subgroup 1','ABCD Subgroup 2','HCPD-630 Subgroup 1','HCPD-630 Subgroup 2'};
% heatmap(labels,labels,corr(C_Mat))
% colormap jet
% title('Pair-wise correlations between subgroup centroids')
%% calculate SQD and plot
sumD_G1=sum(( screen-ABCD.Result(2).Center(1,:) ).^2,2);
sumD_G2=sum(( screen-ABCD.Result(2).Center(2,:) ).^2,2);
% distance away G1/Total distance is the probability that this point is not
% attributed to G1, thus 1-(distance away G1/Total distance ) is the
% probability that this points is attributed to G1
sumD_propG1=sumD_G2./(sumD_G1 + sumD_G2);
age=str2double(ScreenUse.interview_age);

yyaxis left
plot(age,sumD_G1,'.')
ylabel('individual SQD to Subgroup 1')
text(157,93,'age = 156 months (13 years-old)','Color',[0.6 0.6 0.6])
hold on
yyaxis right
plot(age,sumD_G2,'.')
ylabel('individual SQD to Subgroup 2')
hold off
line([156 156],[0 200],'Color',[0.5 0.5 0.5],'LineStyle','--')
xlabel('age (months)')
set(gca,'XLim',[min(age)-3 max(age)+3])
print('../Res_2_Result/SQD_HCP2ABCD_new.tiff','-dtiffn','-r300')
