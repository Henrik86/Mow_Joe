function [ skel ] = skelDetect( image )
%UNTITLED6 skel = S1
%   Detailed explanation goes here
S1= bwmorph(image,'skel',inf);
skel=bwmorph(S1,'bridge',inf);
%OriginalS1=skel;


end

