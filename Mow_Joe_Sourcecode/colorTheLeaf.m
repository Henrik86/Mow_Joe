%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% this script will label each of the leaves diffrently , so it will call
function [ imgBwLabeled,leafletStruct ] = colorTheLeaf(graph,binaryImage,boundryImage,SNOriginal,map,stemLength,leafletStruct,folderPath,bottomPoint)
% the splitcomponent function and then with help of bwlabel and region
% porps it will label each of the areas diffrently.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Or=OriginalBinaryImage;
% OriginalBinaryImage=binaryImage;
% split1=zeros(numel(cutArray));
binaryImageO=binaryImage;
i=1;
a=[0,0]; 
markerSize=2;
%boundary image should have only one component
[ boundryImage ] = largestComponent( boundryImage );

% figure;
% imshow(binaryImage)
componentImageLeaflet=binaryImage;
figure('visible','off');
imshow(~binaryImage)
hold on
for il=1:numel(leafletStruct)
    if(strcmp(leafletStruct(il).class,'leaflet'))
        cutpoint=leafletStruct(il).cutPoint;
        pX=graph(cutpoint).coordinate(1);
        pY=graph(cutpoint).coordinate(2);
        if(leafletStruct(il).crossingPoint==0)
            crossingPointCP=bottomPoint;
        else
            crossingPointCP=[graph(leafletStruct(il).crossingPoint).coordinate(1),graph(leafletStruct(il).crossingPoint).coordinate(2)];
        end
        [binaryImage,splitPoint1,splitPoint2,leafletImage] = splitComponent(binaryImageO,boundryImage,SNOriginal,[pX,pY],binaryImageO,il,crossingPointCP);
        plot(splitPoint2(2),splitPoint2(1),'o','MarkerEdgeColor',[1 0 0],'MarkerFaceColor',[1 0 0],'MarkerSize',markerSize)
        plot(splitPoint1(2),splitPoint1(1),'o','MarkerEdgeColor',[1 0 0],'MarkerFaceColor',[1 0 0],'MarkerSize',markerSize)
        plot(pY,pX,'o','MarkerEdgeColor',[0 0 1],'MarkerFaceColor',[0 0 1],'MarkerSize',markerSize)
        %
        %componentImageLeaflet=componentImageLeaflet+leafletImage;
        componentImageLeaflet(binaryImage==0)=0;
% 
%       figure
%       imshow(~binaryImage)
%       hold on
%       plot(pY,pX,'ro')
%       plot(splitPoint1(2),splitPoint1(1),'o')
%       plot(splitPoint2(2),splitPoint2(1),'o')
    leafletStruct(il).cutpointCoord=graph(cutpoint).coordinate;
    leafletStruct(il).splitPoint1=splitPoint1;
    leafletStruct(il).splitPoint2=splitPoint2;
    end
    i=i+1;
%     areasofleaves=regionprops(imgBwLabeled,'Area');
%     figure,imshow(binaryImage);
end
counter=1;
leafletsToDelete=[];


[ SNbranch] = ImageFromGraphClassification( graph, size(binaryImage),{'branch'} );

componentImageBranch=zeros(size(boundryImage));

for cl=1:numel(leafletStruct)
    crossing=leafletStruct(cl).crossingPoint;
    if(crossing ~=0)
        pX=graph(crossing).coordinate(1);
        pY=graph(crossing).coordinate(2);
        cutpoint=leafletStruct(cl).cutPoint;
        pXC=graph(cutpoint).coordinate(1);
        pYC=graph(cutpoint).coordinate(2);
        [binaryImageT,splitPointBranch1,splitPointBranch2] = splitComponentBranch(binaryImageO,boundryImage,SNbranch,graph,map,[pX,pY],cl,binaryImageO,stemLength,SNOriginal,[pXC,pYC],cl);
        leafletStruct(cl).crossingPointCoord=graph(crossing).coordinate;
        %componentImageBranch=componentImageBranch+branchImage;
        componentImageLeaflet(binaryImageT==0)=0;
%        
        if(~isempty(splitPointBranch1) && ~isempty(splitPointBranch2))
%             figure;
%           imshow(boundryImage)
%           hold on
         plot(splitPointBranch2(2),splitPointBranch2(1),'o','MarkerEdgeColor',[1 0 0],'MarkerFaceColor',[1 0 0],'MarkerSize',markerSize)
         plot(splitPointBranch1(2),splitPointBranch1(1),'o','MarkerEdgeColor',[1 0 0],'MarkerFaceColor',[1 0 0],'MarkerSize',markerSize)
         plot(pY,pX,'o','MarkerEdgeColor',[0 1 0],'MarkerFaceColor',[0 1 0],'MarkerSize',markerSize)
         binaryImage=binaryImageT;
         if(strcmp(leafletStruct(cl).class,'smallLeaflet'))
                leafletStruct(cl).splitPoint1=splitPointBranch1;
                leafletStruct(cl).splitPoint2=splitPointBranch2;
                leafletStruct(cl).cutpointCoord=graph(crossing).coordinate;
         end
        else
            leafletsToDelete=[leafletsToDelete,cl];
        end
        counter=counter+1;
    else
        leafletStruct(cl).crossingPointCoord=[NaN NaN];
    end
%   h=figure;imshow(binaryImage);    
end
hold off
saveas(gcf,strcat(folderPath,'\','cutted.pdf'),'pdf');
close;
leafletStruct(leafletsToDelete)=[];
imgBwLabeled=bwlabel(componentImageLeaflet,4);

maxBranchIndex=numel(leafletStruct);
componentImageBranch(componentImageLeaflet>=1)=0;
componentImageLeaflet(componentImageLeaflet>=1)=componentImageLeaflet(componentImageLeaflet>=1)+maxBranchIndex;
componentImage=binaryImageO+componentImageBranch+(componentImageLeaflet);

% imgBwLabeled=bwlabel(binaryImage,4);
% % segment=imagesc(imgBwLabeled);
% hFig=figure;
% subplot(1,2,2), imagesc(imgBwLabeled)
% subplot(1,2,1), imshow(rgbImage)
% % saveas(hFig,strcat(folderPath,'\','imagesec.png'),'png');
% folderPath=strcat('C:\Users\nasim\Documents\MATLAB\new\','\',imageStringName);
% saveas(hFig,folderPath,'png');
end