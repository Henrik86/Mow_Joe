function [leafletStruct] = leafletIding(graph,leafletStruct)
odd=3;
even=2;
for i=1:numel(leafletStruct);
    if strcmp(graph(leafletStruct(i).cutPoint).classify,'TerminalLeaf') 
        leafletStruct(i).leafletID=1;
    elseif  strcmp(graph(leafletStruct(i).cutPoint).orientation,strcat('rightBranch'))
        leafletStruct(i).leafletID=odd;
        odd=odd+2;
    elseif strcmp(graph(leafletStruct(i).cutPoint).orientation,strcat('leftBranch'))
       leafletStruct(i).leafletID=even;
       even=even+2;
    end
end

end