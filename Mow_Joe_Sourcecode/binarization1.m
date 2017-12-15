function [ I,imageResize,binaryImage,OriginalS1,boundryImage,rgbImage,BW,BW1,imageScale,imgG] = binarization( imageStringName )
%We are trying to re factor the code here , so i am making the diffrent
%scripts to be run on diffrent functions.
I = imread(imageStringName); % open the image
originalI=I;
% imageResize=1024;
% rgbImage= imresize(I, [imageResize imageResize]);
% figure,imshow(I);
if(size(originalI,2)>size(originalI,1)) %% rotate images
    originalI=imrotate(originalI,-90);
end
if(size(originalI,2)>4000 || size(originalI,1)>4000)
    imageScale=0.25;
elseif(size(originalI,2)>2000 || size(originalI,1)>2000)
    imageScale=0.5;
else
    imageScale=1;
end
%%%%%%%%
rgbImage= imresize(I,imageScale);

imgG=rgb2gray(rgbImage);
level = graythresh(imgG);  % find the threshhold 
BW = im2bw(imgG,level); % use the threshhold to make in into binary image
BW=~BW;
BW = imfill(BW,'holes');
binaryImage = bwlabel(BW,8);  % largest connected component 
% figure,imshow(binaryImage);

rp = regionprops(binaryImage,'Area','PixelIdxList');

areas = [rp.Area];
[svals,idx] = sort(areas,'descend'); 
%figure,imagesc(binaryImage);

binaryImage(binaryImage~=idx(1))=0;

%figure,imshow(binaryImage);
% figure,imshow(BW2);
% BW1 = imfill(~BW2,'holes'); % filling the holes 



% S1= bwmorph(binaryImage,'skel',inf);
% OriginalS1=S1;
% boundryImage=bwperim(binaryImage,8);

BW1=binaryImage;
imageResize=size(BW1);
binaryImage = bwlabel(BW1,8);     % largest connected component 
rp = regionprops(BW1,'Area','PixelIdxList');
areas = [rp.Area];
[~,indexOfMax] = max(areas);
if length(indexOfMax) > 0
    binaryImage(binaryImage~=indexOfMax)=0;
    
else 
    BW=~BW;
    binaryImage = bwlabel(BW,8);  % largest connected component 
    % figure,imshow(binaryImage);
    rp = regionprops(binaryImage,'Area','PixelIdxList');
    areas = [rp.Area];
    [svals,idx] = sort(areas,'descend'); 
    % figure,imagesc(binaryImage);
    binaryImage(binaryImage~=idx(1))=0;
    % figure,imshow(binaryImage);
    BW2 = imclearborder(binaryImage);
    BW1 = imfill(BW2,'holes'); % filling the holes     
   
end

    S1= bwmorph(binaryImage,'skel',inf);
    OriginalS1=S1;
    boundryImage=bwperim(binaryImage,8);

end

