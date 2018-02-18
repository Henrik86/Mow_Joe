
function [ imgBwLabeled,folderPath,leafletStruct,bottomPointCoordinates,topPointCoordinates] = writeIDtoImage(boundryImage,imgBwLabeled,I,output,name,graph,rgbImage,bottomPointLabel,leafletStruct,shapePoints,terminalPointP,topPointCoordinates)
%this script writes the number of each leflet on top of the leave it at
%the,
%end it saves it.
thickendboundry=bwmorph(boundryImage,'thicken');
%leaveCenter=centers(leafLetIdentifier);
[leafletStruct] = leafletIding(graph,leafletStruct);


leafIDImage=figure('visible','off');
% subplot(1,3,2), imagesc(imgBwLabeled)
% subplot(1,3,3), imshow(rgbImage);
% subplot(1,3,1), imshow(imoverlay(I,boundryImage,[1,0,1]));
subplot(1,2,2), imagesc(imgBwLabeled)
subplot(1,2,1), 
%imshow(imoverlay(cat(3,double(I),double(I),double(I)),thickendboundry,[1,0,1]));
imshow(cat(3,double(~thickendboundry),double(~thickendboundry),double(~thickendboundry)))
hold on


 for x = 1: numel(leafletStruct)
   %text(leaveCenter(x).Centroid(1),leaveCenter(x).Centroid(2),num2str(leafletID(x)))
  text(leafletStruct(x).centers(1),leafletStruct(x).centers(2),num2str(leafletStruct(x).leafletID))
  x1= leafletStruct(x).splitPoint1(1);
  y1= leafletStruct(x).splitPoint1(2);
  x2= leafletStruct(x).splitPoint2(1);
  y2= leafletStruct(x).splitPoint2(2);
  visulisePoint(rgbImage,x1,y1,'r');
  visulisePoint(rgbImage,x2,y2,'r');
  %
  
  px=graph(leafletStruct(x).cutPoint).coordinate(1);
  py=graph(leafletStruct(x).cutPoint).coordinate(2);
  visulisePoint(rgbImage,px,py,'b');
  %
  if(~isempty(leafletStruct(x).branchStartPointCord))
     pxBranch=leafletStruct(x).branchStartPointCord(1);
     pyBranch=leafletStruct(x).branchStartPointCord(2);
     visulisePoint(rgbImage,pxBranch,pyBranch,'g');
  end
   %
  if(~isempty(leafletStruct(x).leafStartPointCord))
     pxLeaf=leafletStruct(x).leafStartPointCord(1);
     pyLeaf=leafletStruct(x).leafStartPointCord(2);
     visulisePoint(rgbImage,pxLeaf,pyLeaf,'g');
  end
  %
  if(leafletStruct(x).crossingPoint~=0)
      px=graph(leafletStruct(x).crossingPoint).coordinate(1);
      py=graph(leafletStruct(x).crossingPoint).coordinate(2);
      visulisePoint(rgbImage,px,py,'b');
  end
  
 end
 
 if(size(boundryImage,2)> graph(bottomPointLabel).coordinate(2)+10)
     space=10;
 else
     space=0;
 end
 %
 bottomPointCoordinates=[graph(bottomPointLabel).coordinate(1),graph(bottomPointLabel).coordinate(2)];
 visulisePoint(rgbImage,bottomPointCoordinates(1),bottomPointCoordinates(2),'b')
 maxID=max([leafletStruct.leafletID]);
 maxID=maxID+1;
 text(graph(bottomPointLabel).coordinate(2)+space,graph(bottomPointLabel).coordinate(1),num2str(maxID))
 %
 visulisePoint(rgbImage,topPointCoordinates(1),topPointCoordinates(2),'b')
 maxID=maxID+1;
 text(topPointCoordinates(2)+space,topPointCoordinates(1),num2str(maxID))
%  if(nrows(terminalPointP)>0)
%     [v,index]=sort(rP);
%     topPointCoordinates=[rP(index(1)),cP(index(1))];
%     visulisePoint(rgbImage,topPointCoordinates(1),topPointCoordinates(2),'b')
%     maxID=maxID+1;
%     text(topPointCoordinates(2)+space,topPointCoordinates(1),num2str(maxID))
%  else
%      topPointCoordinates=[NaN,NaN];
%  end
for p=shapePoints'
    visulisePoint(rgbImage,p(1),p(2),'b')
    maxID=maxID+1;
    text(p(2)+space,p(1),num2str(maxID))
end
 %

%%%%%

%  T = table(distToTerminal,leaveAreas,'RowNames',x);
%   plot(splitPoints1(x,1),splitPoints1(x,2),'0');

hold off


folderPath=strcat(output,filesep,name,filesep,name);
saveas(leafIDImage,folderPath,'jpg');
close;
% saveas(overlay,folderPath,'jpg');
end
