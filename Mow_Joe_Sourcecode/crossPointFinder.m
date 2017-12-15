function [ crossingPoint ] = crossPointFinder( longestPath,nPoints )
%This function will find the crossing points with the help of the
%longestpathes with cutpoints that has been saved.
% note that : nPoints are the points that are on the stem and have more than 3
% neighbours(neighbourPoints)
crossingPoint=[];
if(numel(longestPath)==0)
    crossingPoint=[];
else
%crossingPoint=zeros(numel(longestPath)-1);
for i=1:numel(longestPath) %%% why does it start with 2???
    if(i==1)%%%%Terminal cutting point does not have any crossing point
        crossingPoint(i)=0;
    else
        [~,loc]=ismember(nPoints,longestPath{i});
        ind = find(loc, 1, 'first');
        crossingPoint(i)=longestPath{i}(loc(ind));
    end

end
end
end
