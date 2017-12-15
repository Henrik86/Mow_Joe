function [ px,py,node ] = cuttingPointFinder( clusterImage,node,path,rachis,leaf )
%cuttingPointFinder finds the cutting points.
%   Detailed explanation goes here
node(path(1)).misRachis=0;
node(path(length(path))).misLeaf=0;
leafCount=0;
rachisCount=0;

for i=1:length(path)
    k=node(path(i)).coordinate(1);
    z=node(path(i)).coordinate(2);
%     node(path(i)).misLeaf=0;
%     node(path(i)).misRachis=0;
    node(path(i)).misLeaf=leafCount;
            if (clusterImage(k,z)==rachis)
                leafCount=leafCount+1;
            end
    
end

for i=length(path):-1:1
    k=node(path(i)).coordinate(1);
    z=node(path(i)).coordinate(2);
    node(path(i)).misRachis=rachisCount;
            if (clusterImage(k,z)==leaf)
                rachisCount=rachisCount+1;
            end
    
end
n=length(path);
likeCutArr=zeros(1,n);

min=likeCutArr(1);
for i=1:length(path)
%     node(path(i)).likeCut=node(path(i)).misRachis+node(path(i)).misLeaf;
    likeCutArr(i)=node(path(i)).misRachis+node(path(i)).misLeaf;
    if(i==1)
        min=likeCutArr(1);
        index=path(i);
    else
        if likeCutArr(i)<min 
            min=likeCutArr(i);
            index=path(i);
        end
    end
end
 px=node(index).coordinate(1);
 py=node(index).coordinate(2);

%Visualization
%  figure
%  imshow(clusterImage)
%  hold on
%  plot(py,px,'o')
%  hold off

end
