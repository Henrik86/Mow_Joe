function [ output_args ] = createTable( inputFolder,outputFolder)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
imagefiles = dir(inputFolder);
imagefiles={imagefiles.name}';
% imagefiles = dir(fullfile('getDirectory','*.jpg'));
maxNumLeaflets=0;
numLeafs=0;
columnsLeaflet=0;
nfiles = length(imagefiles);    % Number of files found
cordTable=dataset();
allTables={};
for ii=1:nfiles
        if(isempty(strfind(imagefiles{ii},'.')) && ~strcmp(imagefiles{ii},'.') && ~strcmp(imagefiles{ii},'..'))
            if(exist(strcat(inputFolder,filesep,imagefiles{ii},filesep,imagefiles{ii},'.txt'),'file'))
                dt=dataset('File',strcat(inputFolder,filesep,imagefiles{ii},filesep,imagefiles{ii},'.txt'));
                allTables{ii}=dt;
                numLeaflets=nrows(dt);
                if(numLeaflets>maxNumLeaflets)
                    maxNumLeaflets=numLeaflets;
                end
                numLeafs=numLeafs+1;
                columnsLeaflet=ncols(dt);
                %%%
                if(exist(strcat(inputFolder,filesep,imagefiles{ii},filesep,'cordTable.txt')))
                    cordT=dataset('File',strcat(inputFolder,filesep,imagefiles{ii},filesep,'cordTable.txt'));
                    cordT.Properties.VarNames={'V1' 'V2' 'V3'}
                    if(size(cordTable,1)==0)
                        cordTable=cordT;
                    else
                        cordTable=cat(1,cordTable,cordT);
                    end
                end
            end
     end
end
%%

%%
table=cell(numLeafs, columnsLeaflet*maxNumLeaflets);
varNames=dt.Properties.VarNames;
singleVarNames={'imageName','LeafArea','ScalingFactor'};
varNames(ismember(varNames,{'imageName','LeafArea','ScalingFactor'}))=[];

headerString={'imageName','LeafArea','ScalingFactor'};
for f=1:maxNumLeaflets
    headerString=[headerString,strcat(varNames,'_',num2str(f))];
end


for tr=1:numel(allTables)
    dtn=allTables{tr};
    if(~isempty(dtn))
        cellsRow=cell(maxNumLeaflets,(columnsLeaflet-3))
        rowTableStandard={dtn.imageName{1},dtn.LeafArea(1),dtn.ScalingFactor(1)};
        leafIDs=dtn.leafletID;
        leafIDsSorted=sort(leafIDs);
        for r=1:nrows(dtn)
            rowTable={}
            for dc=2:ncols(dtn)
                if(isempty(find(ismember(singleVarNames,dt.Properties.VarNames(dc)), 1)))
                    rowTable=[rowTable,dtn{r,dc}];
                end
            end
            cellsRow(leafIDs(r),1:ncols(rowTable))=rowTable;
        end
        rowT=[rowTableStandard,reshape(cellsRow.',1,[])];
        table(tr,1:ncols(rowT))=[rowT];
    end
end
splittedPath=strsplit('/',inputFolder);
fid=fopen(strcat(outputFolder,filesep,splittedPath{end},'Leaf_Table.tab'),'wt');
fprintf(fid,'%s\t',headerString{:})
[rows,cols]=size(table);
for i=1:rows
      rowTable=cellfun(@num2str, table(i,:), 'UniformOutput', false);
      fprintf(fid,'%s\t',rowTable{1:end-1});
      fprintf(fid,'%s\n',rowTable{end});
end
fclose(fid);
%%%%
allLandmarks=[];
fid=fopen(strcat(outputFolder,filesep,splittedPath{end},'_landmarks_MorphoJ.txt'),'wt');
leafletIdsToMeasure=[1];
for tr=1:numel(allTables)
    dtn=allTables{tr};
    if(~isempty(dtn))
        fprintf(fid,'LM=%i\n',8);
        for r=1:nrows(dtn)
                if(~isempty(find(leafletIdsToMeasure==dtn.leafletID(r))))
                    %fprintf(fid,'%i\t%i\n',dtn.splitPoint1X(r),dtn.splitPoint1Y(r));
                    %fprintf(fid,'%i\t%i\n',dtn.splitPoint2X(r),dtn.splitPoint2Y(r));
                    fprintf(fid,'%i\t%i\n',dtn.cutpointleafCoordinatesX(r),dtn.cutpointleafCoordinatesY(r));
                    if(dtn.leafletID(r)==1)
                       indexCT=find(strcmp(dtn.Class,'TopPoint'));
                       fprintf(fid,'%i\t%i\n',dtn.centerX(indexCT),dtn.centerY(indexCT));
                       indexC=find(strcmp(dtn.Class,'midPoint'));
                       fprintf(fid,'%i\t%i\n',dtn.centerX(indexC(1)),dtn.centerY(indexC(1)));
                       fprintf(fid,'%i\t%i\n',dtn.centerX(indexC(2)),dtn.centerY(indexC(2)));
                       indexC=find(strcmp(dtn.Class,'anglePoint'));
                       fprintf(fid,'%i\t%i\n',dtn.centerX(indexC(1)),dtn.centerY(indexC(1)));
                       fprintf(fid,'%i\t%i\n',dtn.centerX(indexC(2)),dtn.centerY(indexC(2)));
                       fprintf(fid,'%i\t%i\n',dtn.centerX(indexC(3)),dtn.centerY(indexC(3)));
                       fprintf(fid,'%i\t%i\n',dtn.centerX(indexC(4)),dtn.centerY(indexC(4)));
                    end
                    allLandmarks=[allLandmarks;[dtn.splitPoint1X(r) dtn.splitPoint1Y(r)]];
                    allLandmarks=[allLandmarks;[dtn.splitPoint2X(r) dtn.splitPoint2Y(r)]];
                    allLandmarks=[allLandmarks;[dtn.cutpointleafCoordinatesX(r) dtn.cutpointleafCoordinatesY(r)]];
                    allLandmarks=[allLandmarks;[dtn.centerX(indexC) dtn.centerY(indexC)]];
                end
        end
        fprintf(fid,'IMAGE=%s\n',dtn.imageName{1});
        fprintf(fid,'ID=%s\n',dtn.imageName{1});
    end
end
fclose(fid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%
allLandmarks=[];
fid=fopen(strcat(outputFolder,filesep,splittedPath{end},'_landmarks_RShapes.txt'),'wt');
leafletIdsToMeasure=[1];
for tr=1:numel(allTables)
    dtn=allTables{tr};
    if(~isempty(dtn))
        for r=1:nrows(dtn)
                if(~isempty(find(leafletIdsToMeasure==dtn.leafletID(r))))
                    %fprintf(fid,'%i\t%i\n',dtn.splitPoint1X(r),dtn.splitPoint1Y(r));
                    %fprintf(fid,'%i\t%i\n',dtn.splitPoint2X(r),dtn.splitPoint2Y(r));
                    fprintf(fid,'%i\t%i\t',dtn.cutpointleafCoordinatesX(r),dtn.cutpointleafCoordinatesY(r));
                    if(dtn.leafletID(r)==1)
                       indexCT=find(strcmp(dtn.Class,'TopPoint'));
                       fprintf(fid,'%i\t%i\t',dtn.centerX(indexCT),dtn.centerY(indexCT));
                       indexC=find(strcmp(dtn.Class,'midPoint'));
                       fprintf(fid,'%i\t%i\t',dtn.centerX(indexC(1)),dtn.centerY(indexC(1)));
                       fprintf(fid,'%i\t%i\t',dtn.centerX(indexC(2)),dtn.centerY(indexC(2)));
                       indexC=find(strcmp(dtn.Class,'anglePoint'));
                       fprintf(fid,'%i\t%i\t',dtn.centerX(indexC(1)),dtn.centerY(indexC(1)));
                       fprintf(fid,'%i\t%i\t',dtn.centerX(indexC(2)),dtn.centerY(indexC(2)));
                       fprintf(fid,'%i\t%i\t',dtn.centerX(indexC(3)),dtn.centerY(indexC(3)));
                       fprintf(fid,'%i\t%i\t',dtn.centerX(indexC(4)),dtn.centerY(indexC(4)));
                    end
                    allLandmarks=[allLandmarks;[dtn.splitPoint1X(r) dtn.splitPoint1Y(r)]];
                    allLandmarks=[allLandmarks;[dtn.splitPoint2X(r) dtn.splitPoint2Y(r)]];
                    allLandmarks=[allLandmarks;[dtn.cutpointleafCoordinatesX(r) dtn.cutpointleafCoordinatesY(r)]];
                    allLandmarks=[allLandmarks;[dtn.centerX(indexC) dtn.centerY(indexC)]];
                end
        end
         fprintf(fid,'\n');
    end
end
fclose(fid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dL=dataset(zeros(nrows(allLandmarks(1:8,:)),1),allLandmarks(1:8,2),allLandmarks(1:8,1));
dL.Properties.VarNames=cordTable.Properties.VarNames;
cordTable=cat(1,dL,cordTable);
export(cordTable,'File',strcat(outputFolder,filesep,splittedPath{end},'_cordsLineSegments.txt'),'WriteObsNames',false,'WriteVarNames',false)
%%%%%