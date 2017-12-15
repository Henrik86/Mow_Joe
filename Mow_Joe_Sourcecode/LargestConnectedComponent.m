function [ largeConnectedComponent ,smallerConnectedComponent] = LargestConnectedComponent( image )
%finds the largest connected component and the removed thing
%   Detailed explanation goes here
largeConnectedComponent = bwlabel(image,8);     % largest connected component 
rp = regionprops(largeConnectedComponent,'Area','PixelIdxList');
areas = [rp.Area];
[~,indexOfMax] = max(areas);
largeConnectedComponent(largeConnectedComponent~=indexOfMax)=0;
% figure,imshow(largeConnectedComponent);
smallerConnectedComponent=image-largeConnectedComponent;


% figure,imshow(removed);
% figure,imshow(largeConnectedComponent);
% CC = bwconncomp(BW);
% numPixels = cellfun(@numel,CC.PixelIdxList);
% [biggest,idx] = max(numPixels);
% BW(CC.PixelIdxList{idx}) = 0;

% ORiginalImage=image;
% c = bwconncomp(image,8);
% numOfPixels = cellfun(@numel,c.PixelIdxList);
% [unused,indexOfMax] = max(numOfPixels);
% image( c.PixelIdxList{indexOfMax} ) = 0;
%  largeConnectedComponent=image;
%  smallerConnectedComponent=ORiginalImage-largeConnectedComponent;

end

