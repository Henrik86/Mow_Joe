function [ cp2 ] = crossValidation( leafMatrixWhole,classifierLeaf )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
indices = crossvalind('Kfold',nrows(leafMatrixWhole),10);
    cltrue=[];
    for i = 1:10
        test = (indices == i); 
        train = ~test;
        trainingLabel=classifierLeaf(train);
        svmT=svmtrain(leafMatrixWhole(train,:),trainingLabel);
        class = svmclassify(svmT,leafMatrixWhole(test,:));
        cltrue=[cltrue;class,classifierLeaf(test) ];
    end
    cp = classperf(cltrue(:,1));
    cp2=classperf(cp,cltrue(:,2));
end

