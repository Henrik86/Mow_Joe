function [ node,mappingImage ] = traverseDfs0( image,px,py )
%Traverse the graph in a DFS manner from the point given
% till all the tree is traversed.

%[row_last,col_last]=bottomPoint(image); % we pass S1

Sv=double(image);
mappingImage=zeros(size(image));
stack=CStack;
k=1;
label=1;
white = 0; grey = 1; black = 2;
node(length(find(image==1))).label=0; % preallocating 
node(1).color=white;
node(1).label=label;
node(1).coordinate=[px,py];
mappingImage(px,py)=k;
stack.push(node(1));
    while (~stack.isempty())
        top=stack.top();
%         node(k).color=white;
        if top.color==white
            i=top.coordinate(1);
            j=top.coordinate(2);

            [neighcount,neighb]=numberOfNeighbour(i,j,image);
            node(top.label).neighbour=neighb;
            node(top.label).neighbourCount=neighcount;
            top.color=grey;
              if image(i,j+1)==1 && Sv(i,j+1)==1 
                    if node(k).color==white
                        node(k).color=grey;
                        Sv(i,j+1)=0.5;
                        k=k+1;
                        node(k).color=white;
                        node(k).label=k;
                        node(k).coordinate=[i,j+1];
                        mappingImage(i,j+1)=k;
                        stack.push(node(k));
                    end
                elseif image(i-1,j+1)==1 && Sv(i-1,j+1)==1 
                    if node(k).color==white
                        node(k).color=grey;
                        Sv(i-1,j+1)=0.5;
                        k=k+1;
                        node(k).color=white;
                        node(k).label=k;
                        node(k).coordinate=[i-1,j+1];
                        mappingImage(i-1,j+1)=k;
                        stack.push(node(k));
                    end
                elseif image(i,j-1)==1 && Sv(i,j-1)==1 
                    if node(k).color==white
                        node(k).color=grey;
                        Sv(i,j-1)=0.5;
                        k=k+1;
                        node(k).color=white;
                        node(k).label=k;
                        node(k).coordinate=[i,j-1];
                        mappingImage(i,j-1)=k;
                        stack.push(node(k));
                    end
                elseif image(i-1,j-1)==1 && Sv(i-1,j-1)==1 
                    if node(k).color==white
                        node(k).color=grey;
                        Sv(i-1,j-1)=0.5;
                        k=k+1;
                        node(k).color=white;
                        node(k).label=k;
                        node(k).coordinate=[i-1,j-1];
                        mappingImage(i-1,j-1)=k;
                        stack.push(node(k))
                    end
                elseif image(i-1,j)==1  && Sv(i-1,j)==1 
                    if node(k).color==white
                        node(k).color=grey;
                        Sv(i-1,j)=0.5;
                        k=k+1;
                        node(k).color=white;
                        node(k).label=k;
                        node(k).coordinate=[i-1,j];
                        mappingImage(i-1,j)=k;
                        stack.push(node(k));
                    end
                elseif image(i+1,j+1)==1  && Sv(i+1,j+1)==1 
                    if node(k).color==white
                        node(k).color=grey;
                        Sv(i+1,j+1)=0.5;
                        k=k+1;
                        node(k).color=white;
                        node(k).label=k;
                        node(k).coordinate=[i+1,j+1];
                        mappingImage(i+1,j+1)=k;
                        stack.push(node(k));
                    end
                elseif image(i+1,j-1)==1 && Sv(i+1,j-1)==1 
                    if node(k).color==white
                        node(k).color=grey;
                        Sv(i+1,j-1)=0.5;
                        k=k+1;
                        node(k).color=white;
                        node(k).label=k;
                        node(k).coordinate=[i+1,j-1];
                        mappingImage(i+1,j-1)=k;
                        stack.push(node(k));
                    end
                    
                elseif image(i+1,j)==1  && Sv(i+1,j)==1 
                    if node(k).color==white
                        node(k).color=grey;
                        Sv(i+1,j)=0.5;
                        k=k+1;
                        node(k).color=white;
                        node(k).label=k;
                        node(k).coordinate=[i+1,j];
                        mappingImage(i+1,j)=k;
                        stack.push(node(k));
                    end
              else
                   % node(top.label).color=black;
                    top.color=black;
                    stack.pop();
              end
    
        end

    end
    
% node(length(find(image==1)))=[];
mappingImage(px,py)=label;
%  figure,imshow(mappingImage);
%  figure,imshow(Sv);
end %function

