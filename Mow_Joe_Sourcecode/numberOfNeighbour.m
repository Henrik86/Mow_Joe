function [ neighbourCount,neighbour ] = numberOfNeighbour(i,j,image)
%         [i,j]=Pixel
        
        neighbourCount=0;
%         east=[i,j+1];
%         northeast=[i-1,j+1];
%         north=[i-1,j];
%         northwest=[i-1,j];
%         west=[i,j-1];
%         southwest=[i+1,j-1];
%         south=[i+1,j];
%         southeast=[i+1,j];

        neighbour=[];
        k=1;
            %east
            if image(i,j+1)==1 
                neighbourCount=neighbourCount+1;
                neighbour(k)=sub2ind(size(image), i, j+1);
                k=k+1;

            end
            %northeast
            if image(i-1,j+1)==1 
                    neighbourCount=neighbourCount+1;
                    neighbour(k)=sub2ind(size(image), i-1, j+1);
                    k=k+1;
            end
           %north
           if image(i-1,j)==1 
                    neighbourCount=neighbourCount+1;
                    neighbour(k)=sub2ind(size(image), i-1,j);
                    k=k+1;
           end
           %northwest
           if image(i-1,j-1)==1
                    neighbourCount=neighbourCount+1;
                    idx=sub2ind(size(image), i-1,j-1);
                    neighbour(k)=idx;
                    k=k+1;
           end
                 
           %west
           if image(i,j-1)==1 
                    neighbourCount=neighbourCount+1;
                    neighbour(k)=sub2ind(size(image), i,j-1);
                    k=k+1;
           end
           %south west
           if image(i+1,j-1)==1 
                    neighbourCount=neighbourCount+1;
                    neighbour(k)=sub2ind(size(image), i+1,j-1);
                    k=k+1;
           end
           % south
            if image(i+1,j)==1
                    neighbourCount=neighbourCount+1;
                    neighbour(k)=sub2ind(size(image), i+1,j);
                    k=k+1;
            end
                %southeast
            if image(i+1,j+1)==1 
                    neighbourCount=neighbourCount+1;
                    neighbour(k)=sub2ind(size(image),i+1,j+1);
                    k=k+1;
            end
           
end

