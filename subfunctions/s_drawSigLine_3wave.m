function s_drawSigLine_3wave(axes,h_bar1,h_bar2,SimEffRes)
% By Kunru Song 2022.9.29
switch axes.Title.String
    case 'PPS Severity Score'
        Y_Name = 'PPS';
    case 'CBCL Total Problem Scale Score'
        Y_Name = 'totprob';
end
Res_SimpleEffect = SimEffRes( strcmp(SimEffRes.Y_Name,Y_Name) & SimEffRes.MeaningfulContrastFlag,: );
%% Two group difference
% Idx1 Time0 - Idx2 Time0
maxy_t0 = max([h_bar1.YData(1) h_bar2.YData(1)]);
X_left = h_bar1.XEndPoints(1);
X_right = h_bar2.XEndPoints(1);
draw_GroupDiffLine(axes,X_left,X_right,maxy_t0)
add_text_star(axes,Res_SimpleEffect,'Idx2Time0-Idx1Time0',X_left,X_right,maxy_t0)

% Idx1 Time1 - Idx2 Time1
maxy_t1 = max([h_bar1.YData(2) h_bar2.YData(2)]);
X_left = h_bar1.XEndPoints(2);
X_right = h_bar2.XEndPoints(2);
draw_GroupDiffLine(axes,X_left,X_right,maxy_t1)
add_text_star(axes,Res_SimpleEffect,'Idx2Time1-Idx1Time1',X_left,X_right,maxy_t1)

% Idx1 Time2 - Idx2 Time2
maxy_t2 = max([h_bar1.YData(3) h_bar2.YData(3)]);
X_left = h_bar1.XEndPoints(3);
X_right = h_bar2.XEndPoints(3);
draw_GroupDiffLine(axes,X_left,X_right,maxy_t2)
add_text_star(axes,Res_SimpleEffect,'Idx2Time2-Idx1Time2',X_left,X_right,maxy_t2)
%% Idx1 Longitudinal difference
% Idx1 Time0 - Idx1 Time1
X_left = h_bar1.XEndPoints(1);
X_right = h_bar1.XEndPoints(2);
y_bias = 0.035;
maxy_t01 = max(h_bar1.YData(1:2));
draw_TimeDiffLine(axes,X_left,X_right,maxy_t01,y_bias)
add_text_star(axes,Res_SimpleEffect,'Idx1Time0-Idx1Time1',X_left,X_right,maxy_t01+y_bias)

% Idx1 Time1 - Idx1 Time2
X_left = h_bar1.XEndPoints(2);
X_right = h_bar1.XEndPoints(3);
y_bias = 0.032;
maxy_t12 = max(h_bar1.YData(2:3));
draw_TimeDiffLine(axes,X_left,X_right,maxy_t12,y_bias)
add_text_star(axes,Res_SimpleEffect,'Idx1Time1-Idx1Time2',X_left,X_right,maxy_t12+y_bias)
% Idx1 Time0 - Idx1 Time2
X_left = h_bar1.XEndPoints(1);
X_right = h_bar1.XEndPoints(3);
y_bias = 0.065;
maxy_t13 = max(h_bar1.YData([1,3]));
draw_TimeDiffLine(axes,X_left,X_right,maxy_t13,y_bias)
add_text_star(axes,Res_SimpleEffect,'Idx1Time1-Idx1Time2',X_left,X_right,maxy_t13+y_bias)
%% Idx2 Longitudinal difference
% Idx2 Time0 - Idx2 Time1
X_left = h_bar2.XEndPoints(1);
X_right = h_bar2.XEndPoints(2);
y_bias = -0.005;
miny_t01 = min(h_bar2.YData(1:2));
draw_TimeDiffLine(axes,X_left,X_right,miny_t01,y_bias)
add_text_star(axes,Res_SimpleEffect,'Idx2Time0-Idx2Time1',X_left,X_right,miny_t01+y_bias)
% Idx2 Time1 - Idx2 Time2
X_left = h_bar2.XEndPoints(2);
X_right = h_bar2.XEndPoints(3);
y_bias = -0.028;
miny_t12 = min(h_bar2.YData(2:3));
draw_TimeDiffLine(axes,X_left,X_right,miny_t12,y_bias)
add_text_star(axes,Res_SimpleEffect,'Idx2Time1-Idx2Time2',X_left,X_right,miny_t12+y_bias)
% Idx2 Time0 - Idx2 Time2
X_left = h_bar2.XEndPoints(1);
X_right = h_bar2.XEndPoints(3);
y_bias = -0.045;
miny_t02 = min(h_bar2.YData([1,3]));
draw_TimeDiffLine(axes,X_left,X_right,miny_t02,y_bias)
add_text_star(axes,Res_SimpleEffect,'Idx2Time1-Idx2Time2',X_left,X_right,miny_t02+y_bias)
end
%% subfunctions
function draw_GroupDiffLine(axes,X_left,X_right,y)
line(axes,...
    [X_left X_right],...
    [y+0.05 y+0.05],...
    'Color','black',...
    'LineWidth',1.5)
line(axes,...
    [X_left X_left],...
    [y+0.04 y+0.05],...
    'Color','black',...
    'LineWidth',1.5)
line(axes,...
    [X_right X_right],...
    [y+0.04 y+0.05],...
    'Color','black',...
    'LineWidth',1.5)
end
function draw_TimeDiffLine(axes,X_left,X_right,y,y_bias)
if y_bias > 0
    line(axes,...
        [X_left X_right],...
        [y+0.05+y_bias y+0.05+y_bias],...
        'Color','black',...
        'LineWidth',1.5)
    line(axes,...
        [X_left X_left],...
        [y+0.04+y_bias y+0.05+y_bias],...
        'Color','black',...
        'LineWidth',1.5)
    line(axes,...
        [X_right X_right],...
        [y+0.04+y_bias y+0.05+y_bias],...
        'Color','black',...
        'LineWidth',1.5)
else
    line(axes,...
        [X_left X_right],...
        [y-0.02+y_bias y-0.02+y_bias],...
        'Color','black',...
        'LineWidth',1.5)
    line(axes,...
        [X_left X_left],...
        [y-0.01+y_bias y-0.02+y_bias],...
        'Color','black',...
        'LineWidth',1.5)
    line(axes,...
        [X_right X_right],...
        [y-0.01+y_bias y-0.02+y_bias],...
        'Color','black',...
        'LineWidth',1.5)
end
end
function add_text_star(axes,Res_SimpleEffect,ContrastName,X_left,X_right,y)
p_text = Res_SimpleEffect.p(strcmp(Res_SimpleEffect.contrast,ContrastName));
p_text = regexprep(p_text,'<|\.|[0-9]','');
if y > 0
    if isempty(p_text{1})
        p_text{1} = 'n.s.';
        text(axes, (X_left + X_right)/2-length(p_text{1})*0.02,...
            y+0.05+0.015,...
            p_text,'FontSize',10)
    else
        text(axes, (X_left + X_right)/2-length(p_text{1})*0.03,...
            y+0.05+0.005,...
            p_text,'FontSize',14)
    end
else
    if isempty(p_text{1})
        p_text{1} = 'n.s.';
        text(axes, (X_left + X_right)/2-length(p_text{1})*0.02,...
            y-0.02-0.025,...
            p_text,'FontSize',10)
    else
        text(axes, (X_left + X_right)/2-length(p_text{1})*0.03,...
            y-0.02-0.015,...
            p_text,'FontSize',14)
    end
end
end