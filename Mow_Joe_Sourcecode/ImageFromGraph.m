function [ SN] = ImageFromGraph( graph, sizeImg )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    SN=zeros(sizeImg);
    cords=cell2mat({graph.coordinate}');
    cordsI=sub2ind(sizeImg,cords(:,1),cords(:,2));
    SN(cordsI)=1;
end

