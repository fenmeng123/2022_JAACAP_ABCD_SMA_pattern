clc
clear


FileFilter='Kmeans_AllRep500*';
HCPD_RepRes=ExtractRepRes(FileFilter);
FileFilter='Res_AllRep500_11817*';
ABCDbase_RepRes=ExtractRepRes(FileFilter);
FileFilter='Res_AllRep500_y1_11103*';
ABCDy1_RepRes=ExtractRepRes(FileFilter);

save RepRes211106.mat HCPD_RepRes ABCDbase_RepRes ABCDy1_RepRes -v7.3


%% subfunctions

function RepRes=ExtractRepRes(FileFilter)

FileDir=dir(FileFilter);
RepRes=struct('CHI',[],'DBI',[],'SH',[],'D_G1',[],'D_G2',[],'RepCenter',[],'SamplePercent',[],'RawCenter',[]);

switch FileFilter
    case 'Kmeans_AllRep500*'
        Result=load('Kmeans_allHCPD.mat');
        Result=Result.Result;
    case 'Res_AllRep500_11817*'
        Result=load('Res_Kmeans11817.mat');
        Result=Result.Result;
    case 'Res_AllRep500_y1_11103*'
        Result=load('Res_Kmeans11103_year1.mat');
        Result=Result.Result_y1;
end

for i=1:length(FileDir)
    fprintf('#\t loading data: %s\n',fullfile(FileDir(i).folder,FileDir(i).name))
    load(FileDir(i).name)
    [CHI,DBI,SH]=GetCriteria(RepAllCluster);
    [D_G1,D_G2,RepCenter,Center]=GetRepCentroid(RepAllCluster,Result);
    
    if contains(FileDir(i).name,'0.6')
        SamplePercent=60;
    elseif contains(FileDir(i).name,'0.7')
        SamplePercent=70;
    elseif contains(FileDir(i).name,'0.8')
        SamplePercent=80;
    elseif contains(FileDir(i).name,'0.9')
        SamplePercent=90;
    end
    RepRes(i).CHI=CHI;
    RepRes(i).DBI=DBI;
    RepRes(i).SH=SH;
    RepRes(i).D_G1=D_G1;
    RepRes(i).D_G2=D_G2;
    RepRes(i).RepCenter=RepCenter;
    RepRes(i).SamplePercent=SamplePercent;
    RepRes(i).RawCenter=Center;
end
end

function [CHI,DBI,SH]=GetCriteria(RepAllCluster)
for i=1:length(RepAllCluster)
    CHI(i,1)=RepAllCluster(i).res(1).Eval.CHI.CriterionValues;
    CHI(i,2)=RepAllCluster(i).res(2).Eval.CHI.CriterionValues;
    CHI(i,3)=RepAllCluster(i).res(3).Eval.CHI.CriterionValues;
    DBI(i,1)=RepAllCluster(i).res(1).Eval.DBI.CriterionValues;
    DBI(i,2)=RepAllCluster(i).res(2).Eval.DBI.CriterionValues;
    DBI(i,3)=RepAllCluster(i).res(3).Eval.DBI.CriterionValues;
    SH(i,1)=RepAllCluster(i).res(1).Eval.SH.CriterionValues;
    SH(i,2)=RepAllCluster(i).res(2).Eval.SH.CriterionValues;
    SH(i,3)=RepAllCluster(i).res(3).Eval.SH.CriterionValues;
end

end


function [SD_G1,SD_G2,RepCenter,Center]=GetRepCentroid(RepAllCluster,Result)
RepTimes=length(RepAllCluster);
for i=1:RepTimes
    RepCenter{i,1}=RepAllCluster(i).res(1).Center;
end
RepCenter=cell2mat(RepCenter);
RepCenter=sortrows(RepCenter,1,'descend');
Center=sortrows(Result(2).Center,1,'descend');
SD_G1=RepCenter(1:500,:)-Center(1,:);
SD_G2=RepCenter(501:end,:)-Center(2,:);
end