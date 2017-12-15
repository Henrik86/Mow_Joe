function [r,c] = findLeafTopPoint( bottomPointP,terminalPointP,boundaryImage)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    %bottomPointP=graph(1).coordinate;
    %terminalPointP=leafletStruct(1).centers;
    
    steigung= (bottomPointP(1)-terminalPointP(1))/(bottomPointP(2)-terminalPointP(2));
    achsenabschnitt=terminalPointP(1)-steigung*terminalPointP(2);
    %schnittpunkt mit bildrand
    %y=mx+c
    %0=steigung*x+achsenabschnitt;
    x=[]
    if(~isinf(steigung))
        x=(0-achsenabschnitt)/steigung;
    elseif(bottomPointP(2)==terminalPointP(2)) %same x value
        x=bottomPointP(2);
    end
    %
    lineImage=zeros(size(boundaryImage));
    lineImage=drawLine(lineImage,floor(terminalPointP(1)),floor(terminalPointP(2)),1,floor(x));
    %
    [r,c]=find(boundaryImage & lineImage);
    
end

