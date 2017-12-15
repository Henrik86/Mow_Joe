function [ SN] = ImageFromGraphClassification( graph, sizeImg,classification )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    graph(~strcmp({graph.classify},classification))=[];
    SN=zeros(sizeImg);
    cords=cell2mat({graph.coordinate}');
    if(isempty(cords)) %%% No branches
        SN=SN;
    else
        cordsI=sub2ind(sizeImg,cords(:,1),cords(:,2));
        SN(cordsI)=1;
    end
end

