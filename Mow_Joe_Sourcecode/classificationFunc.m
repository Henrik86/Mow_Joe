function [ score ] = dimensionReductionFunc( accesion1,accesion2,folderPath)
    %UNTITLED Summary of this function goes here
    %   PCA Plot for diffrent Accesions.
    classification=[]
    if cell2mat( strfind({accesion1(1,:).imageName}, 'Nz'))
      dataNzAz=[accesion1;accesion2];
      classification=[zeros(size(accesion1),1);ones(size(accesion2),1)]
    else 
      dataNzAz=[accesion2;accesion1];
      classification=[zeros(size(accesion2),1);ones(size(accesion1),1)]
    end
    
    lID=cell2mat({dataNzAz.leafletID});
    lID3=find(ismember(lID,[1 2 3]));
    dataNzAz=dataNzAz(lID3);
    classification=classification(lID3);
    classification=classification+1;
    allNames={dataNzAz.imageName};
    nzaz=cellfun(@(x) x(1:2),allNames(cellfun('length',{dataNzAz.imageName}) > 1),'un',0);
    
    
    featureNames={'area','Eccentricity'} ; 
    
    featureNames={'PerimeterLeaflet','branchLength','baseToBranch','interRachis','MinorAxisLength','MajorAxisLength','EquivDiameter'} ; 

    %%%%Merge
    leafMatrixWhole=[];
    leafMatrix=[];
    oldName=allNames(1);
    X=[];
    nameCounter=1
    classifierLeaf=[]
    nameLeaf={}
    for name=allNames
        name
        leafMatrix
        X=[];
        for i=1:numel(featureNames)
            X=[X,dataNzAz(nameCounter).(featureNames{i})];
        end
        if(strcmp(oldName,name)) 
            leafMatrix=[leafMatrix,X];
        else
          leafMatrixWhole=[leafMatrixWhole;leafMatrix];
          leafMatrix=X;
          nameLeaf=[nameLeaf;name]
          if(classification(nameCounter)==1)
              classifierLeaf=[classifierLeaf;1]
          else
              classifierLeaf=[classifierLeaf;2]
          end
        end
        oldName=name;
        nameCounter=nameCounter+1;
    end
    [rN,cN]=find(isnan(leafMatrixWhole));
    leafMatrixWhole(:,cN)=[];
    
    svmM=svmtrain(leafMatrixWhole,classifierLeaf);
    svmclassify(svmM,leafMatrixWhole);
    %%%%%%%
    featureNames={'area','Eccentricity','PerimeterLeaflet','branchLength','baseToBranch','interRachis','MinorAxisLength','MajorAxisLength','EquivDiameter'} ; 
    [ leafMatrixWhole ] = createFeatureMatrix(dataNzAz, featureNames,allNames,classification );
    [ cpAll ] = crossValidation( leafMatrixWhole,classifierLeaf); 
    %%%%%%%
    featureNames={'LeafArea','leafPerimeter'} ; 
    [ leafMatrixWL,classWL ] = createFeatureMatrixWL(accesion1,accesion2, featureNames,allNames,classification );
    [ cpWL ] = crossValidation( leafMatrixWL,classWL); 
    lA1=leafMatrixWL(classWL==1);
    lA2=leafMatrixWL(classWL==2);    
    %%%%%%%
    featureNames={'area','Eccentricity','PerimeterLeaflet','branchLength','baseToBranch','interRachis','MinorAxisLength','MajorAxisLength','EquivDiameter'} ; 
    [ leafMatrixL ] = createFeatureMatrix(dataNzAz, featureNames,allNames,classification );
    [ cpL ] = crossValidation( leafMatrixL,classifierLeaf); 
    %%%%%%%
    [COEFF,score] = princomp(leafMatrixWhole);
    cl=[1 0 0;0 0 1]
end

