function [stats,aov,fixedEffects]=s_ParaLME_unweighted(Y_table,Covs_table,ModelSpec,Standardize,AdjustCovs)
% [stats,aov,fixedEffects]=s_ParaLME(Y_table,X_name,Covs_table,ModelSpec,Standardized)
% Parallel computing-powered LME modeling for ABCD data analysis
% Notes: for baseline wave cross-sectional LME with ACS weitghs
% By Kunru Song 2022.9
% Inputs:
% for example
% ModelSpec.CovsName='age+gender+race+Handness+prntemploy+prntedu+famsizeR+anohouse+famincomeR';
% ModelSpec.RandomName='(1|site)+(1|site:familyID)';
% ModelSpec.X_name = 'SMAclusterIndex';
% If you want to get standardized beta coefficient, the input 'Covs_table'
% should be z-scored in advance (only for contiuous variables).
switch AdjustCovs
    case 'adjusted'
        LMM_CovsName = ConcatFormula(ModelSpec);
    case 'non-adjusted'
        LMM_CovsName=ModelSpec.RandomName;
    case 'both'
        LMM_CovsName = ConcatFormula(ModelSpec);
        NonAdj_LMM_Formula = strcat('Single_Y~',ModelSpec.X_name,'+',ModelSpec.RandomName);
end
Full_LMM_Formula=strcat('Single_Y~',ModelSpec.X_name,'+',LMM_CovsName);

fprintf('LME formula:%s\n',Full_LMM_Formula)
aov=cell(size(Y_table,2),1);
fixedEffects=cell(size(Y_table,2),1);
Descrip=Y_table.Properties.VariableNames;

parfor (i=1:size(Y_table,2),8)
    Single_Y=Y_table{:,i};
    if Standardize
        Single_Y = nanzscore(Single_Y);
    end
    fprintf('# %s #%d\n',Descrip{i},i)
    T=[table(Single_Y) Covs_table];
    fprintf('estimating full linear mixed-effcet model # %d\n',i)
    full_mdl=fitlme(T,Full_LMM_Formula,'FitMethod','REML');
    fixedEffects(i)={full_mdl.Coefficients};
    
    fprintf('get fixed effects and related statistics # %d\n',i)
    tmpstats=anova(full_mdl,'DFmethod','satterthwaite');
    aov(i)={tmpstats};
    N(i) = full_mdl.NumObservations;
end

coef=nan(size(Y_table,2),1);
SE=nan(size(Y_table,2),1);
LowCI=nan(size(Y_table,2),1);
UpCI=nan(size(Y_table,2),1);
pvals=nan(size(Y_table,2),1);
tvals=nan(size(Y_table,2),1);
Included_N = nan(size(Y_table,2),1);

for i=1:size(Y_table,2)
    tmp=fixedEffects{i,1};
    Flag=contains(tmp.Name,ModelSpec.X_name);
    coef(i) = tmp.Estimate(Flag);
    SE(i) = tmp.SE(Flag);
    LowCI(i) = tmp.Lower(Flag);
    UpCI(i) = tmp.Upper(Flag);
    pvals(i)=tmp.pValue(Flag);
    tvals(i)=tmp.tStat(Flag);
    Included_N(i) = N(i);
end
FDR_pvals=mafdr(pvals,'BHFDR',true);
Y_Name = Descrip';
stats = table(Y_Name,coef,SE,LowCI,UpCI,tvals,pvals,FDR_pvals,Included_N);

if exist('NonAdj_LMM_Formula','var')
    fprintf('Unadjusted Model LME formula:%s\n',NonAdj_LMM_Formula)
    noAdj_fixedEffects = cell(size(Y_table,2),1);
    parfor (i=1:size(Y_table,2),8)
        Single_Y=Y_table{:,i};
        if Standardize
            Single_Y = nanzscore(Single_Y);
        end
        fprintf('# %s #%d\n',Descrip{i},i)
        T=[table(Single_Y) Covs_table];
        fprintf('estimating non-adjusted linear mixed-effcet model # %d\n',i)
        noAdj_mdl=fitlme(T,NonAdj_LMM_Formula,'FitMethod','REML');
        noAdj_fixedEffects(i)={noAdj_mdl.Coefficients};
    end
    noAdj_coef=nan(size(Y_table,2),1);
    noAdj_SE=nan(size(Y_table,2),1);
    noAdj_LowCI=nan(size(Y_table,2),1);
    noAdj_UpCI=nan(size(Y_table,2),1);
    noAdj_pvals=nan(size(Y_table,2),1);
    noAdj_tvals=nan(size(Y_table,2),1);
    for i=1:size(Y_table,2)
        tmp=noAdj_fixedEffects{i,1};
        Flag=contains(tmp.Name,ModelSpec.X_name);
        noAdj_coef(i) = tmp.Estimate(Flag);
        noAdj_SE(i) = tmp.SE(Flag);
        noAdj_LowCI(i) = tmp.Lower(Flag);
        noAdj_UpCI(i) = tmp.Upper(Flag);
        noAdj_pvals(i)=tmp.pValue(Flag);
        noAdj_tvals(i)=tmp.tStat(Flag);
    end
    noAdj_FDR_pvals=mafdr(noAdj_pvals,'BHFDR',true);
    noAdj_stats = table(Y_Name,noAdj_coef,noAdj_SE,noAdj_LowCI,noAdj_UpCI,noAdj_tvals,noAdj_pvals,noAdj_FDR_pvals);
    stats = join(stats,noAdj_stats,'Key','Y_Name');
    stats = movevars(stats,'noAdj_coef','Before','coef');
end


end

function LMM_CovsName = ConcatFormula(ModelSpec)
if isempty(ModelSpec.CovsName)
    LMM_CovsName=ModelSpec.RandomName;
else
    LMM_CovsName=strcat(ModelSpec.CovsName,'+',ModelSpec.RandomName);
end
end