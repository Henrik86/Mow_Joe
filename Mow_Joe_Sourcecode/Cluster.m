SN=SNOriginal;
SN=logical(SN);
D = bwdist(~binaryImage); % 
X=D(SN);

xImage=zeros(size(SN));
xImage=D(SN);
options = statset('Display','final');
obj = gmdistribution.fit(X,2,'Options',options);
idx = cluster(obj,X);
cluster1 = X(idx == 1,:);
cluster2 = X(idx == 2,:);
    if(mean(cluster1)<mean(cluster2))
        rachis=1;
        leaf=2;
    else
        rachis=2;
        leaf=1;
    end
    
pRachis=posterior(obj,rachis);
pLeaf=posterior(obj,leaf);
p=posterior(obj,X);
%     rachis=min(mean(cluster1),mean(cluster2));
%     leaf=max(mean(cluster1),mean(cluster2));
   S2=zeros(size(SN));
   S2(SN)=idx;   
    %figure,imagesc(S3);
    %calculating using the posterior prob , no better soultions though
%    S3=zeros(size(SN));
%    S3(SN==1)=p(:,rachis);
%    S5=zeros(size(SN));
%    S5(SN==1)=p(:,leaf);
%    S6=zeros(size(SN));
   
%    S2 = imdilate(S2,strel('disk',5));

   DR=D/max(D(:));
   DG=D/max(D(:));
   DB=D/max(D(:));
   
   DR(S2==rachis)=1;
   DG(S2==rachis)=0;
   DB(S2==rachis)=0;
   DRGB1=cat(3,DR,DG,DB);
   %figure,imshow(DRGB1);
%    h=figure;
%    imshow(DRGB1);
%    saveas(h,strcat(folderPath,'\','Cluster.png'),'png');

   DR(S2==leaf)=0;
   DG(S2==leaf)=1;
   DB(S2==leaf)=0;
   DRGB1=cat(3,DR,DG,DB);
   %figure,imshow(DRGB1);
   h=figure;
   imshow(DRGB1);
   saveas(h,strcat(folderPath,'\','Cluster.png'),'png');

%    DR=D/max(D(:));
%    DG=D/max(D(:));
%    DB=D/max(D(:));
%    
%    DR(find(S5)>0.5)=1;
%    DG(S5==0)=0;
%    DB(find(S5)<=0.5)=1;
%    DRGB1=cat(3,DR,DG,DB);
%    figure,imshow(DRGB1);
   
%    DR(S5==0)=0;
%    DB(S5==0)=0;
%    DRGB1=cat(3,DR,DG,DB);
%    figure,imshow(DRGB1);
    redChannel = rgbImage(:, :, 1);
    greenChannel = rgbImage(:, :, 2);
    blueChannel = rgbImage(:, :, 3);

   redChannel(S2==rachis)=255;
   greenChannel(S2==rachis)=0;
   blueChannel(S2==rachis)=0;
   DRGB=cat(3,redChannel,greenChannel,blueChannel);
   %figure,imshow(DRGB);
   
   redChannel(S2==leaf)=0;
   greenChannel(S2==leaf)=255;
   blueChannel(S2==leaf)=0;
   DRGB=cat(3,redChannel,greenChannel,blueChannel);
   h=figure;
   imshow(DRGB1);
   saveas(h,strcat(folderPath,'\','ClusterRGBimage.png'),'png');
% 