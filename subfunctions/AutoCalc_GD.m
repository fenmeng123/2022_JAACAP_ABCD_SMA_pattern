function demoGD=AutoCalc_GD(i,stats,demoGD)
    if isfield(stats,'tbl')
        T=GenCrossTab(stats);
        demoGD.others(i)={T};
        demoGD.t_chi2(i)=stats.chi2;
        demoGD.p(i)=stats.p;
        if isfield(stats,'phi')
            demoGD.effect_size(i)=stats.phi;
            demoGD.CI_es(i,1:2)=stats.phiCi;
        else
            demoGD.effect_size(i)=stats.cramerV;
            demoGD.CI_es(i,1:2)=stats.cramerVCi;
        end
    elseif isfield(stats,'t')
        demoGD.t_chi2(i)=stats.t.tstat;
        demoGD.p(i)=stats.t.p;
        demoGD.effect_size(i)=stats.hedgesg;
        demoGD.CI_es(i,1:2)=stats.hedgesgCi;
        demoGD.df(i)=stats.t.df;
    end
end


function T=GenCrossTab(stats)
T=table(stats.tbl(:,1),stats.tbl(:,2));
T.Properties.VariableNames=strcat('subgroup_',stats.labels(1:2,2));
T.Properties.RowNames=replace(stats.labels(:,1)',' ','_');
end

function stats=stat_GDwithNaN(X,Y,varargin)
% X - a N-by-1 vector, X is the variable need to be compared between groups
% Y - a N-by-1 vector, Y is the group label (group index), Y should only
%                      have two different integers (i.e. 1 and 2) to indicate the two groups
if ~isempty(inputname(1))
    varname=inputname(1);
elseif ~isempty(varargin)
    varname=varargin{:};
else
    varname='name not found';
end
if isa(X,'double')
    Flag=isnan(X);
    fprintf('Missing values #var:%s\n',varname)
    fprintf('Tolal number of missing:%d\n',sum(Flag))
elseif isa(X,'categorical')||isa(X,'string')||isa(X,'char')||isa(X,'cell')
    if ~isa(X,'categorical')&&~strcmp(varname,'birthcountry')
        Flag=strcmp(X,'NaN');
        Flag_Refuse=strcmp(X,'777');
        Flag_DontKnow=strcmp(X,'999');
    elseif strcmp(varname,'birthcountry')
        Flag=strcmp(X,'NaN');
        Flag_Refuse=strcmp(X,'Refuse to answer');
        Flag_DontKnow=strcmp(X,'Dont know');
    else
        Flag=X==categorical(cellstr('NaN'));
        Flag_Refuse=X==categorical(cellstr('777'));
        Flag_DontKnow=X==categorical(cellstr('999'));
    end
    fprintf('Missing values #var:%s nan number:%d Refuse to answer number:%d Dont know:%d\n',varname,sum(Flag),sum(Flag_Refuse),sum(Flag_DontKnow))
    Flag=Flag|Flag_Refuse|Flag_DontKnow;
    fprintf('Tolal number of missing:%d\n',sum(Flag))
end

if sum(Flag)~=0
    X(Flag)=[];
    Y(Flag)=[];
    fprintf('#var:%s #%d Missing value has been removed.\n\n',varname,sum(Flag))
end
if ~isa(X,'categorical')&&~isa(X,'cell')
    MaskG1=Y==1;
    MaskG2=Y==2;
    Y=X(MaskG2);
    X=X(MaskG1);
end
stats=stat_GDiff_Effect(X,Y);
end