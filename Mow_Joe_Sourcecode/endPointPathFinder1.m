function [sortedPathArray ] = endPointPathFinder1( originalImage,image,graph,map )
%function [ max_index,sortedPathArray ] = endPointPathFinder( image,graph,map )

%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

m=bwmorph(image,'endpoints');
endPointsLabels=map(m==1);
endPointsLabels(endPointsLabels==0)=[];

newPathArray{length(endPointsLabels)+1}=1; % preallocating 

for i=1:length(endPointsLabels)
    newPathArray{i}=findPath1(image,graph,map,1,endPointsLabels(i));
end

% [max_size, max_index] = max(cellfun('size', newPathArray, 2));
[max_size, index] = sort(cellfun('size', newPathArray, 2),'descend');
sortedPathArray = newPathArray(index);

end

