function [ graph ] = classifierBranch( SNOriginal,graph,map,leafletStruct )
%classification of diffrent parts of graph (branch,petiole,iterrachis)
%   Detailed explanation goes here
odd=3;
even=2;
for i=1: numel(leafletStruct)
    if(leafletStruct(i).crossingPoint ~= 0)
        branch=findPath1(SNOriginal,graph,map,leafletStruct(i).crossingPoint,leafletStruct(i).cutPoint);
        graph(leafletStruct(i).cutPoint).numb=1;
        if graph(leafletStruct(i).cutPoint).coordinate(2)>graph(leafletStruct(i).crossingPoint).coordinate(2)
            graph(leafletStruct(i).cutPoint).numb=odd;
            odd=odd+2;
            for j=1:length(branch)
                if(strcmp(leafletStruct(i).class,'leaflet'))
                    graph(branch(j)).classify='branch';
                    graph(branch(j)).subclassify=strcat('branch', num2str(i));
                    graph(branch(j)).orientation=strcat('rightBranch');
                else%%Small leaf
                    graph(branch(j)).classify='branch';
                    graph(branch(j)).subclassify=strcat('branch', num2str(i));
                    graph(branch(j)).orientation=strcat('rightBranch');
                end
            end
        else
            graph(leafletStruct(i).cutPoint).numb=even;
            even=even+2;
            for j=1:length(branch)
                if(strcmp(leafletStruct(i).class,'leaflet'))
                    graph(branch(j)).classify='branch';
                    graph(branch(j)).subclassify=strcat('branch', num2str(i));
                    graph(branch(j)).orientation=strcat('leftBranch');
                else%%Small leaf
                    graph(branch(j)).classify='branch';
                    graph(branch(j)).subclassify=strcat('branch', num2str(i));
                    graph(branch(j)).orientation=strcat('leftBranch');
                end

            end
        end
    end
end

crossingPoint=[leafletStruct.crossingPoint];
cutArray=[leafletStruct.cutPoint];
if(~isempty(find(crossingPoint)))
         petiole=findPath1(SNOriginal,graph,map,1,crossingPoint(end));
        for j=1:length(petiole)
            graph(petiole(j)).subclassify='petiole';
        end
        terminalRachis=findPath1(SNOriginal,graph,map,crossingPoint(2),cutArray(1));
        for j=1:length(terminalRachis)
            graph(terminalRachis(j)).subclassify='terminalRachis';
        end

        for i=2:numel(crossingPoint)-1
            interRachis{i}=findPath1(SNOriginal,graph,map,crossingPoint(i),crossingPoint(i+1));
            for j=1:length(interRachis{i})
                graph(interRachis{i}(j)).subclassify=strcat('interRachis_', num2str(i));
            end
        end
end

end

