function  mainScript( imageStringName,output,lengthBranchToPrune)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    ticID1=tic

    [~,name,~] = fileparts(imageStringName);

    % mkdir('C:\Users\nasim\Documents\MATLAB\new\',name); %creates the folder
    % folderPath=strcat('C:\Users\nasim\Documents\MATLAB\new\',name,'\',name);
    % overlay=figure;
    % imshow(imoverlay(I,boundryImage,[1,0,1]));
    if (isnan(lengthBranchToPrune))
        lengthBranchToPrune=25;
    end
    mkdir(strcat(output,filesep,name)); %creates the folder
    imageFolder=strcat(output,filesep,name,filesep,'images');
    imageFolderName=strcat('images',filesep);
    mkdir(imageFolder); %creates the folder
    %
    %if(frameState==0)
%         [I,imageResize,binaryImage,S1,boundryImage,rgbImage,BW,BW1,imageScale,imgG ] = binarization1( imageStringName );
%         imwrite(I,strcat(output,filesep,name,filesep,name,'_ImageB1.png'));
%         imwrite(BW,strcat(output,filesep,name,filesep,name,'_BWB1.png'));
%         imwrite(BW,strcat(output,filesep,name,filesep,name,'_BoundaryB1.png'));
%         imwrite(imgG,strcat(output,filesep,name,filesep,name,'_Grey.png'));
%         imwrite(imoverlay(rgbImage,bwperim(~BW),[1 0 0]),strcat(output,filesep,name,filesep,name,'_OverlayGrey.png'));
%         %
%         [I,imageResize,binaryImage,S1,boundryImage,rgbImage,BW,imageScale,greenImage ] = binarization2( imageStringName );
%         imwrite(I,strcat(output,filesep,name,filesep,name,'_ImageB2.png'));
%         imwrite(BW,strcat(output,filesep,name,filesep,name,'_BWB2.png'));
%         imwrite(BW,strcat(output,filesep,name,filesep,name,'_BoundaryB2.png'));
%         imwrite(imgG,strcat(output,filesep,name,filesep,name,'_Green.png'));
%         imwrite(imoverlay(rgbImage,bwperim(BW),[1 0 0]),strcat(output,filesep,name,filesep,name,'_OverlayGreen.png'));

        %
        [I,imageResize,binaryImage,S1,boundryImage,rgbImage,BW,imageScale,IComponent,binaryImageFigure ] = binarization4( imageStringName );
        imwrite(I,strcat(output,filesep,name,filesep,imageFolderName,filesep,name,'_Image.png'));
        imwrite(IComponent,strcat(output,filesep,name,filesep,imageFolderName,name,'_Image.png'));
        imwrite(BW,strcat(output,filesep,name,filesep,imageFolderName,name,'_BW.png'));
        imwrite(binaryImageFigure,strcat(output,filesep,name,filesep,imageFolderName,filesep,name,'_BWFigure.png'));
        imwrite(IComponent,strcat(output,filesep,name,filesep,imageFolderName,filesep,name,'_ImageComponent.png'));
        imwrite(BW,strcat(output,filesep,name,filesep,imageFolderName,filesep,name,'_Boundary.png'));%else
    %    [ I,imageResize,binaryImage,S1,boundryImage,rgbImage,BW,BW1,imageScale ] = binarization2( imageStringName );
    %end
    ticSegmentation=tic
    se = strel('disk',1);
    binaryImage = imclose(binaryImage,se);
    OriginalS1=S1;
    [bottomPointCol,bottomPointRow]=bottomPoint(S1);
    [graph,map]=traverseDfs0(S1,bottomPointCol,bottomPointRow);
    %
    graphP=deleteBranches(graph,S1,map,lengthBranchToPrune,bottomPointCol,bottomPointRow);
    %
    SNp = ImageFromGraph( graphP, size(S1));
    SN=bwmorph(SNp,'clean');
    [ SN ] = bridgePixel( SN) ;
    [bottomPointCol,bottomPointRow]=bottomPoint(SN);
    bottomPointLabel=1;
    [graph,map]=traverseDfs0(SN,bottomPointCol,bottomPointRow);
    [topPointRow,topPointCol]=topPixel(SN);
    topLabel=map(topPointRow,topPointCol);
    SNOriginal=SN;
    path=findPath1(SN,graph,map,1,topLabel);
    liklihood=1;
    [rachis,leaf,S2,skelCluster,imgCluster,distanceImage ] = clusterFinder( SN,binaryImage,IComponent);

    
    stemLength=median(distanceImage(S2==rachis))*2;
    
    imwrite(skelCluster,strcat(output,filesep,name,filesep,name,'_skelCluster.png'));
 
    tocSegmentation=toc(ticSegmentation)
    ticLeafFinding=tic
    newPathArray=endPointPathFinder1(SNOriginal,SN,graph,map);
    %stemLength=numel(path);
    [ cutArray ,longestPath] =leaveFinder2( newPathArray,S2,graph,rachis,leaf,map,numel(path) );
    yCord=zeros(numel(cutArray));
    for i=1:numel(cutArray)
        yCord(i)=graph(cutArray(i)).coordinate(1);
    end
    [~,ind]=min(yCord);
    terminalLabel=cutArray(ind);
    %
    pathT=findPath1(SN,graph,map,1,cutArray(1));
    %%%%
    
%  figure;
%  imshow(SN);
%  hold on
%  for ij=2:n
%  cuttingPoint=cutArray(ij);
%  %plot(graph(crossingPoint(ij)).coordinate(2),graph(crossingPoint(ij)).coordinate(1),'ro')
%  plot(graph(cuttingPoint).coordinate(2),graph(cuttingPoint).coordinate(1),'bo')
%  end
 %%%%
bottomPointP=graph(1).coordinate;
    %%%%
    [graph]=Classify(SN,graph,longestPath{1},'rachisClassify','TerminalLeaf',cutArray(1));
    nPoints=pathT([graph(pathT).neighbourCount]>=3 & strcmp({graph(pathT).classify},'rachisClassify'));
    [ crossingPoint ] = crossPointFinder( longestPath,nPoints );
    tocLeafFinding=toc(ticLeafFinding);
    ticFeatureCalculation=tic;
    [leafletStruct] = cutCrossRemove(cutArray,graph,crossingPoint,SN,map,longestPath,stemLength); % removes the redundant crossing points!
    [ graph ] = classifierBranch(SNOriginal,graph,map,leafletStruct);
    [ imgBwLabeled,leafletStruct  ] = colorTheLeaf(graph,binaryImage>0,boundryImage,SNOriginal,map,stemLength,leafletStruct,strcat(output,filesep,name),bottomPointP);%
    [leafletStruct,imageLeaflets,imageRachis,imageBranches ] = areaMeasure(graph,imgBwLabeled,map,imageResize,SN,leafletStruct);
    %%%%%%%%%%%%%%
    
%     figure;
%     imshow(binaryImage)
%     hold on
%     plot(bottomPointP(2),bottomPointP(1),'o')
%     
     terminalPointP=leafletStruct(1).cutpointCoord;
    terminalPointP=floor(terminalPointP);
    terminalPointP(terminalPointP<1)=1;
    %
    [rP,cP] = findLeafTopPoint( bottomPointP,terminalPointP,boundryImage );
    if(nrows(terminalPointP)>0)
        [v,index]=sort(rP);
        topPointCoordinates=[rP(index(1)),cP(index(1))];
    else
        topPointCoordinates=[NaN NaN];
    end
    %%%%%
    leafletOutlines=bwperim(imageLeaflets);
     leafletOutlines=imdilate(leafletOutlines,strel('disk',2));
    imgZ=zeros(size(imageLeaflets));
     outlineNumber=imgZ(:);
     outlineNumberO=leafletOutlines(:);
     imageTerminal=imageLeaflets;
     imageTerminal(imageTerminal~=leafletStruct(1).leafletIdentifier)=0;
     imageTerminal=bwperim(imageTerminal);
     [ midPoint,dlP,drP ] = searchPointsBorder( bwperim(imageTerminal), topPointCoordinates,leafletStruct(1).splitPoint1,leafletStruct(1).splitPoint2, leafletStruct(1).cutpointCoord,strcat(output,filesep,name),rgbImage);
    %%%%%%%%%%%%%%
    shapePoints=[ midPoint;dlP;drP ];

    [ imgBwLabeled,folderPath,leafletStruct,bottomPointCoordinates,topPointCoordinates ] = writeIDtoImage(boundryImage,imgBwLabeled,I,output,name,graph,rgbImage,bottomPointLabel,leafletStruct,shapePoints,terminalPointP,topPointCoordinates);
     
    [ leafletStruct ] = interRachisFeature(leafletStruct,SN,graph,map );
    
     
     %%%%%%%%%%%%%%
     leafArea=numel(find(binaryImage));
     %scale Area
     leafArea=leafArea;
     %
     leafPerimeter=numel(find(bwperim(binaryImage)));
     %scale perimeter
     leafPerimeter=leafPerimeter;
     %
     %%add bottom point
    maxLeaf=numel(leafletStruct);
    leafletStruct(maxLeaf+1).crossingPoint=NaN;
    leafletStruct(maxLeaf+1).cutPoint=NaN;
    leafletStruct(maxLeaf+1).class='bottomPoint';
    leafletStruct(maxLeaf+1).pathBaseEndpoint=NaN;
    leafletStruct(maxLeaf+1).cutpointCoord=[NaN,NaN];    
    leafletStruct(maxLeaf+1).splitPoint1=[NaN,NaN];
    leafletStruct(maxLeaf+1).splitPoint2=[NaN,NaN];
    leafletStruct(maxLeaf+1).leafletIdentifier=NaN;
    leafletStruct(maxLeaf+1).distToTerminal=numel(pathT);
    maxID=max([leafletStruct.leafletID]);
    leafletStruct(maxLeaf+1).centers=bottomPointCoordinates;
    leafletStruct(maxLeaf+1).leafletID=maxID+1;
    leafletStruct(maxLeaf+1).area=0;
    leafletStruct(maxLeaf+1).Eccentricity=0;
    leafletStruct(maxLeaf+1).EquivDiameter=0;
    leafletStruct(maxLeaf+1).Orientation=0;
    leafletStruct(maxLeaf+1).MinorAxisLength=0;
    leafletStruct(maxLeaf+1).MajorAxisLength=0;
    leafletStruct(maxLeaf+1).PerimeterLeaflet=0;
    leafletStruct(maxLeaf+1).branchLength=0;
    leafletStruct(maxLeaf+1).baseToBranch=0;
    leafletStruct(maxLeaf+1).interRachis=NaN;
    maxLeaf=numel(leafletStruct);
    %%add Leaf Top point
    %
    leafletStruct(maxLeaf+1).crossingPoint=NaN;
    leafletStruct(maxLeaf+1).cutPoint=NaN;
    leafletStruct(maxLeaf+1).class='TopPoint';
    leafletStruct(maxLeaf+1).pathBaseEndpoint=NaN;
    leafletStruct(maxLeaf+1).cutpointCoord=[NaN,NaN];
    leafletStruct(maxLeaf+1).splitPoint1=[NaN,NaN];
    leafletStruct(maxLeaf+1).splitPoint2=[NaN,NaN];
    leafletStruct(maxLeaf+1).leafletIdentifier=NaN;
    leafletStruct(maxLeaf+1).distToTerminal=NaN;
    maxID=max([leafletStruct.leafletID]);
    leafletStruct(maxLeaf+1).centers=topPointCoordinates;
    leafletStruct(maxLeaf+1).leafletID=maxID+1;
    leafletStruct(maxLeaf+1).area=0;
    leafletStruct(maxLeaf+1).Eccentricity=0;
    leafletStruct(maxLeaf+1).EquivDiameter=0;
    leafletStruct(maxLeaf+1).Orientation=0;
    leafletStruct(maxLeaf+1).MinorAxisLength=0;
    leafletStruct(maxLeaf+1).MajorAxisLength=0;
    leafletStruct(maxLeaf+1).PerimeterLeaflet=0;
    leafletStruct(maxLeaf+1).branchLength=0;
    leafletStruct(maxLeaf+1).baseToBranch=0;
    leafletStruct(maxLeaf+1).interRachis=NaN;
    leafletStruct(maxLeaf+1).imageName=name;
    maxLeaf=numel(leafletStruct);
    %%add Terminal Mid point
    %
    %%add Points
    points=[midPoint(1,:);midPoint(2,:);dlP(1,:);dlP(2,:);drP(1,:);drP(2,:)];
    classes={'midPoint','midPoint','anglePoint','anglePoint','anglePoint','anglePoint'};
    for p=1:nrows(points)
        leafletStruct(maxLeaf+1).crossingPoint=NaN;
        leafletStruct(maxLeaf+1).cutPoint=NaN;
        leafletStruct(maxLeaf+1).class=classes{p};
        leafletStruct(maxLeaf+1).pathBaseEndpoint=NaN;
        leafletStruct(maxLeaf+1).cutpointCoord=[NaN,NaN];
        leafletStruct(maxLeaf+1).splitPoint1=[NaN,NaN];
        leafletStruct(maxLeaf+1).splitPoint2=[NaN,NaN];
        leafletStruct(maxLeaf+1).leafletIdentifier=NaN;
        leafletStruct(maxLeaf+1).distToTerminal=NaN;
        maxID=max([leafletStruct.leafletID]);
        leafletStruct(maxLeaf+1).centers=points(p,:);
        leafletStruct(maxLeaf+1).leafletID=maxID+1;
        leafletStruct(maxLeaf+1).area=0;
        leafletStruct(maxLeaf+1).Eccentricity=0;
        leafletStruct(maxLeaf+1).EquivDiameter=0;
        leafletStruct(maxLeaf+1).Orientation=0;
        leafletStruct(maxLeaf+1).MinorAxisLength=0;
        leafletStruct(maxLeaf+1).MajorAxisLength=0;
        leafletStruct(maxLeaf+1).PerimeterLeaflet=0;
        leafletStruct(maxLeaf+1).branchLength=0;
        leafletStruct(maxLeaf+1).baseToBranch=0;
        leafletStruct(maxLeaf+1).interRachis=NaN;
        leafletStruct(maxLeaf+1).imageName=name;
        maxLeaf=numel(leafletStruct);
    end
    %%%whole leaf features
    for s=1:(maxLeaf)
        leafletStruct(s).imageName=name;
        leafletStruct(s).LeafArea=leafArea;
        leafletStruct(s).leafPerimeter=leafPerimeter;
        leafletStruct(s).distBottomTerminal=numel(pathT);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % this script is responsible for making the final data set.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    imageNam=repmat({name},numel(leafletStruct),1);
    
    distToTerminal=[];
    leafAreas=[]
    for k=1:numel(leafletStruct)
        
        if(isempty(leafletStruct(k).distToTerminal))
            distToTerminal=[distToTerminal,0];
        else
            distToTerminal=[distToTerminal,leafletStruct(k).distToTerminal];
        end
        
    end
    
    splitPoints1=cell2mat({leafletStruct.splitPoint1}');
    splitPoints2=cell2mat({leafletStruct.splitPoint2}');
    cutCoordinates=cell2mat({leafletStruct.cutpointCoord}');
    crossCoordinates=cell2mat({leafletStruct.crossingPoint}');
    centerCoordinates=cell2mat({leafletStruct.centers}');
    %
    
    %
    scalingFactorRep=repmat({imageScale},numel(leafletStruct),1);
    leafAreaRep=repmat({leafArea},numel(leafletStruct),1);
    leafPerimeterRep=repmat({leafPerimeter},numel(leafletStruct),1);
    lenPathBottomTerminal=repmat({numel(pathT)},numel(leafletStruct),1);
    %    
    %
    %%%%%%%%%
    %To do: scaling factor ueberall raus
    %inter rachis dist raus
    %%%%%%%%%
    DS1=dataset(imageNam,[leafletStruct.leafletID]',{leafletStruct.class}',scalingFactorRep,lenPathBottomTerminal,distToTerminal',leafAreaRep,leafPerimeterRep,[leafletStruct.area]',splitPoints1(:,2),splitPoints1(:,1),splitPoints2(:,2),splitPoints2(:,1),cutCoordinates(:,2),cutCoordinates(:,1),centerCoordinates(:,2),centerCoordinates(:,1));
    DS1.Properties.VarNames={'imageName','leafletID','Class','ScalingFactor','distBottomTerminal','distanceToTerminalL','LeafArea','LeafPerimeter','Area','splitPoint1X','splitPoint1Y','splitPoint2X','splitPoint2Y','cutpointleafCoordinatesX','cutpointleafCoordinatesY','centerX','centerY'};
    %
    imwrite(label2rgb(imgBwLabeled),strcat(output,filesep,name,filesep,imageFolderName,filesep,name,'_labeled.png'))
    colorsComp=[0,1,0;1,0,0;0,0,1];
    imgLabeledComp=imageRachis+imageBranches*2+(imageLeaflets>0)*3;
    imwrite(label2rgb(imgLabeledComp,colorsComp),strcat(output,filesep,name,filesep,imageFolderName,filesep,name,'_labeledN.png'))
%     
%  
%      figure('visible','off');
%      imshow(binaryImage)
%      hold on
%      plot(DS1.cutpointleafCoordinatesX,DS1.cutpointleafCoordinatesY,'yo')
%      plot(DS1.splitPoint2X,DS1.splitPoint2Y,'bo')
%      plot(DS1.splitPoint1X,DS1.splitPoint1Y,'ro')
     
    %%%%%
    export(DS1,'file',strcat(folderPath,'.txt'),'Delimiter','\t');
    save(strcat(folderPath,'_struct.mat'),'leafletStruct');
    %%%%
    leafStruct.binaryImage=binaryImage;
    leafStruct.image=I;
    save(strcat(folderPath,'_Leafstruct.mat'),'leafStruct');
    %imgP=bwperim(binaryImage);
    %imgP=imdilate(imgP,strel('disk',1))
    %imwrite(imoverlay(I,imgP,[1,0,0]),strcat(output,filesep,'imgArea.jpg'))
%     imgBwLabeledN=imgBwLabeled;
%     imgBwLabeledN(imgBwLabeledN==9)=0;
%      imgBwLabeledN(imgBwLabeledN==11)=0;
%     imgBwLabeledN(imgBwLabeledN==10)=0;
%     imgBwLabeledN(imgBwLabeledN==8)=0;
%     imgBwLabeledN(imgBwLabeledN==7)=0;
%     imgBwLabeledN(imgBwLabeledN==6)=0;
%     imgBwLabeledN(imgBwLabeledN==5)=0;
%     %
     
%     
%     figure;imshow(imoverlay(I,leafletOutlines,[1,0,0]));
%    
     if(strfind(name, 'Nz'))
        colorAccession=[1 0 0];
     else
        colorAccession=[0 0 1];
     end
     imwrite(imoverlay(IComponent,binaryImage,colorAccession),strcat(output,filesep,name,filesep,imageFolderName,filesep,'wholeLeafArea.jpg'));
     leafOutline=imdilate(bwperim(binaryImage),strel('disk',2));
     imwrite(imoverlay(IComponent,leafOutline,colorAccession),strcat(output,filesep,name,filesep,imageFolderName,filesep,'wholeLeafOutline.jpg'))
     imwrite(imoverlay(IComponent,leafletOutlines,colorAccession),strcat(output,filesep,name,filesep,imageFolderName,filesep,'leafletOutlines.jpg'))
     imwrite(imoverlay(IComponent,imageLeaflets,colorAccession),strcat(output,filesep,name,filesep,imageFolderName,filesep,'leafletFilled.jpg'))
     %
     imwrite(imoverlay(IComponent,imageLeaflets,colorAccession),strcat(output,filesep,name,filesep,imageFolderName,filesep,'leafletFilled.jpg'))
     
     %%%%%
     

%      pointToDelete=zeros(size(imageLeaflets));
%      pointToDelete(topPointCoordinates(1),topPointCoordinates(2))=1;
%      pointToDelete(leafletStruct(1).splitPoint1(1),leafletStruct(1).splitPoint1(2))=1;
%      pointToDelete(leafletStruct(1).splitPoint2(1),leafletStruct(1).splitPoint2(2))=1;
%      pointToDelete=imdilate(pointToDelete,strel('disk',2));
    % imageTerminal(pointToDelete==1)=0;
     imageTerminal=bwlabel(imageTerminal);
     [coordsX,coordsY]=find(imageTerminal);
     linearInd=sub2ind(size(imageTerminal),coordsX,coordsY);
%      leafletsLin=imageLeaflets(:);
%      outlineNumber(find(outlineNumberO))=leafletsLin(find(outlineNumberO));
%      imageOutlineNumber=reshape(outlineNumber,size(leafletOutlines,1),size(leafletOutlines,2));
%      [coordsX,coordsY]=find(imageOutlineNumber);
%      linearInd=sub2ind(size(imageOutlineNumber),coordsX,coordsY);
     [I,J] = ind2sub(size(imgZ),find(imageTerminal));
     imageTerminal(linearInd);
     B = bwtraceboundary(imageTerminal==1,[I(1),J(1)],'N');
     %B = bwtraceboundary(imageTerminal==1,[287,134],'N',8
     
     
     
    pointsTerminal=[DS1.cutpointleafCoordinatesX(1),DS1.cutpointleafCoordinatesY(1);
     topPointCoordinates(2),topPointCoordinates(1);
        points(:,2),points(:,1)];
     lineSeqTable=dataset([repmat(0,nrows(pointsTerminal),1),pointsTerminal(:,1),pointsTerminal(:,2);repmat(1,nrows(B),1),B(:,2),B(:,1)]);
     export(lineSeqTable,'file',strcat(output,filesep,name,filesep,'cordTable.txt'),'WriteObsNames',false,'WriteVarNames',false);
     %tocFeatureCalculation=toc(ticFeatureCalculation)
    %timeD = toc(ticID1)
    %timeD
end

