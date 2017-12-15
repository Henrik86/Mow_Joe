function [ X,I,imageScale ] = rgbToHSV( imageStringName,imageScale )
%UNTITLED3 Summary of this function goes here
%   REading the image and making it into HSV colorSPACE
originalI = imread(imageStringName); % open the image

I= imresize(originalI,imageScale);
hsv = rgb2hsv(I);
saturationImage = hsv(:, :, 2);
valueImage = hsv(:, :, 3);

reshapeSat=reshape(saturationImage,numel(saturationImage),1);
reshapeVal=reshape(valueImage,numel(valueImage),1);

X=[reshapeSat,reshapeVal];
end

