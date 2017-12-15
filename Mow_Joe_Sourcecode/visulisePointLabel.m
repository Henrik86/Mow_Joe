function [  ] = visulisePointLabel( image,graph,label)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
  
 %imshow(image)
% for label=labels
    px=graph(label).coordinate(1);
    py=graph(label).coordinate(2);
    
    
hold on
 plot(py,px,'--rs',...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','r',...
                'MarkerSize',3);

 hold off
 
 
end

