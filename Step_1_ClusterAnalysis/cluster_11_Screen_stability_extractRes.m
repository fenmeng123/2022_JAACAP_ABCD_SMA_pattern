clc
clear


FileFilter='Kmeans_AllRep500*';
HCPD_ACC=ExtractRepRes_Idx(FileFilter);
FileFilter='Res_AllRep500_11817*';
ABCDbase_ACC=ExtractRepRes_Idx(FileFilter);
FileFilter='Res_AllRep500_y1_11103*';
ABCDy1_ACC=ExtractRepRes_Idx(FileFilter);

save RepRes_ACC.mat HCPD_ACC ABCDbase_ACC ABCDy1_ACC





%% subfunctions
function All_ACC=ExtractRepRes_Idx(FileFilter)

FileDir=dir(FileFilter);

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
    for j=1:length(RepAllCluster)
        [~,maxi_raw]=max(Result(2).Center(:,1));
        [~,maxi_rep]=max(RepAllCluster(j).res(1).Center(:,1));
        if maxi_raw~=maxi_rep
            RepRes=RepAllCluster(j).res(1).Index-1;
            RepRes(RepRes==0)=2;
        else
            RepRes=RepAllCluster(j).res(1).Index;
        end
        ACC(j)=mean(Result(2).Index(RepAllCluster(j).RepIdx)==RepRes);
    end
    if contains(FileDir(i).name,'0.6')
        SamplePercent=60;
    elseif contains(FileDir(i).name,'0.7')
        SamplePercent=70;
    elseif contains(FileDir(i).name,'0.8')
        SamplePercent=80;
    elseif contains(FileDir(i).name,'0.9')
        SamplePercent=90;
    end
All_ACC(i).ACC=ACC;
All_ACC(i).SamplePerc=SamplePercent;
end
end
