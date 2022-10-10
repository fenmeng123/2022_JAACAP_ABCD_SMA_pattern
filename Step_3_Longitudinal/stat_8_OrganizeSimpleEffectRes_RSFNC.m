clc
clear
diary ../Res_1_Logs/Log_Longitudinal_stat_8.txt
%% Organize the Longitudinal Analysis Results about behavioral measures
MdlFileList = dir('../Res_3_IntermediateData/rsfmri_*_LME_R_summary.doc');
MdlFileList = fullfile({MdlFileList.folder},{MdlFileList.name});

EmmFileList = dir('../Res_3_IntermediateData/rsfmri_*_EMM_R_contrast.doc');
EmmFileList = fullfile({EmmFileList.folder},{EmmFileList.name});

%% Organize the R ouput doc file for LME Summary
% Organize the Standardized LME results
Res = cell(length(MdlFileList),1);
for i=1:length(MdlFileList)
   Res{i}  = s_ExtractLMEsummary(MdlFileList{i});
   [~,filename,~] = fileparts(MdlFileList{i});
   Y_Name = strrep(filename,'_LME_R_summary','');
   Res{i}.Y_Name = repmat(cellstr(Y_Name),size(Res{i},1),1);
end
Res = vertcat(Res{:});
Res = movevars(Res,'Y_Name','Before','Name');
Res.std_beta_num = str2double(strrep(strrep(Res.std_beta,'*',''),'–','-'));
fprintf('=======================================================================\n')
disp(Res)
fprintf('=======================================================================\n')
fprintf('===========================Significant Main Effect of group=============================\n')
disp(Res(strcmp(Res.Name,'Idx1'),:))
fprintf('=======================================================================\n')
writetable(Res,'../Res_2_Results/Table_S15.xlsx')
%% Organize the R ouput doc file for EMM contrast
% Organize the simple effect analyses results for LME models
Res = cell(length(MdlFileList),1);
for i=1:length(EmmFileList)
   Res{i}  = s_ExtractEmmeansRes(EmmFileList{i});
   [~,filename,~] = fileparts(EmmFileList{i});
   Y_Name = strrep(filename,'_EMM_R_contrast','');
   Res{i}.Y_Name = repmat(cellstr(Y_Name),size(Res{i},1),1);
end
Res = vertcat(Res{:});
Res = movevars(Res,'Y_Name','Before','rownum');
Res.Comparison = strrep(...
    strrep(...
    strrep(...
    strrep(...
    strrep(Res.contrast,'Idx1','G1:'),...
    'Idx2','G2:'),...
    'Time0','T0'),...
    'Time1','T1'),...
    'Time2','T2');
Res.MeaningfulContrastFlag = double(~(strcmp(Res.contrast,'Idx2Time0-Idx1Time1') |...
    strcmp(Res.contrast,'Idx1Time0-Idx2Time1') |...
    strcmp(Res.contrast,'Idx2Time1-Idx1Time2') |...
    strcmp(Res.contrast,'Idx1Time2-Idx2Time1') |...
    strcmp(Res.contrast,'Idx2Time1-Idx1Time2') |...
    strcmp(Res.contrast,'Idx1Time0-Idx2Time2') |...
    strcmp(Res.contrast,'Idx1Time1-Idx2Time2') ));
fprintf('=======================================================================\n')
disp(Res)
writetable(Res,'../Res_2_Results/Table_S16.xlsx')
fprintf('=======================================================================\n')
fprintf('===========================Significant Simple Effect Analysis=============================\n')
Res = Res(strcmp(Res.contrast,'Idx2Time1-Idx1Time1'),:);
disp(Res(cellfun(@length,strfind(Res.p,'*'))~=0,:))
diary off