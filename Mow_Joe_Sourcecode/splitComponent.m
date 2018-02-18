function [ bS,minPoint1,minPoint2,leafletImage] = splitComponent(compImage,boundaryImage,skeletonImage,skPoint,binaryImage,indexLeaflet,crossPoint,sizeWholeLeaf)
%UNTITLED Splits the connected component at a certain point using the
%skeleton and the boundary image
%   Detailed explanation goes here
[boundaryPointsY,boundaryPointsX]=find(boundaryImage);
boundaryPoints=[boundaryPointsY,boundaryPointsX];
%
D=pdist2(boundaryPoints,skPoint);
[~,ID] =sort(D);
minPoint1=boundaryPoints(ID(1),:);
%%%%%search second Point
for p=ID'
   % if(pdist2(minPoint1,boundaryPoints(p,:))>12)
        skeletonImageTemp=skeletonImage;
        minPointTemp2=boundaryPoints(p,:);
        if(pdist2(minPoint1,minPointTemp2)>pdist2(minPoint1,skPoint) && pdist2(minPoint1,minPointTemp2)>pdist2(minPointTemp2,skPoint))
            lineImage=zeros(size(skeletonImage));
            lineImage=drawLine(lineImage,minPoint1(1),minPoint1(2),minPointTemp2(1),minPointTemp2(2));
            skeletonImageTemp(logical(lineImage))=0;
            newComps=bwlabel(skeletonImageTemp);
            if(numel(unique(newComps))>=3)
                minPoint2=boundaryPoints(p,:);
                break;
            end
        end
    %end
end
% figure;imshow(boundaryImage)
% hold on
% plot(minPoint1(2), minPoint1(1),'o')
% plot(minPoint2(2), minPoint2(1),'o')
%%%%%%%%%SPLIT%%%%%%
nI=skeletonImage | boundaryImage;
nID=drawLine(zeros(size(nI)),minPoint1(1), minPoint1(2), minPoint2(1), minPoint2(2));
bS=compImage;
bS(nID>0)=0;
nI=skeletonImage | boundaryImage;
if( ~isempty(minPoint2))
    %
    slopes = (minPoint2(2) - minPoint1(2)) ./ (minPoint2(1) - minPoint1(1));
    dev=minPoint1(2)-slopes*minPoint1(1);
    %
    nY1=slopes*(minPoint1(1)-1)+dev;
    nY2=slopes*(minPoint1(1)+1)+dev;
    xM1=minPoint1(1);
    xM2=minPoint2(1);
    if(xM1<xM2)
        xM1=xM1-10;
        xM2=xM2+10
    end
    nID=drawLine(zeros(size(nI)),minPoint1(1), minPoint1(2), minPoint2(1), minPoint2(2));
    nID=imdilate(nID,strel('square',3));
    nID=bwmorph(nID,'skel',Inf);
    nED=bwmorph(nID,'endpoints');
    nID=nID & ~(nID&nED);
    %nIDE = bwmorph(nID,'endpoints');
    %nIDE=imdilate(nIDE,strel('disk',2));
    %nIDE=nIDE & ~binaryImage;
    %nID=nID+nIDE;
    'endpoints'
    %%
    binaryImageLabeled=bwlabel(binaryImage,4);
    sA = regionprops(binaryImageLabeled,'Area');
    allAreas={sA.Area};
    allAreas=sort([allAreas{:}]);
    if numel(allAreas)>1
        size2ndComp=allAreas(end-1);
    else
        size2ndComp=allAreas(1);
    end
    %%
    binaryImage(logical(nID))=0;
    binaryImageO=binaryImage;
    if(numel(unique(binaryImageLabeled)==2) || size2ndComp<(sizeWholeLeaf/1000))
        for il=1:5
            nID=imdilate(nID,strel('disk',1));
            binaryImage(logical(nID))=0;
            binaryImageLabeled=bwlabel(binaryImage);
            if(numel(unique(binaryImageLabeled))>2)
                sA = regionprops(binaryImageLabeled,'Area');
                allAreas={sA.Area};
                allAreas=sort([allAreas{:}]);
                size2ndComp=allAreas(end-1);
                if(size2ndComp>(sizeWholeLeaf/1000)) %use a rough threshold here
                    break;
                end
                break;
            end
        end
    end
    bS=compImage;
    bS(nID>0)=0;
else
    bS=[];
end
%%%%%%%%%%SEARCH FOR THE LEAFLET
leafletComponentIndex=[];
labeledImage=bwlabel(binaryImage,4);
components=unique(labeledImage);
leafletComponentIndex=components(components~=(labeledImage(crossPoint(1),crossPoint(2))));
leafletComponentIndex(leafletComponentIndex==0)=[]
leafletImage=zeros(size(skeletonImage));
for co=leafletComponentIndex'
    leafletImage(labeledImage==co)=indexLeaflet;
end
%
end

