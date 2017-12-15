function [ SN,graph,terminalLeaf,nPoints,terminalLabel] = terminalLeafFinder( S2,SN,graph,path,rachis,leaf,map )
% Find the terminal leaflet of the leave.
%   Detailed explanation goes here

[ px,py,graph ] = cuttingPointFinder( S2,graph,path,rachis,leaf );
terminalLabel=map(px,py);
cutIndex=find(path==terminalLabel);
[graph]=Classify( SN,graph,path,'rachisClassify','TerminalLeaf',cutIndex );
SN(px,py)=0;
[terminalLeafRemoved,terminalLeaf]=LargestConnectedComponent(SN);
figure,imshow(terminalLeafRemoved);
pathT=findPath1(SN,graph,map,1,terminalLabel);
nPoints=pathT([graph(pathT).neighbourCount]>=3 & strcmp({graph(pathT).classify},'rachisClassify'));
newPathR=findPath1(SN,graph,map,nPoints(1),terminalLabel);
tempTerminalLeafRemoved=deletePath(terminalLeafRemoved,graph,newPathR);
figure,imshow(tempTerminalLeafRemoved);
%SN=tempTerminalLeafRemoved;

end

