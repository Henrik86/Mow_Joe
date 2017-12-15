function [ graph ] = classifierLeaf(allLeafs,graph,map )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[graph]=leafClassifier(allLeafs{1},graph,map,'terminalLeaf');
for i = 2:numel(allLeafs);  
    clas = strcat('leaf', num2str(i));
    [graph]=leafClassifier(allLeafs{i},graph,map,clas);
    
end
end

