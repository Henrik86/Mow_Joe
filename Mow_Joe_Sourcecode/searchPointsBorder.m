function [ midPoint,dlP,drP ] = searchPointsBorder( outlineImage, topPoint,splitPoint1,splitPoint2, terminalCutPoint,outputFolder,rgbImage )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
outlineImageO=outlineImage;
% figure;
% imshow(outlineImageO)
% hold on
% plot(topPoint(2),topPoint(1),'o')
% plot(splitPoint1(2),splitPoint1(1),'o')
% plot(splitPoint2(2),splitPoint2(1),'o')
pointToDelete=zeros(size(outlineImage));
pointToDelete(topPoint(1),topPoint(2))=1;
pointToDelete(splitPoint1(1),splitPoint1(2))=1;
pointToDelete(splitPoint2(1),splitPoint2(2))=1;
pointToDelete=imdilate(pointToDelete,strel('disk',3));
outlineImage(pointToDelete==1)=0;

outlineLabeled=bwlabel(outlineImage);
ar=regionprops(outlineImage,'Area');
[valueA,indexA]=sort([ar.Area],'descend');
[x1 y1]=find(outlineLabeled==indexA(1));
[x2 y2]=find(outlineLabeled==indexA(2));
[x3 y3]=find(outlineImageO);
%
borderPoints=[x3 y3];
borderPoints1=[x1 y1];
borderPoints2=[x2 y2];
%
L=terminalCutPoint(1:2)-topPoint(1:2);
U=L/norm(L);
%
vecDir=topPoint-terminalCutPoint;
normV=[-vecDir(2), vecDir(1)];
%
maxDistE=0;
point1=[];
point2=[];
indexP1=1;
%
allThetaInDegrees=[];
for borderPoint1=borderPoints1'
    
        %l=borderPoint+c*normV
    %c*normV=l-borderPoint
    %(l-borderPoint)/normV=c
    allP=[];
    maxNP=0;
    indexP2=1;
    for borderPoint2=borderPoints2'
        if(indexP1~=indexP2)
            %x = linsolve(normV,(borderPoint2-borderPoint1)');
            v1=vecDir;
            v2=(borderPoint2-borderPoint1)';
            CosTheta = dot(v1,v2)/(norm(v1)*norm(v2));
            ThetaInDegrees = acos(CosTheta)*180/pi;
            allThetaInDegrees=[allThetaInDegrees,ThetaInDegrees];
            %tol = 1e-4 % <- select appropriate small tolerance
            %rank(bsxfun(@minus,data,data(1,:)),tol)==1
            %np=abs(dot(normV,(borderPoint2-borderPoint1)')/(norm(normV)*norm((borderPoint2-borderPoint1)')))
            if(ThetaInDegrees>=89 &&  ThetaInDegrees<=91)
                distE=sqrt((borderPoint2(1)-borderPoint1(1))^2+(borderPoint2(2)-borderPoint1(2))^2);
                if(distE>=maxDistE)
                    maxDistE=distE;
                    point1=borderPoint1;
                    point2=borderPoint2;
                end
            end
        %end
        end
        indexP2=indexP2+1;
    end

end
%intersect of the lines
%y=p1+x*p2, y=m1+x*m2
%x*p2-x*m2=m1-p1
%x(p2-m2)=m1-p1
vec1=topPoint-terminalCutPoint;
vec2=point2-point1;
md=linsolve([vec2,-vec1'],terminalCutPoint'-point1);

cutPoint=terminalCutPoint+md(2)*vec1;
%cutPoint=point1+md(1)*vec2;
% 
% figure;
% imshow(outlineImage);
% hold on
% plot(cutPoint(2),cutPoint(1),'o')
linePoint2=[cutPoint(1)+10,cutPoint(2)-10]
linePoint3=[cutPoint(1)-10,cutPoint(2)+10]
linePoint4=[cutPoint(1)+10,cutPoint(2)+10]
linePoint5=[cutPoint(1)-10,cutPoint(2)-10]
%line([cutPoint(2) linePoint2(2)],[cutPoint(1) linePoint2(1)])
%line([cutPoint(2) linePoint3(2)],[cutPoint(1) linePoint3(1)])

vecLR2=linePoint2-round(cutPoint);
vecLR3=linePoint3-round(cutPoint);
vecLL2=linePoint4-round(cutPoint);
vecLL3=linePoint5-round(cutPoint);
%



%
drP1=[];
drP2=[];
%
for borderPoint1=borderPoints'
    
    if(isempty(drP1))
        vecTest=borderPoint1-cutPoint';
        tol = 1e-3; %
        %if((rank(bsxfun(@minus,data,data(:,1)),tol)==1))
        if(dot(vecTest,vecLR2)/(norm(vecTest)*norm(vecLR2)) > 1 - tol)
                drP1=[drP1;borderPoint1'];
        end
    end
    if(isempty(drP2))
        vecTest=borderPoint1-cutPoint';
        tol = 1e-3; %
        %if((rank(bsxfun(@minus,data,data(:,1)),tol)==1))
        if(dot(vecTest,vecLR3)/(norm(vecTest)*norm(vecLR3)) > 1 - tol)
                
                drP2=[drP2;borderPoint1'];
        end
    end
%     if(~isempty(drP1) && ~isempty(drP2))
%        break;
%     end
end
%
dlP1=[];
dlP2=[];
%
for borderPoint1=borderPoints'
    
    if(isempty(dlP1))
        vecTest=borderPoint1-cutPoint';
        tol = 1e-3; %
        %if((rank(bsxfun(@minus,data,data(:,1)),tol)==1))
        if(dot(vecTest,vecLL2)/(norm(vecTest)*norm(vecLL2)) > 1 - tol)
                dlP1=[dlP1;borderPoint1'];
        end
    end
    if(isempty(dlP2))
        vecTest=borderPoint1-cutPoint';
        tol = 1e-3; %
        %if((rank(bsxfun(@minus,data,data(:,1)),tol)==1))
        if(dot(vecTest,vecLL3)/(norm(vecTest)*norm(vecLL3)) > 1 - tol)
%                 figure;
%                 imshow(outlineImageO);
                dlP2=[dlP2;borderPoint1'];
%                 line([cutPoint(2) borderPoint1(2)],[cutPoint(1) borderPoint1(1)])
        end
    end
%     if(~isempty(drP1) && ~isempty(drP2))
%        break;
%     end
end
% figure;
% imshow(outlineImageO);
% hold on
% plot(drP1(2),drP1(1),'o')
% 
% 
figure('visible','off');
imshow(rgbImage);
hold on
plot(cutPoint(2),cutPoint(1),'o','MarkerEdgeColor','k','MarkerFaceColor',[0 0 1],'MarkerSize',5)
plot(topPoint(2),topPoint(1),'o','MarkerEdgeColor','k','MarkerFaceColor',[0 0 1],'MarkerSize',5)
plot(terminalCutPoint(2),terminalCutPoint(1),'o','MarkerEdgeColor','k','MarkerFaceColor',[0 0 1],'MarkerSize',5)
plot(point1(2),point1(1),'o','MarkerEdgeColor','k','MarkerFaceColor',[0 0 1],'MarkerSize',5)
plot(point2(2),point2(1),'o','MarkerEdgeColor','k','MarkerFaceColor',[0 0 1],'MarkerSize',5)
plot(drP1(2),drP1(1),'o','MarkerEdgeColor','k','MarkerFaceColor',[0 0 1],'MarkerSize',5)
plot(drP2(2),drP2(1),'o','MarkerEdgeColor','k','MarkerFaceColor',[0 0 1],'MarkerSize',5)
plot(dlP1(2),dlP1(1),'o','MarkerEdgeColor','k','MarkerFaceColor',[0 0 1],'MarkerSize',5)
plot(dlP2(2),dlP2(1),'o','MarkerEdgeColor','k','MarkerFaceColor',[0 0 1],'MarkerSize',5)
line([topPoint(2) terminalCutPoint(2)],[topPoint(1) terminalCutPoint(1)])
line([point1(2) point2(2)],[point1(1) point2(1)])
line([drP1(2) drP2(2)],[drP1(1) drP2(1)])
line([dlP1(2) dlP2(2)],[dlP1(1) dlP2(1)])
saveas(gcf,[outputFolder,filesep,'shapePoints.','png']);
close;
% %%%%%%%%%
%%sort mid points by x value
midPoint=[point1';point2'];
[valueDM,indexDMl]=sort(midPoint(:,2),'descend');
midPoint=midPoint(indexDMl,:);
%
%sort ange points by y value
dlP=[dlP1;dlP2];
[valueDl,indexDl]=sort(dlP(:,1),'descend');
dlP=dlP(indexDl,:);
drP=[drP1;drP2];
[valueDr,indexDr]=sort(drP(:,1),'descend');
drP=drP(indexDr,:);
