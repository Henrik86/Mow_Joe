function [ euclideanDistance ] = branchLenSplines( coordinatesPath )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    [C,IA,IC] = unique(coordinatesPath(:,1),'rows');
    coordinatesUnique=coordinatesPath(IA,:);
    
    
    steps=(max(coordinatesUnique(:,1))-min(coordinatesUnique(:,1)))/1000
    xx = min(coordinatesUnique(:,1)):steps:max(coordinatesUnique(:,1))
    yy = spline(coordinatesUnique(:,1),coordinatesUnique(:,2),xx);
    plot(coordinatesPath(:,1),coordinatesPath(:,2),'o');
    plot(coordinatesUnique(:,1),coordinatesUnique(:,2),'o',xx,yy)
    interpolatedCords=[xx',yy'];
    euclideanDistance=0
    coord1=interpolatedCords(1,:)
    for i=2:numel(xx)
        coordN=interpolatedCords(i,:)'
        euclidDistN=sqrt((coord1(1)-coordN(1))^2+(coord1(2)-coordN(2))^2)
        euclideanDistance=euclideanDistance+euclidDistN
        coord1=coordN;
    end

end

