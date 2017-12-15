function [ node ] = Classify(  ~,node,path,rachisClassify,leafClassify,terminalLabel )
% this function classifies the path(from the bottom point till the highest point on graph) 
%into the rachis classify or leaf
% classify . it will be used to classify the rachis from the leaflets.

n=length(path);
tempindex=find(path==terminalLabel);

for i=1:tempindex
    node(path(i)).classify=leafClassify;
end
for i=tempindex+1:n
    node(path(i)).classify=rachisClassify;
end

end

