function h = s_PlotDegreeBar(Degree_T_All,Degree_T_Neg,Degree_T_Pos,FileName)

NegPos = join(Degree_T_Neg,Degree_T_Pos,'Keys','NodeName');
NegPosAll = join(NegPos,Degree_T_All,'Keys','NodeName');
NegPosAll = sortrows(NegPosAll,'D','descend');
xlabel = NegPosAll.NodeName;

x = reordercats(categorical(xlabel),xlabel);

h = bar(x,[NegPosAll.D_Degree_T_Neg NegPosAll.D_Degree_T_Pos],0.8,'stacked');
h(1).FaceColor = [0.2118    0.7882    1.0000];
h(2).FaceColor = [1.0000    0.1875         0];
legend({'Negative Network','Positive Network'})
box off
ylabel('node degree')
set(gca,'XTickLabelRotation',-45)
set(gcf,'Position',[209,276.2,1012.8,420])
set(gca,'FontSize',10)
set(gca,'FontName','Arial')
print(FileName,'-dtiffn','-r300')
print(FileName,'-dsvg')
end