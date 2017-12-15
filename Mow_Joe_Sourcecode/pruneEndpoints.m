function [ visitedPoints ] = pruneEndpoints( graph, startLabel,branchT,mappingImage)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
numPointsOnBranch=0;

node=graph;
stack=CStack;


green=-1;


visitedPoints=[];
node(startLabel).color=-1;
stack.push(startLabel);



while (numel(visitedPoints)<=branchT)
                topLabel=stack.top();
                top=node(topLabel);
                i=top.coordinate(1);
                j=top.coordinate(2);
                neighbors=top.neighbour;
                %node(lab).color=green;
                if numel(neighbors)>2 %%% crosspoint
                    if(numel(visitedPoints)>branchT)
                        visitedPoints=[];
                    end
                    break;
                else %% move on
                    vertexFound=0;
                    for neighb=neighbors
                        labelNeighbor=mappingImage(neighb);
                        coordinateNeighbor=node(labelNeighbor).coordinate;
                        if node(labelNeighbor).color ~= green
                                node(labelNeighbor).color=green;
                                stack.push(labelNeighbor);
                                visitedPoints=[visitedPoints,labelNeighbor];
                                vertexFound=1;
                                break;
                        end
                    end
                end
                if(vertexFound==0)
                    break;
                end 
end

end
     

