function res = s_ExtractLMEsummary(InputDocFileDir)
HTMLcode = fileread(InputDocFileDir);
TEXT = extractHTMLText(HTMLcode);
SplitedText = strsplit(TEXT,' ');
CellSplits = find(ismember(SplitedText,{'Idx1','Time','Idx1:Time'}));

TruncatedFlag = find(contains(SplitedText,'BIC'));
CellSplits(CellSplits>TruncatedFlag) = [];

res = cell(3,3);
for i=1:length(CellSplits)
    res(i,:) = SplitedText(CellSplits(i):CellSplits(i)+2);
end
res = cell2table(res,'VariableNames',{'Name','std_beta','se'});
end