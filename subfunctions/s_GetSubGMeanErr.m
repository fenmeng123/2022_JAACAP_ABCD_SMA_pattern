function stats=s_GetSubGMeanErr(Y,Idx)
Y=(Y-nanmean(Y))./nanstd(Y);
% automatically get subgroup mean and error bar
% Data - a N-by-1 vector within one time wave, N subjects
% Idx - a N-by-1 vector contains the cluster index
% By Kunru Song 2021.10
MissFlag=sum([isnan(Y) isnan(Idx)],2)~=0;
fprintf('%d subjects with missing values will be removed',sum(MissFlag))
Y(MissFlag,:)=[];
Idx(MissFlag)=[];
fprintf('(N=%d)\n',size(Y,1))
mu_1=mean(Y(Idx==1))';
sd_1=std(Y(Idx==1))';
se_1=sd_1./sqrt(sum(Idx==1))';
n_1 = sum(Idx==1);
mu_2=mean(Y(Idx==2))';
sd_2=std(Y(Idx==2))';
se_2=sd_2./sqrt(sum(Idx==2))';
n_2 = sum(Idx==2);
mu=[mu_1;mu_2];
sd=[sd_1;sd_2];
se=[se_1;se_2];
N = [n_1;n_2];
stats=table(mu,sd,se,N);
stats.Subgroup=reshape(repmat([1 2],size(Y,2),1),[],1);
end