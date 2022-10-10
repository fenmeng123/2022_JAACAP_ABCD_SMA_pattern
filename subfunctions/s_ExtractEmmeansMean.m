function res = s_ExtractEmmeansMean(InputDocFileDir)
% Extract R emmeans package output from a word document
% the word document is genereated by bruceR R package, which is formatted
% in HTML style
% By Kunru Song 2022.10.03
HTMLcode = fileread(InputDocFileDir);
TEXT = extractHTMLText(HTMLcode);
SplitedText = strsplit(TEXT,' ');
tablecontent = SplitedText(8:end-2);
rowcontent = reshape(tablecontent,8,[])';
rowcontent(:,1)=[];
Idx = cell(size(rowcontent,1),1);
Time = cell(size(rowcontent,1),1);
emms = cell(size(rowcontent,1),1);
se = cell(size(rowcontent,1),1);
LowCI = cell(size(rowcontent,1),1);
UpCI = cell(size(rowcontent,1),1);


for i=1:size(rowcontent,1)
Idx{i} = rowcontent{i,1};
Time{i} = strcat(rowcontent{i,2});
emms{i} = strrep(rowcontent{i,3},'–','-');
se{i} = strrep(strrep(rowcontent{i,4},'(',''),')','');
LowCI{i} = strrep(rowcontent{i,6},'–','-');
UpCI{i} = strrep(rowcontent{i,7},'–','-');
end
Idx = str2double(Idx);
Time = str2double(Time);
emms = str2double(emms);
se = str2double(se);
LowCI = str2double(LowCI);
UpCI = str2double(UpCI);

res = table(Idx,Time,emms,se,LowCI,UpCI);
res.CIerrors = ( abs(abs(res.LowCI) - abs(res.emms)) + abs(abs(res.UpCI) - abs(res.emms)) )/2;