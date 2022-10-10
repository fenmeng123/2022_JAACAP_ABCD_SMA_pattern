function s_MatrixPlot(NetMatrix,OutputFileName,PlotSpec)
% Plot the color block matrix graph for the RSFC/RSFNC data
% By Kunru Song 2021.10
if nargin == 2
    PlotSpec.FigStyle = 'Triu';
    PlotSpec.DisplayOpt = 'on';
    PlotSpec.XVarNames = NetName;
    PlotSpec.YVarNames = NetName;
    PlotSpec.TextColor = 'k';
    PlotSpec.Colorbar = 'on';
    PlotSpec.TickFontSize = 16;
end
draw_MatrixColorBlock(NetMatrix,'FigStyle',PlotSpec.FigStyle,'DisplayOpt',PlotSpec.DisplayOpt,...
    'XVarNames',PlotSpec.XVarNames,'YVarNames',PlotSpec.YVarNames,...
    'TextColor',PlotSpec.TextColor,'ColorBar',PlotSpec.Colorbar,'Grid','on','TickFontSize',PlotSpec.TickFontSize)
MinPosValue = min(nonzeros(NetMatrix.*(NetMatrix>0)),[],'all');
MaxNegValue = max(nonzeros(NetMatrix.*(NetMatrix<0)),[],'all');
mycolorbar=jet;
MaxCLim = 0.2;
MinCLim = -0.2;
CLimWhiteUp = round(MinPosValue,2)-0.01;
CLimWhiteLow = round(MaxNegValue,2)+0.01;
if CLimWhiteUp ~= abs(CLimWhiteLow)
    CLimWhiteUp = min(abs([CLimWhiteUp CLimWhiteLow]));
    CLimWhiteLow = -CLimWhiteUp;
end
ColorbarStep = (MaxCLim - MinCLim)/length(mycolorbar);
CbarWhiteUp = length(mycolorbar)/2 - round(CLimWhiteUp/ColorbarStep)+1;
CbarWhiteLow = length(mycolorbar)/2 + round(abs(CLimWhiteLow)/ColorbarStep);
set(gca,'CLim',[MinCLim MaxCLim])
mycolorbar(CbarWhiteUp:CbarWhiteLow,:)=repmat([1 1 1],length(CbarWhiteUp:CbarWhiteLow),1);
ColorBar = get(gcf,'Children');
CbarTicks = (MinCLim :0.05: MaxCLim);
CbarTicks = sort([CbarTicks, CLimWhiteUp, CLimWhiteLow],'ascend');
ColorBar(1).Ticks=CbarTicks;colormap(mycolorbar)
ColorBar(2).FontName = 'Arial';
set(gcf,'Position',[0.2892    0.1306    0.6077    0.7054])
print(OutputFileName,'-dtiffn','-r300')
print(OutputFileName,'-dsvg')
close(gcf)
end