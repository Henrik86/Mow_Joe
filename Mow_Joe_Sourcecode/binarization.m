function [ I,imageResize,binaryImage,OriginalS1,boundryImage,rgbImage,BW,BW1,imageScale ] = binarization2( imageStringName )
%We are trying to re factor the code here , so i am making the diffrent
%scripts to be run on diffrent functions.
I = imread(imageStringName); % open the image
% imageResize=1024;
% rgbImage= imresize(I, [imageResize imageResize]);
% figure,imshow(I);

imageScale=0.25;
rgbImage= imresize(I,imageScale);

level = graythresh(rgbImage);  % find the threshhold 
BW = im2bw(rgbImage,level); % use the threshhold to make in into binary image

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
imageResize=size(BW1);
binaryImage = bwlabel(BW1,8);     % largest connected component 
rp = regionprops(BW1,'Area','PixelIdxList');
areas = [rp.Area];
[~,indexOfMax] = max(areas);
binaryImage(binaryImage~=indexOfMax)=0;
S1= bwmorph(binaryImage,'skel',inf);
OriginalS1=S1;
boundryImage=bwperim(binaryImage,8);



end

