
  imageStringName='leaves/3.png';
  I = imread(imageStringName); % open the image
% imageResize=1024;
imageScale=0.5;
rgbImage= imresize(I,imageScale);
imageResize=size(rgbImage);
% figure,imshow(I);
redChannel = rgbImage(:, :, 1);
greenChannel = rgbImage(:, :, 2);
blueChannel = rgbImage(:, :, 3);

level = graythresh(rgbImage);  % find the threshhold 
BW = im2bw(rgbImage,level);    % use the threshhold to make in into binary image
BW1 = imfill(~BW,'holes'); % filling the holes 


binaryImage = bwlabel(BW1,8);     % largest connected component 
rp = regionprops(BW1,'Area','PixelIdxList');
areas = [rp.Area];
[unused,indexOfMax] = max(areas);
imshow(binaryImage);
binaryImage(binaryImage~=indexOfMax)=0;
S1= bwmorph(binaryImage,'skel',inf);
OriginalS1=S1;
boundryImage=bwperim(binaryImage,8);
% pairOfImage = [BW,BW1,b,S1];
% figure,imshow(pairOfImage);

% D = bwdist(~b); % image B (above)
% X=D(S1);
% options = statset('Display','final');
% obj = gmdistribution.fit(X,2,'Options',options);
%     idx = cluster(obj,X);
%     cluster1 = X(idx == 1,:);
%     cluster2 = X(idx == 2,:);
%     
%     if(mean(cluster1)<mean(cluster2))
%         rachis=1;
%         leaf=2;
%     else
%         rachis=2;
%         leaf=1;
%     end
%     
% %     rachis=min(mean(cluster1),mean(cluster2));
% %     leaf=max(mean(cluster1),mean(cluster2));
%     S2=zeros(size(S1));
%     S2(S1)=idx;
%     %figure,imagesc(S3);
% 
%    DR=D/max(D(:));
%    DG=D/max(D(:));
%    DB=D/max(D(:));
%    
%    DR(S2==rachis)=1;
%    DG(S2==rachis)=0;
%    DB(S2==rachis)=0;
%    DRGB=cat(3,DR,DG,DB);
%    %figure,imshow(DRGB);
%    
%    DR(S2==leaf)=0;
%    DG(S2==leaf)=1;
%    DB(S2==leaf)=0;
%    DRGB=cat(3,DR,DG,DB);
%    %figure,imshow(DRGB);
%    
%    redChannel(S2==rachis)=255;
%    greenChannel(S2==rachis)=0;
%    blueChannel(S2==rachis)=0;
%    DRGB=cat(3,redChannel,greenChannel,blueChannel);
%    %figure,imshow(DRGB);
%    
%    redChannel(S2==leaf)=0;
%    greenChannel(S2==leaf)=255;
%    blueChannel(S2==leaf)=0;
%    DRGB=cat(3,redChannel,greenChannel,blueChannel);
% % 
% figure;
% image(S1*256)
% colormap(gray)
% hold on
% plot(graph(2261).coordinate(2),graph(2261).coordinate(1),'o');
% %
% m=bwmorph(S1,'endpoints');
% 
% %
% [cccc,dddd]=bottomPoint(S1)
% [a,b]=topPixel(S1)
% [graph,map]=traverseDfs0(S1,cccc,dddd);
% t=findPath1(S1,graph,map,a,b,cccc,dddd);
% %%%

