function P=s_ExtractPvals(mdl_totprob,mdl_pps,mdl_bis,mdl_upps,mdl_bas,VarName)
% Extract the p-values from a bunch of linear mixed effect models with the
% user-specified variable name
% By Kunru Song 2021.7
P(1)=mdl_totprob.Coefficients.pValue(strcmp(mdl_totprob.Coefficients.Name,VarName));
P(2)=mdl_pps.Coefficients.pValue(strcmp(mdl_pps.Coefficients.Name,VarName));
P(3)=mdl_bis.Coefficients.pValue(strcmp(mdl_bis.Coefficients.Name,VarName));
P(4)=mdl_upps.Coefficients.pValue(strcmp(mdl_upps.Coefficients.Name,VarName));
P(5)=mdl_bas.Coefficients.pValue(strcmp(mdl_bas.Coefficients.Name,VarName));
end