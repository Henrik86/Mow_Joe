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
    
    featureNames={'LeafArea','leafPerimeter','Eccentricity','PerimeterLeaflet','branchLength','baseToBranch','interRachis','MinorAxisLength','MajorAxisLength','EquivDiameter'} ; 
    
    %featureNames={'LeafArea','Eccentricity'} ; 
    
    
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
    [COEFF,score] = princomp(leafMatrixWhole);
    cl=[1 0 0;0 0 1]
    %%%%%
    hFig = figure;
    hold on
    indA1=find(classifierLeaf==1);
    indA2=find(classifierLeaf==2);
    plot(score(indA1,1), score(indA1,2), 'o','color',[1 0 0],'MarkerFaceColor',[1 0 0]);
    plot(score(indA2,1), score(indA2,2), 'o','color',[0 0 1],'MarkerFaceColor',[0 0 1]);
    %(LeafletID,Area,distanceToTerminalL,Eccentricity,EquivDiameter,Orientation,MinorAxisLength,MajorAxisLength,Perimeter,BaseToBranch,Branchlength,Interrachis)')
    %str = {'The first three leaflets with the terminal leave interrachis and branch length removed.'};
    %annotation('textbox', [0.91,0,0.04,0.9], 'String', str,'FitHeightToText','on','FitBoxToText','on');
    xlabel('PC1');
    ylabel('PC2');
    hold off
    hLegend = legend(findall(gca,'Tag','Box'),{'Nz','Ox'});
    hChildren = findall(get(hLegend,'Children'), 'Type','Line');
    set(hChildren(4),'Color',[1 0 0])
    set(hChildren(2),'Color',[0 0 1])
    saveas(gcf,strcat(folderPath,filesep,'PCA.png'));
    close;
    %%%%%
    hFig = figure;
    hold on
    indA1=find(classifierLeaf==1);
    indA2=find(classifierLeaf==2);
    plot(score(indA1,1), score(indA1,2), 'o','color',[1 0 0],'MarkerFaceColor',[1 0 0]);
    plot(score(indA2,1), score(indA2,2), 'o','color',[0 0 1],'MarkerFaceColor',[0 0 1]);
    text(score(indA1,1), score(indA1,2), nameLeaf(indA1));
    text(score(indA2,1), score(indA2,2), nameLeaf(indA2));
    %(LeafletID,Area,distanceToTerminalL,Eccentricity,EquivDiameter,Orientation,MinorAxisLength,MajorAxisLength,Perimeter,BaseToBranch,Branchlength,Interrachis)')
    %str = {'The first three leaflets with the terminal leave interrachis and branch length removed.'};
    %annotation('textbox', [0.91,0,0.04,0.9], 'String', str,'FitHeightToText','on','FitBoxToText','on');
    xlabel('PC1');
    ylabel('PC2');
    hold off
    hLegend = legend(findall(gca,'Tag','Box'),{'Nz','Ox'});
    hChildren = findall(get(hLegend,'Children'), 'Type','Line');
    set(hChildren(4),'Color',[1 0 0])
    set(hChildren(2),'Color',[0 0 1])
    saveas(gcf,strcat(folderPath,filesep,'PCA_text.png'));
    close;
    

end

