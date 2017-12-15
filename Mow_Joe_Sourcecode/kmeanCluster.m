function [ idx,cluster1,cluster2,cluster3 ] = kmeanCluster( X,numClusters )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    idx = kmeans(X,numClusters,'emptyaction','singleton');
    cluster1 = X(idx == 1,:);
    cluster2 = X(idx == 2,:);
    if(numClusters==3)
        cluster3 = X(idx == 3,:);
    else
        cluster3=[]
    end

%       HSV cluster code
%      options = statset('Display','final');
%     obj = gmdistribution.fit(X,2,'Options',options);
%     idx = cluster(obj,X);
%     cluster1 = X(idx == 1,:);
%     cluster2 = X(idx == 2,:);
end

