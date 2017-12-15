function [ image,smallConn ] = connectComp( image )
%trying to rewrite the largest connected component so it will find the
%largest and smaller component
%   Detailed explanation goes here
%************************
orginalImage=image;
CC = bwconncomp(image,8);
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);
image(CC.PixelIdxList{idx})=0 ;
smallConn=orginalImage-image;

end

