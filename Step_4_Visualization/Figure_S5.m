clc
clear

load RepRes_ACC.mat

ABCDbase_All=[ABCDbase_ACC.ACC];
ABCDY1_All=[ABCDy1_ACC.ACC];


for i=1:4
    ABCDbase_ACC(i).mu_ACC=mean(ABCDbase_ACC(i).ACC);
    ABCDbase_ACC(i).sd_ACC=std(ABCDbase_ACC(i).ACC);
    ABCDy1_ACC(i).mu_ACC=mean(ABCDy1_ACC(i).ACC);
    ABCDy1_ACC(i).sd_ACC=std(ABCDy1_ACC(i).ACC);
    HCPD_ACC(i).mu_ACC=mean(HCPD_ACC(i).ACC);
    HCPD_ACC(i).sd_ACC=std(HCPD_ACC(i).ACC);
end

T_ABCDbase=struct2table(rmfield(ABCDbase_ACC,'ACC'));
T_ABCDbase.Dataset=repmat('ABCD baseline',4,1);

T_ABCDy1=struct2table(rmfield(ABCDy1_ACC,'ACC'));
T_ABCDy1.Dataset=repmat('ABCD 1-year FU',4,1);

T_HCPD=struct2table(rmfield(HCPD_ACC,'ACC'));
T_HCPD.Dataset=repmat('HCP-D all',4,1);

writetable(T_ABCDbase,'stabilityACC.xlsx','Sheet','ABCD baseline');
writetable(T_ABCDy1,'stabilityACC.xlsx','Sheet','ABCD 1-year FU');
writetable(T_HCPD,'stabilityACC.xlsx','Sheet','HCP-D all');
%% plot
figure()
errorbar(T_ABCDbase.SamplePerc,T_ABCDbase.mu_ACC,T_ABCDbase.sd_ACC,'s-','LineWidth',2)
hold on
errorbar(T_ABCDy1.SamplePerc,T_ABCDy1.mu_ACC,T_ABCDy1.sd_ACC,'s-','LineWidth',2)
errorbar(T_HCPD.SamplePerc,T_HCPD.mu_ACC,T_HCPD.sd_ACC,'s-','LineWidth',2)
hold off
xlabel('Sampling Proportion')
ylabel('Accuracy')
set(gca,'XLim',[55 95])
set(gca,'XTick',[60:10:90])
set(gca,'YLim',[0.96 1.005])
set(gca,'YTick',[0.96:0.01:1])
set(gca,'XTickLabel',{'60%','70%','80%','90%'});
set(gca,'YTickLabel',{'96%','97%','98%','99%','100%'});
set(gca,'YGrid','on')
legend({'ABCD baseline','ABCD 1-year FU','HCP-D'},'NumColumns',3,'Location','northoutside')
set(gcf,'Position',[681   499   560   480])
print('.\SM_Figures\Reassignment_ACC.tif','-dtiffn','-r300')
