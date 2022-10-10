function Degree = s_GetDegree(G)
% Calculate the node degrees for a MATLAB graph obejct
% By Kunru Song 2021.10
D = centrality(G,'degree');
NodeName = G.Nodes.Variables;
Degree = table(NodeName,D);
Degree = sortrows(Degree,'D','descend');
end