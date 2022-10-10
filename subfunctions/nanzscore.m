function Z_Data=nanzscore(Data)

Z_Data=(Data-nanmean(Data))./nanstd(Data);




