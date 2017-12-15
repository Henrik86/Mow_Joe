function [ idx,cluster1,cluster2 ] = hsvClusterWithStart( X,MU )

%calculate the cluster with start point   
    SIGMA=eye(2,2);
    S = struct('mu',MU,'Sigma',SIGMA);
    obj = gmdistribution.fit(X,2,'Start',S,'SharedCov',true,'CovType','full','Regularize',0) ; 
    idx = cluster(obj,X);
    cluster1 = X(idx == 1,:);
    cluster2 = X(idx == 2,:);
    
end

