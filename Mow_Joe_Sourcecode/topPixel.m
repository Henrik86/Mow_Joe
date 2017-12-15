function [ row_high,col_high ] = topPixel( image )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
[row,col]= find(image);

[~,minV]=min(row);
entries1=[row,col];
row_high=entries1(minV,1);
col_high=entries1(minV,2);

end

