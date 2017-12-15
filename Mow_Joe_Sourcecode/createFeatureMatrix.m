function [ leafMatrixWhole ] = createFeatureMatrixWhole(dataNzAz, featureNames,allNames,classification )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
  %%%%Merge
    leafMatrixWhole=[];
    leafMatrix=[];
    oldName=allNames(1);
    X=[];
    nameCounter=1;
    classifierLeaf=[];
    nameLeaf={};
    for name=allNames
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

end

