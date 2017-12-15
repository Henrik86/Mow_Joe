%removing the first cutting point manually. terminal leaflet.
% close all;

[ px,py,graph ] = cuttingPointFinder( S2,graph,path,rachis,leaf );
label=map(px,py);
cutIndex=find(path==label);
[graph]=Classify( SN,graph,path,'rachisClassify','TerminalLeaf',cutIndex );
% if(graph(label).neighbourCount>2)
%     neighbours=graph(label).neighbour;
%     SN(ko)=0;
%     SN(px,py)=0;
% else
%     SN(px,py)=0;
% end
SN(px,py)=0;

[terminalLeafRemoved,terminalLeaf]=LargestConnectedComponent(SN);
figure,imshow(terminalLeafRemoved);
pathT=findPath1(SN,graph,map,1,label);
% ba=hasMoreThan2Neighbours(SN,graph,map,path);
% hasMoreThan3Neighbour=hasMoreThan2Neighbour(terminalLeafRemoved,graph,map,pathT);
nPoints=pathT([graph(pathT).neighbourCount]>2 & strcmp({graph(pathT).classify},'rachisClassify'));

% nPoints=pathT([graph(pathT).neighbourCount]>2);
newPathR=findPath1(SN,graph,map,nPoints(1),label);
tempTerminalLeafRemoved=deletePath(terminalLeafRemoved,graph,newPathR);
% tempTerminalLeafRemoved(graph(nPoints(1)).coordinate)=1;

figure,imshow(tempTerminalLeafRemoved);

% m=bwmorph(terminalLeaf,'endpoints');
% endPointsLabels=map(m==1);
% newPathArray(endPointsLabels)=repmat({[0]},1,numel(endPointsLabels));
SN=tempTerminalLeafRemoved;
