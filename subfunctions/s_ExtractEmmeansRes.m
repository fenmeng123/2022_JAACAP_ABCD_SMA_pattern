function res = s_ExtractEmmeansRes(InputDocFileDir)
% Extract R emmeans package output from a word document
% the word document is genereated by bruceR R package, which is formatted
% in HTML style
% By Kunru Song 2022.9.29
HTMLcode = fileread(InputDocFileDir);
TEXT = extractHTMLText(HTMLcode);
SplitedText = strsplit(TEXT,' ');
tablehead = SplitedText(1:6);
tablecontent = SplitedText(7:end-1);
RowSplits = [find(ismember(tablecontent,{'1','2','3','4','5','6',...
    '7','8','9','10','11','12','13','14','15'})) length(tablecontent)];
rowcontent = cell(length(RowSplits)-1,1);
rownum = cell(length(RowSplits)-1,1);
compname = cell(length(RowSplits)-1,1);
meandiff = cell(length(RowSplits)-1,1);
se = cell(length(RowSplits)-1,1);
z = cell(length(RowSplits)-1,1);
p = cell(length(RowSplits)-1,1);

for i=1:(length(RowSplits)-1)
rowcontent{i} = tablecontent(RowSplits(i):RowSplits(i+1)-1);
rownum{i} = rowcontent{i}{1};
compname{i} = strcat(rowcontent{i}{2:6});
meandiff{i} = strrep(rowcontent{i}{7},'–','-');
se{i} = strrep(strrep(rowcontent{i}{8},'(',''),')','');
z{i} = strrep(rowcontent{i}{10},'–','-');
p{i} = strcat(rowcontent{i}{11:end});
end
meandiff = str2double(meandiff);
se = str2double(se);
z = str2double(z);
res = table(rownum,compname,meandiff,se,z,p);
res.Properties.VariableNames(2:end) = tablehead([1:3 5:end]);