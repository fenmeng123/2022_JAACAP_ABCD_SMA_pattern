function Idx=IQR_OutlierDetect(D,k)

if nargin == 1
   k=3; 
end


Q1=prctile(D,25);
Q3=prctile(D,75);

Q2=nanmedian(D);

IQR=iqr(D);
LowBounder=Q1-k*IQR;
UpBounder=Q3+k*IQR;
Idx=D<LowBounder & D>UpBounder;
