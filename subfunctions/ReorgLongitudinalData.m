function NewT=ReorgLongitudinalData(Data,Demo)
MissFlag=sum(isnan(Data),2)~=0;
fprintf('%d subjects with missing values in follow-up will be removed\n  ',sum(MissFlag))
Data(MissFlag,:)=[];
Demo(MissFlag,:)=[];
SubNum=size(Data,1);
WaveNum=size(Data,2);
Y=reshape(Data,[],1);
Time=reshape(repmat(1:WaveNum,SubNum,1),[],1);Time=Time-1;

SubID=repmat(Demo.src_subject_id,WaveNum,1);
Idx=repmat(Demo.Idx,WaveNum,1);
% Idx=Idx-2;Idx(Idx==-1)=1;
Idx=reordercats(categorical(Idx),{'1','2'});
age=repmat(Demo.age,WaveNum,1);
gender=repmat(Demo.gender,WaveNum,1);
Handness=repmat(Demo.Handness,WaveNum,1);
familyID=repmat(Demo.familyID,WaveNum,1);
relationID=repmat(Demo.relationID,WaveNum,1);
ACSweight=repmat(Demo.ACSweight,WaveNum,1);
educationR=repmat(Demo.educationR,WaveNum,1);
race=repmat(Demo.race,WaveNum,1);
prntedu=repmat(Demo.prntedu,WaveNum,1);
prntemploy=repmat(Demo.prntemploy,WaveNum,1);
famsizeR=repmat(Demo.famsizeR,WaveNum,1);
birthcountry=repmat(Demo.birthcountry,WaveNum,1);
site=repmat(Demo.site,WaveNum,1);
famincomeR=repmat(Demo.famincomeR,WaveNum,1);
anohouse=repmat(Demo.anohouse,WaveNum,1);

NewT=table(Y,Time,SubID,Idx,age,gender,Handness,familyID,relationID,ACSweight,educationR,...
    race,prntedu,prntemploy,famsizeR,birthcountry,site,famincomeR,anohouse);
end