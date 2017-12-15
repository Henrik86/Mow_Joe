function [ newPathArray ] = largestPathFinder( newPathArray,image,map )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
 imageEndpoints=bwmorph(image,'endpoints');
 labelEndpoints=map(find(imageEndpoints));
 
 endLabels = cellfun(@(x) x(1), newPathArray, 'UniformOutput', false);
 endlabelvector=cell2mat(endLabels);
 
 intersectection=intersect(labelEndpoints,endlabelvector);
 mustRemoveFromNewPathArray=setdiff(endlabelvector,intersectection);
 usedPath = cellfun(@(x) ismember(x(1),mustRemoveFromNewPathArray), newPathArray);
 newPathArray(find(usedPath))=[];
end

% this script is for finding the largest path without recalculating the
% path each time. also refactoring was done untill terminal leaffinder.this
% is working with cell fun and it checks the label and if it is in the
% endpoints of the image (the parts being removed) it will be removed from
% the newPatharray. the problem is that the Leafs are not being deleted in
% the loop function in revised newcut point func.
%also some changes has been done on the revisednewCutpointFunction and it
%has been saved to the leave finder. the textfile on desktop has a good
%link about the vectorization. some saving of the data has been done as
%well with help of 
%save ('data.mat','graph','crossingPoint','cutArray')
% you need to save the above stuff with the rest.