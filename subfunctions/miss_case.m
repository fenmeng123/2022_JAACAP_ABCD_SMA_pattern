function [Miss_Flag,Num_Miss] = miss_case(data)
% By Kunru Song 2022.9.22
if ~isa(data,'double')
   error('The input data type should be a double type matrix!') 
end
case_miss_num = sum(isnan(data),2);
Miss_Flag = case_miss_num~=0;
Num_Miss = sum(Miss_Flag);
fprintf('Missing Vars Number: %d\n',Num_Miss)