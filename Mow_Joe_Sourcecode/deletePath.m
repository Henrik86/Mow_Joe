function [ image ] = deletePath( image,graph,path )
%deletePath :deltes the given path from the graph
%   (image,graph,path)
cords=cell2mat({graph(path).coordinate}');
cordsI=sub2ind(size(image),cords(:,1),cords(:,2));
image(cordsI)=0;
%figure,imshow(image);

end

