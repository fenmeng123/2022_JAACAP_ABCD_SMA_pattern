function s_SubGerrorbar(stats)
% plot two-groups errorbar
% By Kunru Song 2022.9.26
clr=flipud(lines(2));
a=errorbar(stats.Time(stats.Subgroup==1),stats.mu(stats.Subgroup==1),stats.se(stats.Subgroup==1),'-s','LineWidth',2);
hold on
b=errorbar(stats.Time(stats.Subgroup==2),stats.mu(stats.Subgroup==2),stats.se(stats.Subgroup==2),'-s','LineWidth',2);
hold off
set(gca,'XLim',[min(stats.Time)-0.2 max(stats.Time)+0.2])
set(gca,'XTick',unique(stats.Time));
a.Color=clr(1,:);
b.Color=clr(2,:);
% legend({'Subgroup 1','Subgroup 2'})


end

