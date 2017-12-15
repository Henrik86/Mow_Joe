function [ image ] = colorThePath( image,graph,Path )
%colors the given path for visulisation purposes.

for path=Path
    x=graph(path).coordinate(1);
    y=graph(path).coordinate(2);
    image(x,y)=0.5;
end
figure,
imshow(image);

end

