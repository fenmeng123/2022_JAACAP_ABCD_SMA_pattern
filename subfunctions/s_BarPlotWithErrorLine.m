function s_BarPlotWithErrorLine(stats)
if length(unique(stats.Time))==3
    barvalues = [stats.mu(strcmp(stats.Time,'baseline_year_1_arm_1')),...
        stats.mu(strcmp(stats.Time,'1_year_follow_up_y_arm_1')),...
        stats.mu(strcmp(stats.Time,'2_year_follow_up_y_arm_1'))]';
    errors = [stats.se(strcmp(stats.Time,'baseline_year_1_arm_1')),...
        stats.se(strcmp(stats.Time,'1_year_follow_up_y_arm_1')),...
        stats.se(strcmp(stats.Time,'2_year_follow_up_y_arm_1'))]';
    groupnames = {'baseline','1-year FU','2-year FU'};
else
    barvalues = [stats.mu(strcmp(stats.Time,'baseline_year_1_arm_1')),...
        stats.mu(strcmp(stats.Time,'2_year_follow_up_y_arm_1'))]';
    errors = [stats.se(strcmp(stats.Time,'baseline_year_1_arm_1')),...
        stats.se(strcmp(stats.Time,'2_year_follow_up_y_arm_1'))]';
    groupnames = {'baseline','2-year FU'};
end
hdls = draw_BarWeb(barvalues,errors,0.8,...
    groupnames,...
    [],[],[],[],[],...
    []);
myclr = flipud(lines(2));
set(gca,'YLim',[-0.2 0.5])
set(hdls.errors(1),'Color',myclr(1,:));
set(hdls.errors(2),'Color',myclr(2,:));
set(hdls.bars(1),'FaceColor',myclr(1,:));
set(hdls.bars(2),'FaceColor',myclr(2,:));

set(hdls.errors,'Marker','s')
set(hdls.errors,'LineStyle','-')
set(hdls.errors,'LineWidth',2)
set(hdls.bars,'EdgeAlpha',0)
set(hdls.bars,'FaceAlpha',0.5)
set(hdls.ax,'YGrid','on')
hdls.ax.YAxis.TickLength=[0.01 0.025];
hdls.ax.XAxis.TickLength=[0.01 0.025];
hdls.ax.YAxis.LineWidth=1;
hdls.ax.XAxis.LineWidth=1;
end