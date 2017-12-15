function [ row_last,col_last ] = bottomPoint( image )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
[row,col]= find(image==1);
[~,v]=max(row);
entries=[row,col];
row_last=entries(v,1);
col_last=entries(v,2);

end

