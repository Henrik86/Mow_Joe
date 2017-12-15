function [ allLeafs,cutArray,crossingPoint, distances,endSkellabel] = leaveFinder( terminalLeaf,terminalLabel,SNOriginal,nPoints,SN,graph,map,rachis,leaf,S2,topLabel,imgCluster )
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

%this script will find the cutpoints and the leafs of the graph
% it find the leafs and stores them in the ALLLEAFS cellarray. it will also
% store the cutpoints in a cutpoint array.it uses the liklihood function
% for clustering


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%newCode;
% cuttingPointTerminalLeaf;
% cutArray(length(nPoints))={};
% t=newPathArray{max_index};
% nPoints=t([graph(t).neighbourCount]>2 & strcmp({graph(t).classify},'rachisClassify'));
allLeafs={};
allLeafs{1}=terminalLeaf;
cutArray(1)=terminalLabel;
counter=2;
i=1;
leafCounter=2;
[pxx,pyy]=bottomPoint(SNOriginal);
path2delete=[];
endSkellabel=[];
endSkellabel(1)=topLabel;
counts=2;
% neighbourLabel=zeros(neigh(i));
for point=nPoints
    if ismember(point,path2delete)==0
        newPathArray=endPointPathFinder1(SNOriginal,SN,graph,map);
        neigh=graph(point).neighbour;
        i=1 : length(neigh);
        neighbourLabel(i)=map(neigh(i));
        
%         for i=1 : length(neigh)
%             neighbourLabel(i)=map(neigh(i));
%         end
%         [max_size, index] = sort(cellfun('size', newPathArray, 2),'descend');
%           sortedPathArray = newPathArray(index);
        i=1 : length(neigh);

        for k1=1 : numel(newPathArray)
            if ismember(point,newPathArray{k1}) | ~isempty(find(ismember(neighbourLabel,newPathArray{k1}))) | ismember(neighbourLabel(i),newPathArray{k1})
                pathIndex=k1;
                break;
            end
        end
        
        if   numel(newPathArray{pathIndex})>1
            % this is to calculate the cutpoint using the liklihood func or
            % the other function 
            
%             if liklihood==1;
%                 coloredpathes=colorThePath(SN,graph,newPathArray{pathIndex});
%                 [ px,py,graph ] = cuttingPointFinder( S2,graph,newPathArray{pathIndex},rachis,leaf );
%             else
% %                 [ px,py,graph ] = cuttingPointFinderLilklihood(S3,S5,graph,newPathArray{pathIndex} );
%                   [ px,py,node ] = cuttingPointFinderLilklihood1( SNOriginal,S3,obj,D,graph,newPathArray{pathIndex},rachis,leaf );
%             end
               coloredpathes=colorThePath(SN,graph,newPathArray{pathIndex});
              [ px,py,graph ] = cuttingPointFinder( S2,graph,newPathArray{pathIndex},rachis,leaf );
        end
        figure,imshow(SN);
%         SavingScript;
        cutLabel=map(px,py);

        if(graph(cutLabel).neighbourCount>2)
            neighbourss=graph(cutLabel).neighbour;
            SN(neighbourss)=0;
            SN(px,py)=0;
        else
            SN(px,py)=0;
        end
        SN=logical(SN);
        [connect1,connect2]=connectComp(SN);
        if connect1(pxx,pyy)>0
            SN=connect1;
            leaf1=connect2;
        elseif connect2(pxx,pyy)>0
            SN=connect2;
            leaf1=connect1;
        end
        if length(unique(leaf1))>1
            allLeafs{leafCounter}=leaf1;
            leafCounter=leafCounter+1;
        end
%         figure,
%         imshow(SN);
    %     figure,imshow(leaf(i));
        % rachisarray=([graph(hasMoreThan3Neighbour).classify]='rachisClassify');

        %Deltes the path from the cut point to the rachis
        path2delete=findPath1(SN,graph,map,cutLabel,point);
        SN=deletePath(SN,graph,path2delete);
       coloredpathes=colorThePath(SN,graph,path2delete);

        SN(graph(point).coordinate(1),graph(point).coordinate(2))=1;
        SN(neigh)=1;
        
        if ~(strcmp({graph(cutLabel).classify},'rachisClassify'))&& length(path2delete)>10
            distances{counter-1}=path2delete;
            endSkellabel(counter)=newPathArray{pathIndex}(1);
            cutArray(counter)=cutLabel;
            crossingPoint(counter-1)=point;
            counter=counter+1;
        end
        [connect3,connect4]=LargestConnectedComponent(SN);
        if connect3(pxx,pyy)>0
            SN=connect3;
            petiole=connect4;
        else
            SN=connect4;
            petiole=connect3;
        end
    end
end
end

