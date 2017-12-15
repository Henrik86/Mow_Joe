function [ graphP ] = deleteBranches( graph, skelImage,map,threshold,bottomPointCol,bottomPointRow )
%deleteBranches Deletes branches smaller than a certain threshold from the
%graph
%   graph  The graph that should be pruned
%   skelImage The image skeleton
%   map       The mapping image (maps pixel positions to graph labels)
%   threshold Branches smaller than this threshold will be deleted.

mE=bwmorph(skelImage,'endpoints');
iE=find(mE);
iEL=map(iE);
iEL(iEL==0)=[]

graphP=graph;
visitedPoints=[];
for endpoint=iEL'
    if(graph(endpoint).neighbourCount<=2)%Endpoints should not be crossing points
        if(~(graph(endpoint).coordinate(1)==bottomPointCol)) %do not prune the bottom point
            visitedPoints =[visitedPoints,pruneEndpoints( graphP, endpoint,threshold,map),endpoint];
%             figure;
%             imshow(skelImage)
%             hold on
%             %plot(graph(endpoint).coordinate(2),graph(endpoint).coordinate(1),'o')
%             plot(bottomPointRow,bottomPointCol,'o')
        end
    end
end



%%%%HARD CODED LAST ONE DELETED IF FIRST ONE %%%
if(numel(find(visitedPoints==1))>0)
    visitedPoints=[visitedPoints,numel(graph)];
end
%%%
graphP(visitedPoints)=[];

end

