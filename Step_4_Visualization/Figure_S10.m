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
print('.\Figure\HCPD_YO_K4_Centroid.tiff','-dtiffn','-r300')
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
print('.\Figure\HCPD_YO_K4_PairSQD.tiff','-dtiffn','-r300')