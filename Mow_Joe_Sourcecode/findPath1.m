function [ path ] = findPath1( image,node,mappingImage,startLabel,endLabel)
%find the path from d to point p
%   Detailed explanation goes here]
% n=length(find(image==1));
% node(n+1);

% [row_bottom,col_bottom]=bottomPoint(image); % we path S1
% [row_high,col_high]=topPoint(imageCluster,cluster); %S2,rachis
% x=px-dx;
% y=py-dy;
% n=max(abs(x),abs(y));
% node=graph;
Sv=double(image);
Spath=double(image);
stack=CStack;
c=1;
path=[];

white = 0; 
grey = 1; 
black = 2;
green=-1;

node(1).explored=[];
node(startLabel).color=-1;
stack.push(node(startLabel));



while (~stack.isempty())

        top=stack.top();
        if top.label==endLabel
                while(~stack.isempty())
                    temptop=stack.top();
                    x=temptop.coordinate(1);
                    y=temptop.coordinate(2);
                    path(c)=temptop.label;
                    Spath(x,y)=0.5;
                    stack.pop();
                    c=c+1;
                end
        else
                i=top.coordinate(1);
                j=top.coordinate(2);
                lab=mappingImage(i,j);
                neighbors=node(lab).neighbour;
                %node(lab).color=green;
                vertexFound=0;
                if numel(neighbors)==1
                
                end
                for neighb=neighbors
                    labelNeighbor=mappingImage(neighb);
                    coordinateNeighbor=node(labelNeighbor).coordinate;

                    if node(labelNeighbor).color ~= green
                            Sv(coordinateNeighbor(1),coordinateNeighbor(2))=0.5;
                            node(labelNeighbor).color=green;
                            stack.push(node(labelNeighbor));
                            vertexFound=1;
                            break;
                    end
                end
                if(vertexFound==0)
                 node(lab).explored=1;
                 stack.pop();
                end 
        end
end
     
    

     %while
% figure,imshow(Sv);
%  figure,imshow(Spath);
end %function

