function s_CircularPlot(NetMatrix,NodeName,OutputFileName,ColorMap)
% plot the circular graph for RSFC
% By Kunru Song 2021.10
% Input
% NetMatrix - a double matrix from the s_GetAdjMatrix.m
% NodeName - a cell string contains the node names for NetMatrix
% OutputFileName - a string contains the output file directory and file
% name (without any file suffix)
circularGraph(NetMatrix,'Label',NodeName,'ColorMap',ColorMap);
set(gca,'Position',[0 0 1 1])
set(gcf,'Position',[0 0 1920 1080])
print(OutputFileName,'-dtiffn','-r300')
print(OutputFileName,'-dsvg')
