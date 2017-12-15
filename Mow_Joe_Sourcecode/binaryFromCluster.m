function [ binaryImage ] = binaryFromCluster( newidx,I,cluster1,cluster2 )
%UNTITLED2 Summary of this function goes here
%   creates the binary image from the cluster (IDX) which was obtained
%   using the sat, value and leafsnap paper!
%S4=zeros(numel(idx));
a=mean(cluster1(:,1));
b=mean(cluster1(:,2));
c=mean(cluster2(:,1));
d=mean(cluster2(:,2));
G=[a,b];
G1=[c,d];
G2=[0,1];
D = norm(G - G2);
D1=norm(G1 - G2);
if D>D1
    a=[1;0];
else
    a=[0;1];
end
S4=a(newidx);
% for i=1:numel(idx)
%     if idx(i)==background 
%         S4(i)=1;
%     else 
%         S4(i)=0;
%     end   
% end
[x,y,~]=size(I);
binaryImage=reshape(S4,x,y);

%figure,imshow(binaryImage);

end

