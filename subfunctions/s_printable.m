function s_printable(stats,Spec,OutputFile)
% Automatically print the results table from s_ParaLME.m into an excel file
% By Kunru Song 2022.9
if ~isfield(Spec,'AdjustCovs')
   Spec.AdjustCovs = 'non-adjusted'; 
   Spec.DigitNum = 2;
end
switch Spec.AdjustCovs
    case 'both'
        compact_stats = removevars(stats,{'SE','tvals',...
            'noAdj_SE','noAdj_LowCI','noAdj_UpCI','noAdj_tvals',...
            'noAdj_pvals','noAdj_FDR_pvals'});
    case 'RSFNC'
        compact_stats = removevars(stats,{'SE','tvals',...
            'noAdj_SE','noAdj_LowCI','noAdj_UpCI','noAdj_tvals'});
    otherwise
        compact_stats = removevars(stats,{'SE','tvals'});
end
compact_stats.CI95 = cellstr(strcat('[',...
    num2str(round(compact_stats.LowCI,Spec.DigitNum),['%1.' num2str(Spec.DigitNum) 'f']),...
    ', ',...
    num2str(round(compact_stats.UpCI,Spec.DigitNum),['%1.' num2str(Spec.DigitNum) 'f']),...
    ']'));
compact_stats = movevars(compact_stats,'CI95','Before','pvals');
writetable(compact_stats,OutputFile);
fprintf('Result table has been written into %s\n',OutputFile)