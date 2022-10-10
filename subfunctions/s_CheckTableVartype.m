function data = s_CheckTableVartype(data)
% By Kunru Song 2022.9.23
tmp = data(:,vartype('cell'));
Flag = contains(tmp.Properties.VariableNames,{'CBCL','NIHTB','UPPS','BIS',...
    'BAS','rsfmri','PPS'});
fprintf('# %d varaibles in data table are cell string\n',sum(Flag))
fprintf('Selected variables name\n')
SelectedVarName = tmp.Properties.VariableNames(Flag);
disp(tmp.Properties.VariableNames(Flag))
fprintf('Converting cell string to double......\n')

for i=1:length(SelectedVarName)
    fprintf('Convert variable:%s......\n',SelectedVarName{i})
    eval(['data.' SelectedVarName{i} '= str2double(data.' SelectedVarName{i} ');'])
end
fprintf('Convert finished!\n')
end