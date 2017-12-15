%  clear;
%  close all;
 %imageStringName='leaves/21.png';
 imageStringName='leafimages1/JLBA-031L5RB.jpg';


[ I,imageResize,binaryImage,S1,boundryImage,rgbImage,BW,BW1,imageScale ] = binarization( imageStringName );
OriginalS1=S1;
[bottomPointCol,bottomPointRow]=bottomPoint(S1);
[graph,map]=traverseDfs0(S1,bottomPointCol,bottomPointRow);
graphP=deleteBranches(graph,S1,map,25);
SNp = ImageFromGraph( graphP, size(S1));
SN=bwmorph(SNp,'clean');

[bottomPointCol,bottomPointRow]=bottomPoint(SN);
[graph,map]=traverseDfs0(SN,bottomPointCol,bottomPointRow);
[topPointRow,topPointCol]=topPixel(SN);
topLabel=map(topPointRow,topPointCol);
SNOriginal=SN;
path=findPath1(SN,graph,map,1,topLabel);
liklihood=1;
[rachis,leaf,S2,skelCluster,imgCluster ] = clusterFinder( SN,binaryImage,rgbImage );
newPathArray=endPointPathFinder1(SNOriginal,SN,graph,map);
[ cutArray ,longestPath] =leaveFinder2( newPathArray,S2,graph,rachis,leaf,map );
yCord=zeros(numel(cutArray));
for i=1:numel(cutArray)
    yCord(i)=graph(cutArray(i)).coordinate(1);
end
[~,ind]=min(yCord);
terminalLabel=cutArray(ind);
pathT=findPath1(SN,graph,map,1,cutArray(1));
[graph]=Classify(SN,graph,longestPath{1},'rachisClassify','TerminalLeaf',cutArray(1));
nPoints=pathT([graph(pathT).neighbourCount]>=3 & strcmp({graph(pathT).classify},'rachisClassify'));
[ crossingPoint ] = crossPointFinder( longestPath,nPoints );


cutCrossRemove; % removes the redundant crossing points!
[ graph ] = classifierBranch( crossingPoint,cutArray,SNOriginal,graph,map );
colorTheLeaf; %
areaMeasure;
writeIDtoImage;
dataScript;


% [allLeafs,cutArray,crossingPoint, distances,endSkellabel] = leaveFinder( terminalLeaf,terminalLabel,SNOriginal,nPoints,SN,graph,map,rachis,leaf,S2,topLabel,imgCluster );
% [ graph ] = classifierLeaf(allLeafs,graph,map );
%[ graph ] = classifierBranch( crossingPoint,cutArray,SNOriginal,graph,map );
% SavingScript;
 %leafLabelingScript;
% 
% stemColor;
% identifyLeaflets;
% works fine till now 

