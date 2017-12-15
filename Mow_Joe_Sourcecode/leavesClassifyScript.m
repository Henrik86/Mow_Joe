% classification of the leafs 
% made into two functions classifierLeaf and ClassiferBranch
[graph]=leafClassifier(allLeafs{1},graph,map,'terminalLeaf');
for i = 2:numel(allLeafs);  
    clas = strcat('leaf', num2str(i));
    [graph]=leafClassifier(allLeafs{i},graph,map,clas);
    
end

for i=1: numel(crossingPoint)
    branch=findPath1(SNOriginal,graph,map,crossingPoint(i),cutArray(i+1));
    if graph(cutArray(i+1)).coordinate(2)>graph(crossingPoint(i)).coordinate(2)
        for j=1:length(branch)
            graph(branch(j)).classify='branch';
            graph(branch(j)).subclassify=strcat('branch', num2str(i));
            graph(branch(j)).orientation=strcat('rightBranch', num2str(i));
        end
    else
        for j=1:length(branch)
            graph(branch(j)).classify='branch';
            graph(branch(j)).subclassify=strcat('branch', num2str(i));
            graph(branch(j)).orientation=strcat('leftBranch', num2str(i));
        end
    end  
end

%#########################################################################
%sub clasiifing of everything 
 petiole=findPath1(SNOriginal,graph,map,1,crossingPoint(end));
for j=1:length(petiole)
    graph(petiole(j)).subclassify='petiole';
end
terminalRachis=findPath1(SNOriginal,graph,map,crossingPoint(1),cutArray(1));
for j=1:length(terminalRachis)
    graph(terminalRachis(j)).subclassify='terminalRachis';
end

for i=1:numel(crossingPoint)-1
    interRachis{i}=findPath1(SNOriginal,graph,map,crossingPoint(i),crossingPoint(i+1));
    for j=1:length(interRachis{i})
        graph(interRachis{i}(j)).subclassify=strcat('interRachis_', num2str(i));
    end
end