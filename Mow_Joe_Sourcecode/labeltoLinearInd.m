function [ linearInd ] = labeltoLinearInd( label,graph,imageResize )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
x=graph(label).coordinate(1);
y=graph(label).coordinate(2);
linearInd = sub2ind([imageResize(1),imageResize(2)], x, y);

end

