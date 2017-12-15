function [ cutArray ,longestPath] =leaveFinder2( newPathArray,clusterImage,graph,rachis,leaf,map,stemLength )
%UNTITLED2 Summary of this function goes here
%   This function finds the largest path with another approach in mind that
%   is , it will look at cut labels at each point and remove the pathes
%   that include this cutpoint, the next max path will be the largest path
%   to find the next cut point ;

pathIndex=1;
cutArray=[];
cutArraySM=[];%potentially small leafs
longestPath={};
longestPathSM={}; %potentially small leafs
i=1;


while numel(newPathArray)>2
    [px,py,graph ] = cuttingPointFinder( clusterImage,graph,newPathArray{pathIndex},rachis,leaf );
%        figure;
%       imagesc(clusterImage)
%        hold on
%        plot(py,px,'o')
    
    %%%find corresponding crossing point
   
    %%% 
    cutLabel=map(px,py);
    %%between endpoint and longest path has to be a certain distance, check
    %%that!!!
    %%to do:
    %%crossing point finden
    %%laenge endpoint/crossing point checken
    %%falls laenge cutpoint ende zu klein-> aber crossing point <-> ende
    %%gross genug -> hau den punkt in microleaf
    cutLabelIndex=find(newPathArray{pathIndex}==cutLabel);
    %if(cutLabelIndex>=(stemLength/30))
    longestPath{i}=newPathArray{pathIndex};
    cutArray(i)=cutLabel;
    usedPath = cellfun(@(x) intersect(x,cutLabel), newPathArray,'UniformOutput', false);
    usedPath1 = cellfun(@isempty, usedPath);
    newPathArray(find(usedPath1==0))=[];
    [~, index] = sort(cellfun('size', newPathArray, 2),'descend');
    newPathArray = newPathArray(index);
    i=i+1;
    %else
    %    newPathArray(pathIndex)=[];
    %end
    
end
end

