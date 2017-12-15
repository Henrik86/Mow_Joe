function [ binaryImage ] = largestComponent( image )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

binaryImage = bwlabel(image);     % largest connected component 
rp = regionprops(logical(binaryImage),'Area','PixelIdxList');
areas = [rp.Area];
[~,idx] = sort(areas,'descend'); 
binaryImage(binaryImage~=idx(1))=0;
end

