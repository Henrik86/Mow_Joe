
function [leafletStruct,imageLeaflets,imageRachis,imageBranches ] = areaMeasure(graph,imgBwLabeled,map,imageResize,SN,leafletStruct)
%SCript of Identifying leaves 
%in this script i will look at the endpoints of skeletons and then chekck
% the labels they have been assigned to . with this i will exactly know
% which leaflet has which label in bwlabel and then i make a new image from
% the labels . i will use this image in statistics .
skelEnd = zeros(numel(leafletStruct),1);
leafLetIdentifier = zeros(numel(leafletStruct),1);
for i=1:numel(leafletStruct);
     longestPath=leafletStruct(i).pathBaseEndpoint;
     skelEnd(i)  = labeltoLinearInd(longestPath(1),graph,imageResize);
     leafletStruct(i).leafletIdentifier=imgBwLabeled(skelEnd(i)); %%%%%%How can these be zero sometimes? %%Henrik
end

leaveAreas=regionprops(imgBwLabeled,'Area');
leaveEccentricity=regionprops(imgBwLabeled,'Eccentricity');
leaveEquivDiameter=regionprops(imgBwLabeled,'EquivDiameter');
leaveOrientation=regionprops(imgBwLabeled,'Orientation');
leaveMinorAxisLength=regionprops(imgBwLabeled,'MinorAxisLength');
leaveMajorAxisLength=regionprops(imgBwLabeled,'MajorAxisLength');
PerimeterLeaflet=regionprops(imgBwLabeled,'Perimeter');
centers=regionprops(imgBwLabeled,'centroid');
% distToTerminal{1}={};
for j=1:numel(leafletStruct)
        if(leafletStruct(j).crossingPoint~=0)
            pathToTerminal=findPath1(SN,graph,map,leafletStruct(1).cutPoint, leafletStruct(j).crossingPoint);
            leafletStruct(j).distToTerminal=length(pathToTerminal);
        end
end
imageLeaflets=zeros(size(imgBwLabeled));
imageRachis=zeros(size(imgBwLabeled));
rachisIdentifier=imgBwLabeled(graph(1).coordinate(1),graph(1).coordinate(2));
imageRachis=imgBwLabeled==rachisIdentifier;
imageBranches=imgBwLabeled>0;

for i=1:numel(leafletStruct)
    imageLeaflets(imgBwLabeled==leafletStruct(i).leafletIdentifier)=leafletStruct(i).leafletIdentifier;
    leafletStruct(i).area=leaveAreas(leafletStruct(i).leafletIdentifier).Area;
    leafletStruct(i).centers=centers(leafletStruct(i).leafletIdentifier).Centroid;
    leafletStruct(i).Eccentricity=leaveEccentricity(leafletStruct(i).leafletIdentifier).Eccentricity;
    leafletStruct(i).EquivDiameter=leaveEquivDiameter(leafletStruct(i).leafletIdentifier).EquivDiameter;
    leafletStruct(i).Orientation=leaveOrientation(leafletStruct(i).leafletIdentifier).Orientation;
    leafletStruct(i).MinorAxisLength=leaveMinorAxisLength(leafletStruct(i).leafletIdentifier).MinorAxisLength;
    leafletStruct(i).MajorAxisLength=leaveMajorAxisLength(leafletStruct(i).leafletIdentifier).MajorAxisLength;
    leafletStruct(i).PerimeterLeaflet=PerimeterLeaflet(leafletStruct(i).leafletIdentifier).Perimeter;
end
imageBranches=imageBranches & ~imageLeaflets  & ~imageRachis;
 %figure,
% plot(leaveAreas,distToTerminal);

%next time we should do this for all the leaves , so we first run the
%workspace on so many leaves then we run the code and then we have to plot
%the leaflet numbers and the plot for all the leaflets joined tgthr.
end