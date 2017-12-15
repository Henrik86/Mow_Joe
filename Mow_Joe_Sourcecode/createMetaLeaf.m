function [ allCordsCutpointTransformed,allCordsCrossingpointTransformed,allBasesTransformed,allTopPointsTransformed,allCordsCentersTransformed,allLeafletIDs  ] = dimensionReductionFunc( inputFolder1)
    %UNTITLED Summary of this function goes here
    %   PCA Plot for diffrent Accesions.
    folderNames1=dir(inputFolder1);
    folderNames1={folderNames1.name};
    %
    allCordsCentersTransformed=[];
    allCordsCrossingpointTransformed=[];
    allCordsCutpointTransformed=[];
    allBasesTransformed=[];
    allTopPointsTransformed=[];
    allLeafletIDs=[];
    allCords=[]
    accession1=[]
    for f1=4:numel(folderNames1)
        pointsX=[];
        pointsY=[];
        %
        
        
        if(exist(strcat(inputFolder1,folderNames1{f1},filesep,folderNames1{f1},'_struct.mat')))
            load(strcat(inputFolder1,folderNames1{f1},filesep,folderNames1{f1},'_Leafstruct.mat'));
            imgBR=bwlabel(leafStruct.binaryImage);
            RP=regionprops(imgBR);
            centerMass=RP.Centroid;
            centerMass=[centerMass(2),centerMass(1)]
            load(strcat(inputFolder1,folderNames1{f1},filesep,folderNames1{f1},'_struct.mat'));
            %
            indexBasePoint=strcmp({leafletStruct.class},'bottomPoint');
            indexTopPoint=strcmp({leafletStruct.class},'TopPoint');
            %%%%
            %devBasisRatio(:,1)=devBasisRatio(:,1)/distCMBase;
            base=[leafletStruct(indexBasePoint).centers(1), leafletStruct(indexBasePoint).centers(2)];
            top=[leafletStruct(indexTopPoint).centers(1), leafletStruct(indexTopPoint).centers(2)];
            vTilde=[centerMass(1)-base(1),centerMass(2)-base(2)];
            l=(sqrt(sum(vTilde(1)^2+vTilde(2)^2)));
            v=vTilde/l;
            w=[-v(2),v(1)];
            cordTransformed=[];
            %%
            indicesLeaflet=strcmp({leafletStruct.class},'leaflet');
            allLeafletIDs=[allLeafletIDs,leafletStruct(indicesLeaflet).leafletID];
            cordsCenters=cell2mat({leafletStruct(indicesLeaflet).centers}');
            cordTransformedCenters=transformCoordinates([cordsCenters(:,2),cordsCenters(:,1)],top,base);
            crossingPointCord=transformCoordinates(cell2mat({leafletStruct(indicesLeaflet).crossingPointCoord}'),top,base);
            cutPointCord=transformCoordinates(cell2mat({leafletStruct(indicesLeaflet).cutpointCoord}'),top,base);
            allCordsCentersTransformed=[allCordsCentersTransformed;cordTransformedCenters];
            %
            allCordsCutpointTransformed=[allCordsCutpointTransformed;cutPointCord];
            allCordsCrossingpointTransformed=[allCordsCrossingpointTransformed;crossingPointCord];
            allCords=[allCords;cell2mat({leafletStruct(indicesLeaflet).centers}')];
            allBasesTransformed=[allBasesTransformed;transformCoordinates(base,top,base)];
            allTopPointsTransformed=[allTopPointsTransformed;transformCoordinates(top,top,base)];
            %
        end
    end 
    
 
  

end

