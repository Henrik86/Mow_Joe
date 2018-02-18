function [  ] = visulisePoint( image,px,py,color )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
 

% %figure
%  imshow(image)
 hold on
 plot(py,px,'o',...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor',color,...
                'MarkerSize',3);
 hold off
end

