load(strcat('C:\\Users\\hfailmezger\\Documents\\Mow-Joe\\NZ\\NZ\\Nz_001\\Nz_001_struct.mat'));

[dataGS,txt,raw] = xlsread('C:\\Users\\hfailmezger\\Documents\\Mow-Joe\\Manuel\\Nz_001_T.xlsb');

leafletStructID=[leafletStruct.leafletID];
leafletBranchLength=[leafletStruct.branchLength];

numLeaflets=size(dataGS,2);

deviationBranchs=[];
for(n=1:numLeaflets)
    leafletID=leafletStructID(n);
    branchLengthGS=dataGS(dataGS(:,strcmp(txt,'leafletID'))==leafletID,strcmp(txt,'Branch Length'));
    if size(branchLengthGS,1)>0
        branchLengthMJ=leafletBranchLength(leafletStructID==leafletID);
        devBranch=abs(branchLengthMJ-branchLengthGS);
        deviationBranchs=[deviationBranchs,devBranch];
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load(strcat('C:\\Users\\hfailmezger\\Documents\\Mow-Joe\\NZ\\NZ\\Nz_002\\Nz_002_struct.mat'));

[dataGS,txt,raw] = xlsread('C:\\Users\\hfailmezger\\Documents\\Mow-Joe\\Manuel\\Results-Nz_002.xlsx');

leafletStructID=[leafletStruct.leafletID];
leafletBranchLength=[leafletStruct.branchLength];

numLeaflets=size(dataGS,2);

deviationBranchs=[];
for(n=1:size(leafletStructID,2))
    leafletID=leafletStructID(n);
    branchLengthGS=dataGS(dataGS(:,strcmp(txt,'leafletID'))==leafletID,strcmp(txt,'Branch Length'));
    if size(branchLengthGS,1)>0
        branchLengthMJ=leafletBranchLength(leafletStructID==leafletID);
        devBranch=abs(branchLengthMJ-branchLengthGS);
        deviationBranchs=[deviationBranchs,devBranch];
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load(strcat('C:\\Users\\hfailmezger\\Documents\\Mow-Joe\\NZ\\NZ\\Nz_005\\Nz_005_struct.mat'));

[dataGS,txt,raw] = xlsread('C:\\Users\\hfailmezger\\Documents\\Mow-Joe\\Manuel\\Results-Nz_002.xlsx');

leafletStructID=[leafletStruct.leafletID];
leafletBranchLength=[leafletStruct.branchLength];

numLeaflets=size(dataGS,2);

deviationBranchs=[];
for(n=1:size(leafletStructID,2))
    leafletID=leafletStructID(n);
    branchLengthGS=dataGS(dataGS(:,strcmp(txt,'leafletID'))==leafletID,strcmp(txt,'Branch Length'));
    if size(branchLengthGS,1)>0
        branchLengthMJ=leafletBranchLength(leafletStructID==leafletID);
        devBranch=abs(branchLengthMJ-branchLengthGS);
        deviationBranchs=[deviationBranchs,devBranch];
    end
end