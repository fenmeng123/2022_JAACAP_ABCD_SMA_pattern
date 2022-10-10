function Data=ReadNDAdata(FileDir,OutFormat,ExcelSaveFlag,Verbose)
% Data = ReadNDAdata(FileDir,OutFormat,ExcelSaveFlag)
% automatically read NDA-format(NIMH Data Archive) .txt data
% including:
% 1. HCP-Aging or HCP-Development behavioral measure files
% 2. ABCD V3.0 Release Version data files
% this function will return these data as user-specified MATLAB format
%
% Input:
% FileDir       - an absolute path string or file name string(only if your data file is in the working directory)
% OutFormat     - valid input could be 'struct' , 'cell' or 'table'
% ExcelSaveFlag - true or false, if true, the function will autosave your
%                 data into an EXCEL file named as your input file name
%                 under your working directory
% Output:
% Data          - data formated with OutFormat
%
% Written by Kunru Song 2021.5.20 on MATLAB R2018b
% Modified by Kunru Song 2021.5.28 fixed a bug to prevent zero-elimated
% Modified by Kunru Song 2021.6.6 fixed a bug to prevent minus-elimated
% Modified by Kunru Song 2021.7.8 add progress indication to command window
% Modified by Kunru Song 2021.11.3 add verbose input
if nargin == 3
    Verbose=0;
end
fprintf('\t Reading your NDA-format .txt data......\n')
fprintf('\t Data file directory:%s\n',FileDir);
DataCell=importdata(FileDir);

[HeadLine,Delimiter]=split(DataCell{1});
HeadLine=regexprep(HeadLine,'["-/]','');
StandardDelimiter=Delimiter{1};

RowsNum=length(DataCell);
ColsNum=length(HeadLine);
SplitedDataCell=cell(RowsNum,ColsNum);
fprintf('\t          ')
for irow=1:RowsNum
    SplitedDataCell(irow,:) =strsplit(DataCell{irow},StandardDelimiter);
    if Verbose
        fprintf('\b\b\b\b\b\b\b\b %2.4f%%',(irow/RowsNum))
    end
end
fprintf('\n\t Data have been loaded into workspace\n')
fprintf('\t Remove additional characters ...\n')
SplitedDataCell=regexprep(SplitedDataCell,'["]','');
switch OutFormat
    case 'cell'
        Data=SplitedDataCell;
    case 'struct'
        Data=cell2struct(SplitedDataCell(2:end,:),HeadLine,2);
    case 'table'
        Data=cell2table(SplitedDataCell(2:end,:),'VariableNames',HeadLine);
        Data.Properties.VariableDescriptions=Data{1,:};
    otherwise
        warning('Invalid OutFormat!Function will return your data as a cell!')
        Data=SplitedDataCell;
end
fprintf(['\t Your data will be returned as ' OutFormat '.\n'])


if ExcelSaveFlag
    [~,FileName,~]=fileparts(FileDir);
    OutFileName=[FileName '.xlsx'];
    try
        writetable(Data,OutFileName,'Sheet',1);
    catch ME_FirstLevel
        try
            xlswrite(OutFileName,SplitedDataCell,1);
        catch ME_SecondLevel
            warning('Can not write your data into an EXCEL file!Your data will be autosaved as a .mat file!')
            disp(ME_FirstLevel.getReport)
            disp(ME_SecondLevel.getReport)
            save([FileName '.mat'],'Data');
        end
    end
    fprintf('\t Saveing your data into a EXCEL file......\n')
end
fprintf('\t Done!');disp(datetime);



