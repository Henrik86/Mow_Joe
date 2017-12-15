function [ leafletStruct ] = interRachisFeature( leafletStruct,SN,graph,map )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
leafletStruct(1).interRachis=0;
if numel([leafletStruct.crossingPoint])>2
    leafletStruct(2).interRachis=numel(findPath1(SN,graph,map,leafletStruct(2).crossingPoint,leafletStruct(1).cutPoint));
    leafletStruct(3).interRachis=numel(findPath1(SN,graph,map,leafletStruct(3).crossingPoint,leafletStruct(1).cutPoint));
    for ID=4: numel([leafletStruct.leafletID])
        leafletStruct(ID).interRachis=numel(findPath1(SN,graph,map,leafletStruct(ID).crossingPoint,leafletStruct(ID-2).crossingPoint));     
    end
end


end



