function [ leafMatrixWhole,nzazWhole ] = createFeatureMatrixWhole(accesion1,accesion2, featureNames,allNames,classification )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
  %%%%Merge
   accesion1TopPoint=accesion1(strcmp({accesion1.class},'TopPoint'),:);
   accesion2TopPoint=accesion2(strcmp({accesion2.class},'TopPoint'),:);
   if cell2mat( strfind({accesion1(1,:).imageName}, 'Nz'))
    dataNzAzWhole=[accesion1TopPoint;accesion2TopPoint];
   else 
    dataNzAzWhole=[accesion1TopPoint;accesion2TopPoint];
   end
   leafMatrixWhole=[];
   for i=1:numel(featureNames)
        leafMatrixWhole=[leafMatrixWhole,cell2mat({dataNzAzWhole.(featureNames{i})})']
   end
   [rN,cN]=find(isnan(leafMatrixWhole));
   leafMatrixWhole(:,cN)=[];
   nzazWhole=[repmat(1,numel(accesion1TopPoint),1);repmat(2,numel(accesion2TopPoint),1)];
end

