function [ BWN ] = bridgePixel( BW )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[rn,cn]=find(BW);

BWL=bwlabel(BW);
BWN=BW;
components=unique(BWL);
components(components==0)=[];
if(numel(components)>=2)
    while(numel(components)>=2)
        c1=components(1);
        [points1X,points1Y]=find(BWL==c1);
        points1=[points1X,points1Y];

        for c2=2:numel(components)
            [points2X,points2Y]=find(BWL==components(c2));
             distMat=pdist2([points1X,points1Y],[points2X,points2Y]);
             if(c2==2)
                 [minDist]=min(distMat(:));
                 minComponent=components(c2);
             end
             if(min(distMat(:))<=minDist)
                minComponent=components(c2);
                minDist=min(distMat(:));
             end
        end
        [points2X,points2Y]=find(BWL==minComponent);
        points2=[points2X,points2Y];
        distMatN=pdist2(points1,points2);
        [r,c]=find(distMatN<=minDist);
        
        if(numel(r)>1)
            r=r(1);
        end
        if(numel(c)>1)
            c=c(1);
        end
        
%         figure;
%         imagesc(BWL)
%         hold on
%         plot(points1(r,2),points1(r,1),'o')
%         plot(points2(c,2),points2(c,1),'o')
        
        BWN=drawLine(BWN,points1(r,1),points1(r,2),points2(c,1),points2(c,2));
        %%%%%
        BWL=bwlabel(BWN);
        components=unique(BWL);
        components(components==0)=[];
    end
%search for the nearest component


end

end

