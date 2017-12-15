function [I,imageResize,binaryImage,skel,boundryImage,rgbImage,BW,imageScale,IComponent,binaryImageFigure ] = binarization4( imageStringName )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
originalI = imread(imageStringName);
if(numel(size(originalI))>=3)
    if(size(originalI,3)==4)
        originalI=originalI(:,:,1:3);
    end
end
if(numel(unique(originalI))>2)
    
    if(size(originalI,2)>size(originalI,1)) %% rotate images
        originalI=imrotate(originalI,-90);
    end
    if(size(originalI,2)>4000 || size(originalI,1)>4000)
        imageScale=0.25;
    elseif(size(originalI,2)>2000 || size(originalI,1)>2000)
        imageScale=0.5;
    else
        imageScale=1;
    end
    I= imresize(originalI,imageScale);
    rgbImage=I;

    hsvImage=rgb2hsv(I);
    saturationImage=hsvImage(:,:,2);
    valueImage=hsvImage(:,:,3);
    X=[saturationImage(:),valueImage(:)];

    rgbImage=I;
    numClusters=2;
    [ ~,cluster1,cluster2,cluster3 ] = kmeanCluster(X,numClusters);
    % [idx,cluster1,cluster2]=HSVCluster(X);

    %%%%%
    % kmeansCluster=kmeans(X,3);
    % mean1=mean(X(kmeansCluster==1,:));
    % mean2=mean(X(kmeansCluster==2,:));
    % mean3=mean(X(kmeansCluster==3,:));
    % 
    % SIGMA=eye(2,2);
    % meanS=[mean1;mean2;mean3];
    % S = struct('mu',meanS,'Sigma',SIGMA);
    % 
    % obj = gmdistribution.fit(X,3,'Start',S,'SharedCov',true,'CovType','full','Regularize',0) ; 
    % idx = cluster(obj,X);
    % [ BW ] = binaryFromCluster( idx,rgbImage,cluster1,cluster2 );

    %%%%
    if mean(cluster1)>mean(cluster2)
        MU=[mean(cluster1);mean(cluster2)];
    else
        MU=[mean(cluster2);mean(cluster1)];
    end
    [newidx,cluster1,cluster2 ] = hsvClusterWithStart( X,MU );
    [ BW ] = binaryFromCluster( newidx,rgbImage,cluster1,cluster2 );


    BW= imfill(BW,'holes'); % filling the holes 
    binaryImage=BW;
    imageResize=size(BW);

    [ binaryImage ] = largestComponent( binaryImage );
    [ skel ] = skelDetect( binaryImage );
    boundryImage=bwperim(binaryImage,8);

    %%%
    IComponent=I;
    IComponentR=I(:,:,1);
    IComponentR(~binaryImage)=255;
    IComponentG=I(:,:,2);
    IComponentG(~binaryImage)=255;
    IComponentB=I(:,:,3);
    IComponentB(~binaryImage)=255;
    IComponent=cat(3,IComponentR,IComponentG,IComponentB);
    %
    binaryImageFigure=~binaryImage;

    %%%


    % h=figure, 
    % %set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
    % 
    % subplot(1,6,1) 
    % imshow(BW); 
    % title(' hsv binary');
    % 
    % subplot(1,6,2); 
    % imshow(binaryImage); 
    % title('filled hsv binary');
    % 
    % 
    % subplot(1,6,3); 
    % imshow(binaryImage); 
    % title('largeComp hsv binary');
    % 
    % 
    % subplot(1,6,4); 
    % imshow(skel); 
    % title(' hsv skel binary');
    % 
    % subplot(1,6,5); 
    % imshow(boundryImage); 
    % title(' hsv boundry');
    % 
    % thickendboundry=bwmorph(boundryImage,'thicken',4); 
    % subplot(1,6,6);
    % imshow(imoverlay(rgbImage,thickendboundry,[1,0,1])); 
    % title(' hsv boundry overlay');


    %saveas(h,strcat(imageStringName,'1'),'tif');
else
    I = imread(imageStringName); % open the image
    originalI=I;
    if(size(originalI,2)>size(originalI,1)) %% rotate images
        originalI=imrotate(originalI,-90);
    end
    if(size(originalI,2)>4000 || size(originalI,1)>4000)
        imageScale=0.25;
    elseif(size(originalI,2)>2000 || size(originalI,1)>2000)
        imageScale=0.5;
    else
        imageScale=1;
    end
    %%%%%%%%
    I= imresize(originalI,imageScale);
    rgbImage= I;

    level = graythresh(rgbImage);  % find the threshhold 
    BW = im2bw(rgbImage,level); % use the threshhold to make in into binary image
    BW=~BW;
    BW = imfill(BW,'holes');
    binaryImage = bwlabel(BW,8);  % largest connected component 
    % figure,imshow(binaryImage);

    rp = regionprops(binaryImage,'Area','PixelIdxList');

    areas = [rp.Area];
    [svals,idx] = sort(areas,'descend'); 
    %figure,imagesc(binaryImage);

    binaryImage(binaryImage~=idx(1))=0;

    %figure,imshow(binaryImage);
    % figure,imshow(BW2);
    % BW1 = imfill(~BW2,'holes'); % filling the holes 



    % S1= bwmorph(binaryImage,'skel',inf);
    % OriginalS1=S1;
    % boundryImage=bwperim(binaryImage,8);

    BW1=binaryImage;
    imageResize=size(BW1);
    binaryImage = bwlabel(BW1,8);     % largest connected component 
    rp = regionprops(BW1,'Area','PixelIdxList');
    areas = [rp.Area];
    [~,indexOfMax] = max(areas);
    IComponent=I;
    if length(indexOfMax) > 0
        binaryImage(binaryImage~=indexOfMax)=0;

    else 
        BW=~BW;
        binaryImage = bwlabel(BW,8);  % largest connected component 
        % figure,imshow(binaryImage);
        rp = regionprops(binaryImage,'Area','PixelIdxList');
        areas = [rp.Area];
        [svals,idx] = sort(areas,'descend'); 
        % figure,imagesc(binaryImage);
        binaryImage(binaryImage~=idx(1))=0;
        % figure,imshow(binaryImage);
        BW2 = imclearborder(binaryImage);
        BW1 = imfill(BW2,'holes'); % filling the holes     

    end
    boundryImage=bwperim(binaryImage,8);
    [ skel ] = skelDetect( binaryImage );
    binaryImageFigure=~binaryImage;
    end
end

