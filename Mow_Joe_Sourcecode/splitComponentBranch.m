function [ bS,minPoint1,minPoint2] = splitComponentBranch(compImage,boundaryImage,skeletonImageBranch,graph,map,skPoint,crosslabel,binaryImage,stemLength,skeletonImage,cutPoint,indexBranch )
%UNTITLED Splits the connected component at a certain point using the
%skeleton and the boundary image it also checks the classification of the
%nearest point to calculate the branching point . so if its is rachis it
%goes to the next point and checks if it is branching point.
%   Detailed explanation goes here

% [boundaryPointsY,boundaryPointsX]=find(boundaryImage);
% boundaryPoints=[boundaryPointsY,boundaryPointsX];
% %
% D=pdist2(boundaryPoints,skPoint);
% [~,ID] =sort(D);
% minPoint1=boundaryPoints(ID(1),:);
% %%%%%search second Point
% for p=ID'
%     if(pdist2(minPoint1,boundaryPoints(p,:))>10)
%         minPoint2=boundaryPoints(p,:);
%         break;
%     end
% end
% %%%%%%%%%SPLIT%%%%%%
% nI=skeletonImage | boundaryImage;
% nID=drawLine(zeros(size(nI)),minPoint1(1), minPoint1(2), minPoint2(1), minPoint2(2));
% bS=compImage;
% bS(nID>0)=0;
% 
% end



[boundaryPointsY,boundaryPointsX]=find(boundaryImage);
boundaryPoints=[boundaryPointsY,boundaryPointsX];
D=pdist2(boundaryPoints,skPoint);
[~,ID] =sort(D);

%%%%%I need to search for the nearest point on the skeleton that is branch
[skelPointsY,skelPointsX]=find(skeletonImageBranch);
skelPoints=[skelPointsY,skelPointsX];
for i=1 : length(ID)
    minPoint1=boundaryPoints(ID(i),:);
    DSkel=pdist2(skelPoints,minPoint1);
    [~,IDskel] =sort(DSkel);
    minPointskel1=skelPoints(IDskel(1),:);
    labelSkel=map(minPointskel1(1),minPointskel1(2));
    if strcmp(graph(labelSkel).subclassify,(strcat('branch',num2str(crosslabel)))) || strcmp(graph(labelSkel).subclassify,(strcat('smallLeafletBranch',num2str(crosslabel))))
        break;
    end
end
% while (~strcmp(graph(skpoint).classify,'branch'))
%     counter=counter+1;  
% end
% minPoint1=boundaryPoints(ID(counter),:);

%%%%%search second Point
minPoint2=[];
%%%First try to search the branch cut point
for p=ID'
    if(pdist2(minPoint1,boundaryPoints(p,:))>pdist2(minPoint1,minPointskel1) && pdist2(minPoint1,boundaryPoints(p,:))>pdist2(boundaryPoints(p,:),minPointskel1))
    %if(pdist2(minPoint1,boundaryPoints(p,:))>3) %%%THIS IS HARD CODED BE CAREFUL REPLACE THAT
        minPoint2T=boundaryPoints(p,:);
        %there 
        DSkel=pdist2(skelPoints,minPoint2T);
        [~,IDskel2] =sort(DSkel);
        minPointskel2=skelPoints(IDskel2(1),:);
        labelSkel2=map(minPointskel2(1),minPointskel2(2));
        if (strcmp(graph(labelSkel2).subclassify, (strcat('branch',num2str(crosslabel))) ))
            %%%%%%
            
            skeletonImageTemp=skeletonImage;
            lineImage=zeros(size(skeletonImage));
            lineImage=drawLine(lineImage,minPoint1(1),minPoint1(2),minPoint2T(1),minPoint2T(2));
            skeletonImageTemp(logical(lineImage))=0;
            newComps=bwlabel(skeletonImageTemp);
            if(numel(unique(newComps))>=3)
                minPoint2=boundaryPoints(p,:);
                break;
            end

%             nI=skeletonImage | boundaryImage;
%             nID=drawLine(zeros(size(nI)),minPoint1(1), minPoint1(2), minPoint2T(1), minPoint2T(2));
%             bS=boundaryImage;
%             bS(nID>0)=0;
%             bSW=bwlabel(bS);
%             sR=regionprops(bSW,'Area');
%             [vA,iA]=sort([sR.Area],'descend');
%             if(numel(iA)>1)
%                 lenLeaf=numel(bSW(bSW==iA(2)));
%                 if(lenLeaf>stemLength/30)
%                     'FOUND'
%                      minPoint2=boundaryPoints(p,:);
%                      break
%                 end
%             end
        end
    end
end
if(isempty(minPoint2))%try to search with a hardcoded threshold
    minPoint2=[];
    %%%First try to search the branch cut point
    for p=ID'
        if(pdist2(minPoint1,boundaryPoints(p,:))>3) %%%THIS IS HARD CODED BE CAREFUL REPLACE THAT
            minPoint2T=boundaryPoints(p,:);
            %there 
            DSkel=pdist2(skelPoints,minPoint2T);
            [~,IDskel2] =sort(DSkel);
            minPointskel2=skelPoints(IDskel2(1),:);
            labelSkel2=map(minPointskel2(1),minPointskel2(2));
            if (strcmp(graph(labelSkel2).subclassify, (strcat('branch',num2str(crosslabel))) ))
                %%%%%%

                skeletonImageTemp=skeletonImage;
                lineImage=zeros(size(skeletonImage));
                lineImage=drawLine(lineImage,minPoint1(1),minPoint1(2),minPoint2T(1),minPoint2T(2));
                skeletonImageTemp(logical(lineImage))=0;
                newComps=bwlabel(skeletonImageTemp);
                if(numel(unique(newComps))>=3)
                    minPoint2=boundaryPoints(p,:);
                    break;
                end
            end
        end
    end
end
%%%%%%%%%SPLIT%%%%%%
nI=skeletonImage | boundaryImage;
%     figure;
%     imshow(nI)
%    hold on
%     plot(minPoint1(2), minPoint1(1),'ro')
%     plot(minPoint2(2), minPoint2(1),'go')
if( ~isempty(minPoint2))
    
    nID=drawLine(zeros(size(nI)),minPoint1(1), minPoint1(2), minPoint2(1), minPoint2(2));
    %nID=imdilate(nID,strel('square',3));
    %nID=bwmorph(nID,'skel',Inf);
    nID=imdilate(nID,strel('square',3));
    nID=bwmorph(nID,'skel',Inf);
    nED=bwmorph(nID,'endpoints');
    nID=nID & ~(nID&nED);
    binaryImage(logical(nID))=0;
    
    if(numel(unique(bwlabel(binaryImage,4)))==2)
        
        for il=1:7
            nID=imdilate(nID,strel('square',2));
            binaryImage(logical(nID))=0;
            if(numel(unique(bwlabel(binaryImage,4)))>2)
                break;
            end
        end
    end
    bS=compImage;
    bS(nID>0)=0;
else
    bS=[];
end
%%%

%%%%%%%%%%SEARCH FOR THE LEAFLET
% branchComponentIndex=[];
% labeledImage=bwlabel(binaryImage);
% components=unique(labeledImage);
% branchComponentIndex=components(components==(labeledImage(cutPoint(1),cutPoint(2))));
% branchComponentIndex(branchComponentIndex==0)=[];
% branchImage=zeros(size(skeletonImage));
% for co=branchComponentIndex'
%     branchImage(labeledImage==co)=indexBranch;
% end
%
end
