function [ euclideanDistance ] = calculateBranchLenSplines( coordinatesPath,i)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    [xc,yc] = consolidator(coordinatesPath(:,1),coordinatesPath(:,2),'mean'); 
    
    [C,IA,IC] = unique(coordinatesPath(:,1),'rows');
    coordinatesUnique=coordinatesPath(IA,:);
    coordinatesUnique=[xc,yc];

    
    steps=(max(coordinatesPath(:,1))-min(coordinatesPath(:,1)))/1000;
    xx = min(coordinatesUnique(:,1)):steps:max(coordinatesUnique(:,1));
    pp1=splinefit(coordinatesPath(:,1),coordinatesPath(:,2),10,'r',0.5);
    %%%
    y1 = ppval(pp1,xx);
%     figure
%     hold on
%     plot(coordinatesPath(:,1),coordinatesPath(:,2),'.')
%     plot(xx,y1)
%     saveas(gcf,strcat('/Users/henrikfailmezger/Documents/PHD/SideProjects/Jigsaw_Paper/MowJoe/PlantMethodsRevision/Figures/SplinesBranches/Spline_',num2str(i),'.png'), 'png')
%     close;
 
    
    %dlmwrite(strcat('/Users/henrikfailmezger/Documents/PHD/SideProjects/Jigsaw_Paper/MowJoe/PlantMethodsRevision/Figures/SplinesBranches/Spline_',num2str(i),'.txt'),coordinatesPath,'\t');
    %%%
    yySpline = spline(coordinatesUnique(:,1),coordinatesUnique(:,2),xx);
    %plot(coordinatesPath(:,1),coordinatesPath(:,2),'o');
    %plot(coordinatesUnique(:,1),coordinatesUnique(:,2),'o',xx,yySpline)
    %interpolatedCords=[xx',yy'];
    interpolatedCords=[xx',y1'];
    euclideanDistance=0
    coord1=interpolatedCords(1,:)
    for i=2:numel(xx)
        coordN=interpolatedCords(i,:)'
        euclidDistN=sqrt((coord1(1)-coordN(1))^2+(coord1(2)-coordN(2))^2)
        euclideanDistance=euclideanDistance+euclidDistN
        coord1=coordN;
    end

end

