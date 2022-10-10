function stats=stat_GDiff_Effect(X,Y)
% For numerical data
% X - group 1 data
% Y - group 2 data
% For categorical data
% X - a N-by-1 data vector
% Y - a N-by-1 group label (group index) vector
% 
% Written by Kunru Song

if ~strcmp(class(X),class(Y)) && ~isa(X,'categorical') && ~isa(X,'cell')
    error('the variable type between X and Y is inconsistent!')
elseif (isa(X,'categorical')||isa(X,'cell')) && (~isa(Y,'double')&&~isa(Y,'categorical'))
    error('X is categorical vars but Y is not group label!(Y should be double or categorical vars)')
end
switch class(X)
    case 'double'
        % if X is Data and Y is group label
        G1=X(Y==1);
        G2=X(Y==2);
        stats=mes(G1,G2,'hedgesg');
    case {'categorical','cell'}
        [stats.tbl,~,stats.p,stats.labels]=crosstab(X,Y);
        newstats=mestab(stats.tbl);
        stats=catstruct(stats,newstats);
end
end