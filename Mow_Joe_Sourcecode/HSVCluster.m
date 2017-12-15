function [ idx,cluster1,cluster2 ] = HSVCluster( X )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
    
    options = statset('Display','final');
    obj = gmdistribution.fit(X,2,'Options',options);
    idx = cluster(obj,X);
    cluster1 = X(idx == 1,:);
    cluster2 = X(idx == 2,:);
%     if  mean((cluster1(:,2)))> mean((cluster2(:,2)))
%         cluster1=background
    
end

