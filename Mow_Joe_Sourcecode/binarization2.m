function [ I,imageResize,binaryImage,OriginalS1,boundryImage,rgbImage,BW,BW1,imageScale,greenImage ] = binarization2( imageStringName )
%We are trying to re factor the code here , so i am making the diffrent
%scripts to be run on diffrent functions.
originalI = imread(imageStringName); % open the image
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
I= imresize(originalI,imageScale);
OriginalS1=I;
rgbImage=I;
greenImage=I(:,:,2)-I(:,:,1)/2-I(:,:,3)/2;

level = graythresh(greenImage);  % find the threshhold 
BW = im2bw(greenImage,level); % use the threshhold to make in into binary image


%BW=~BW;

binaryImage = bwlabel(BW,8);  % largest connected component 
% figure,imshow(binaryImage);
rp = regionprops(binaryImage,'Area','PixelIdxList');

areas = [rp.Area];
[svals,idx] = sort(areas,'descend'); 
% figure,imagesc(binaryImage);

binaryImage(binaryImage~=idx(1))=0;

% figure,imshow(binaryImage);
% BW2 = imclearborder(binaryImage);


BW1 = imfill(binaryImage,'holes'); % filling the holes 
imageResize=size(BW1);
%figure,imshow(binaryImage);


binaryImage = bwlabel(BW1,8);     % largest connected component 
rp = regionprops(binaryImage,'Area','PixelIdxList');
areas = [rp.Area];
[svals,idx] = sort(areas,'descend'); 
binaryImage(binaryImage~=idx(1))=0;
%figure,imshow(binaryImage);

boundryImage=bwperim(binaryImage,8);
%%%%%%%%%% because of bridging the skeleton image can have values that are
%%%%%%%%%% 1 in its image but not in the binary image !!! i solve that by
%%%%%%%%%% making every 1 in the binary that is 1 in the skeleton. Consider
%%%%%%%%%% if bridging is necessary. %%%% Henrik



end

