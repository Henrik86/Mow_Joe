function [ graph ] = leafClassifier( image,graph,map,classification )
%This function takes the allleafs {leafs }of the graph and classify them to
%be the leafs , the classification is done via the label that we give them
pixelsMap=find(image);
for ii = pixelsMap'
%     [xCor,yCor]=ind2sub(size(image),ii );
    labelleaf=map(ii);
    if labelleaf ~= 0
        graph(labelleaf).classify=classification;
    end
end

