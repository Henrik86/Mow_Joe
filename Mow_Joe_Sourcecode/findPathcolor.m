function [ path,Spath ] = findPathcolor( image,node,mappingImage,startLabel,endLabel)

% finds and then colors the path between a startlabel and an endlabel;

Sv=double(image);
Spath=double(image);
stack=CStack;
c=1;
path=[];
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
 % figure,imshow(Spath);
end %function

