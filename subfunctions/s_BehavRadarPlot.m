function h = s_BehavRadarPlot(VarOI,GroupIdx,Labels,Legends,clr)
% Plot the radar graph for behavioral measures
% By Kunru Song 2021.10
% Input
% VarOI - a n-by-m matrix contains the behavioral measures
% GroupIdx - a n-by-1 vector contains the group indexes
% Labels - a n-by-1 cell string contains the names of behavioral measures
% clr - a 2-by-3 RGB matrix; clr=flipud(lines(2));
% Legends - a 2-by-1 cell string; {'Frequent Screen Use Group','Infrequent Screen Use Group'}
% 

% Radar plot settings
opt_area.err        = 'sem';
opt_area.FaceAlpha  = 0.3;
opt_area.Color      = clr;

opt_lines.LineWidth = 2.8;
opt_lines.LineStyle = '-';
opt_lines.Marker    = 'square';
opt_lines.Labels    = false;
opt_lines.Legend    = Legends;
opt_lines.Color     = clr;
                  
opt_axes.Background = 'none';
opt_axes.Labels     = Labels';
opt_axes.Ticks      = -0.5:0.1:0.5;
% z-scoring
Z_VarOI=(VarOI-nanmean(VarOI))./nanstd(VarOI);
% reshape data
data=nan(size(VarOI,2),2,size(VarOI,1));
for i=1:size(Z_VarOI,1)
    data(:,GroupIdx(i),i)=Z_VarOI(i,:)';
end
s_polygonplot(data,opt_axes,opt_lines,opt_area);
h=gcf;