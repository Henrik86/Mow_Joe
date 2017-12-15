function [ rachis,leaf,S2,skelCluster,imgCluster,D ] = clusterFinder( image,imageDistance,rgbImage )
%finds the clusters with according to the distance;
%   Detailed explanation goes here
%%%
imgBW=bwlabel(imageDistance);
bwR=regionprops(imgBW,'ConvexImage')
%%%
D = bwdist(~imageDistance); % image B (above)
image=logical(image);
X=D(image);
SIGMA=cat(3,1,1);
MU=[min(X);max(X)]
S = struct('mu',MU,'Sigma',SIGMA);
obj = gmdistribution.fit(X,2,'Start',S,'Regularize',0.01) ;
%options = statset('Display','final'); 
%obj = gmdistribution.fit(X,2,'Regularize',0.01,'Options',options);%changed by Henrik
    idx = cluster(obj,X);
    cluster1 = X(idx == 1,:);
    cluster2 = X(idx == 2,:);
    
    if(mean(cluster1)<mean(cluster2))
        rachis=1;
        leaf=2;
    else
        rachis=2;
        leaf=1;
    end
    S2=zeros(size(image));
    S2(image)=idx;
    S2=imdilate(S2,strel('disk',3));
   DT=D;
   DR=1-(DT/max(DT(:)));
   DG=1-(DT/max(DT(:)));
   DB=1-(DT/max(DT(:)));
   
   DR(S2==rachis)=1;
   DG(S2==rachis)=0;
   DB(S2==rachis)=0;
   
   DR(S2==leaf)=0;
   DG(S2==leaf)=1;
   DB(S2==leaf)=0;
   skelCluster=cat(3,DR,DG,DB);

   if(numel(size(rgbImage))==2)
       imgCluster=cat(3,rgbImage,rgbImage,rgbImage);
   else
       
       redChannel = rgbImage(:, :, 1);
       greenChannel = rgbImage(:, :, 2);
       blueChannel = rgbImage(:, :, 3);

       redChannel(S2==rachis)=255;
       greenChannel(S2==rachis)=0;
       blueChannel(S2==rachis)=0;
       imgCluster=cat(3,redChannel,greenChannel,blueChannel);
       %figure,imshow(DRGB);

       redChannel(S2==leaf)=0;
       greenChannel(S2==leaf)=255;
       blueChannel(S2==leaf)=0;
       imgCluster=cat(3,redChannel,greenChannel,blueChannel);
   end

end

