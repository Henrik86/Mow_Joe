inputFolder1=''; %MowJoe Output Accession 1
inputFolder2=''; %MowJoe Output Accession 1


folderNames1=dir(inputFolder1);
folderNames1={folderNames1.name};
%
accession1=[];
for f1=4:numel(folderNames1)
    if(exist(strcat(inputFolder1,folderNames1{f1},filesep,folderNames1{f1},'_struct.mat')))
        load(strcat(inputFolder1,folderNames1{f1},filesep,folderNames1{f1},'_struct.mat'));
        if(isempty(accession1))
            accession1=leafletStruct;
        else
            accession1=[accession1;leafletStruct];
        end
    end
end
%%%%%%%%
folderNames2=dir(inputFolder2);
folderNames2={folderNames2.name};
%
accession2=[];
for f2=4:numel(folderNames2)
    if(exist(strcat(inputFolder2,folderNames2{f2},filesep,folderNames2{f2},'_struct.mat')))
        load(strcat(inputFolder2,folderNames2{f2},filesep,folderNames2{f2},'_struct.mat'));
        if(isempty(accession2))
            accession2=leafletStruct;
        else
            accession2=[accession2;leafletStruct];
        end
    end
end
%%%%%%%%
folderNames2=dir(inputFolder2);
folderNames2={folderNames2.name};
%
outputFolder='PathToOutput';
[ output_args ] = plotAccessionFunction( accession1,accession2,outputFolder);
%
nzaz=cellfun(@(x) x(1:2),leaveMatrix.imageName(cellfun('length',leaveMatrix.imageName) > 1),'un',0);
X=leaveMatrix(:,[2:10,12,15:26,28:37]);
X=double(X);
dimensionReductionFunc( accession1,accession2,outputFolder);
classificationFunc( accession1,accession2,outputFolder);
[ allCordsCutpointTransformed1,allCordsCrossingpointTransformed1,allBasesTransformed1,allTopPointsTransformed1,allCordsCentersTransformed1,allLeafletIDs1  ] = createMetaLeaf(inputFolder1);
[ allCordsCutpointTransformed2,allCordsCrossingpointTransformed2,allBasesTransformed2,allTopPointsTransformed2,allCordsCentersTransformed2,allLeafletIDs2  ] = createMetaLeaf(inputFolder2);
allPoints=[allCordsCutpointTransformed1;allCordsCrossingpointTransformed1;allBasesTransformed1;allTopPointsTransformed1;allCordsCentersTransformed1;allCordsCutpointTransformed2;allCordsCrossingpointTransformed2;allBasesTransformed2;allTopPointsTransformed2;allCordsCentersTransformed2];
figure('visible','off')
plotMetaLeaf( allCordsCutpointTransformed1,allCordsCrossingpointTransformed1,allBasesTransformed1,allTopPointsTransformed1,allCordsCentersTransformed1,allLeafletIDs1 )
axis([min(allPoints(:,2))-0.1 max(allPoints(:,2)) min(allPoints(:,1))-0.1  max(allPoints(:,1))])
saveas(gcf,strcat(outputFolder,filesep,'_metaleaf1.png'));
close;
figure('visible','off')
plotMetaLeaf( allCordsCutpointTransformed2,allCordsCrossingpointTransformed2,allBasesTransformed2,allTopPointsTransformed2,allCordsCentersTransformed2,allLeafletIDs2)
axis([min(allPoints(:,2))-0.1 max(allPoints(:,2)) min(allPoints(:,1))-0.1 max(allPoints(:,1))])
saveas(gcf,strcat(outputFolder,filesep,'metaleaf2.png'));
close;


