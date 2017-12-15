function [leafletStruct] = cutCrossRemove(cutArray,graph,crossingPoint,SN,map,longestPath,stemLength)

smallLeafsCrossingPoint=zeros(numel(crossingPoint),1);
smallLeafsCutPoint=zeros(numel(crossingPoint),1);
smallLeafsToRemove=zeros(numel(crossingPoint),1);;
leafsToRemove=zeros(numel(crossingPoint),1);



crossNum=numel(crossingPoint);
if(crossNum>0)
cutToCross{crossNum}=0; % preallocating 
indCut((crossNum)+1)=0;
flagV=0;
for ij=1:crossNum
    
    cuttingPoint=cutArray(ij);
%       figure;
%       imshow(SN);
%       hold on
%       plot(graph(crossingPoint(ij)).coordinate(2),graph(crossingPoint(ij)).coordinate(1),'ro')
%       plot(graph(cuttingPoint).coordinate(2),graph(cuttingPoint).coordinate(1),'ro')
    
    if(crossingPoint(ij)~=0)
        
        cutLabelIndex=find(longestPath{ij}==cuttingPoint);
        crossLabelIndex=find(longestPath{ij}==crossingPoint(ij));
        if(cutLabelIndex<=(stemLength))
            if(crossLabelIndex>=(stemLength))
                smallLeafsToRemove(ij)=ij;
            else
                leafsToRemove(ij)=ij;
            end
        end
%         cutToCross{ij}=findPath1(SN,graph,map,cutArray(ij),crossingPoint(ij));
%         if numel(cutToCross{ij})<15
%            indCross(ij)=ij;
%            indCut(ij)=ij;
%            flagV=1;
%         end
    end
end
smallLeafsToRemove(smallLeafsToRemove==0)=[];
leafsToRemove(leafsToRemove==0)=[];
%%
smallLeafsCrossingPoint=crossingPoint(smallLeafsToRemove);
smallLeafsCutPoint=cutArray(smallLeafsToRemove);
%%
cutArray([smallLeafsToRemove;leafsToRemove])=[];
crossingPoint([smallLeafsToRemove;leafsToRemove])=[];
longestPathTemp=longestPath;
longestPathTemp(leafsToRemove')=[];
%%
longestPathSmallLeafs=longestPath(smallLeafsToRemove);
longestPath([smallLeafsToRemove;leafsToRemove])=[];
%%%%
[a,index]=unique(crossingPoint);
allInd = find(crossingPoint);
nonUniq=setdiff(allInd,index');
crossingPoint(nonUniq)=[];
cutArray(nonUniq)=[];
%%
[a,indexSL]=unique(smallLeafsCrossingPoint);
allIndSL = find(smallLeafsCrossingPoint);
nonUniqSL=setdiff(allIndSL,indexSL');
smallLeafsCrossingPoint(nonUniqSL)=[];
smallLeafsCutPoint(nonUniqSL)=[];



%%
% Base to branch feature calculates the base to Branch and branch length
    baseToBranch=NaN(numel(crossingPoint),1);
    baseToBranch(1)=numel(findPath1(SN,graph,map,1,cutArray(1)));
    for i=2 :numel(crossingPoint)
        baseToBranch(i)=numel(findPath1(SN,graph,map,1,crossingPoint(i)));
    end
    branchLen=zeros(numel(crossingPoint),1);
    branchLen(1)=numel(findPath1(SN,graph,map,cutArray(1),crossingPoint(2)));
    for i=2 :numel(crossingPoint)
        branchLen(i)=numel(findPath1(SN,graph,map,cutArray(i),crossingPoint(i)));
    end


%%
longestPath([nonUniq])=[];
longestPathTemp([nonUniqSL])=[];
longestPathSmallLeafs(nonUniqSL)=[];
%%%%

v_cell = cell(1,(numel(crossingPoint)+numel(smallLeafsCrossingPoint)));
a=num2cell([crossingPoint,smallLeafsCrossingPoint])';
b=num2cell([cutArray,smallLeafsCutPoint])';
c=[repmat({'leaflet'},1,numel(cutArray)),repmat({'smallLeaflet'},1,numel(smallLeafsCutPoint))]';
d=[longestPath,longestPathSmallLeafs]';
e=num2cell(branchLen);
f=num2cell(baseToBranch);
leafletStruct = cell2struct([a,b,c,d,e,f],{'crossingPoint','cutPoint','class','pathBaseEndpoint','branchLength','baseToBranch'},2);
%leafletStruct = cell2struct([num2cell([crossingPoint,smallLeafsCrossingPoint])',num2cell([cutArray,smallLeafsCutPoint])',[repmat({'leaflet'},1,numel(cutArray)),repmat({'smallLeaflet'},1,numel(smallLeafsCutPoint))]',[longestPath,longestPathSmallLeafs]',...
 %   num2cell([branchToBranch])',num2cell([baseToBranch])',...
  %  {'crossingPoint','cutPoint','class','pathBaseEndpoint','branchLength','baseToBranch'},2);


%%
%[a,index]=unique(crossingPoint,'sorted');%%%%%%%??????????leafletStruct = cell2struct([num2cell([crossingPoint,smallLeafsCrossingPoint])',num2cell([cutArray,smallLeafsCutPoint])',[repmat({'leaflet'},1,numel(cutArray)),repmat({'smallLeaflet'},1,numel(smallLeafsCutPoint))]',[longestPath,longestPathSmallLeafs]],{'crossingPoint','cutPoint','class','pathBaseEndpoint'},2);


%  cutArray1=cutArray(setdiff(1:length(cutArray),find(indCut)));
%  crossingPoint1=crossingPoint(setdiff(1:length(crossingPoint),find(indCross)));

%  cutArray(find(ind))=[];
%  crossingPoint(find(ind))=[];
end
end