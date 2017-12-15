function [ output_args ] = plotAccessionFunction( accesion1,accesion2,folderPath )
%plot the accesion of NZ and Az
% it will plot each of the features in one plot
% the data of different accesions should be given to it seperately 
 accesion1TopPoint=accesion1(strcmp({accesion1.class},'TopPoint'),:);
 accesion2TopPoint=accesion2(strcmp({accesion2.class},'TopPoint'),:);
 %
 accesion2(strcmp({accesion2.class},'TopPoint'),:)=[];
 accesion1(strcmp({accesion1.class},'TopPoint'),:)=[];
 accesion2(strcmp({accesion2.class},'TopPoint'),:)=[];
 
 accesion1(strcmp({accesion1.class},'bottomPoint'),:)=[];
 accesion2(strcmp({accesion2.class},'bottomPoint'),:)=[];

 if cell2mat( strfind(accesion1.imageName(1), 'Nz'))
      dataNzAz=[accesion1;accesion2];
 else 
      dataNzAz=[accesion2;accesion1];
 end
  nzaz=cellfun(@(x) x(1:2),dataNzAz.imageName(cellfun('length',dataNzAz.imageName) > 1),'un',0);
  screen_size = get(0, 'ScreenSize');
    
    %hFig = figure;
   % set(hFig, 'Position', [0 0 screen_size(3) screen_size(4) ] );
    color1=[1 0 0];
    color2=[0 0 1];
    colorComb=[color1;color2]
    for i=1:14
        %subplot(4,4,i)
        figure   ('visible','off');
        hold on
        boxplot(accesion1.(accesion1.Properties.VarNames{i+4}))

        boxplot(dataNzAz.(dataNzAz.Properties.VarNames{i+4}),{dataNzAz.leafletID,nzaz},'labels',dataNzAz.leafletID,'colors','rbrbrbrbrbrr','factorgap',[5 2],'labelverbosity','minor','symbol','k+','medianstyle','target');

        boxplot(dataNzAz.(dataNzAz.Properties.VarNames{i+4}),{dataNzAz.leafletID,nzaz},'labels',dataNzAz.leafletID,'colors','rbrbrbrbrbrr','factorgap',[5 2],'labelverbosity','minor','symbol','k+','medianstyle','target');
        %
        h = findobj(gca,'Tag','Box');
        boxPositionsDev=get(h,'XData');
        colorsDev=[colorComb;colorComb;colorComb;colorComb;colorComb;color1;color1];
        for j=1:length(h)
            patch(get(h(j),'XData'),get(h(j),'YData'),colorsDev(length(h)-(j-1),:),'FaceAlpha',1);
        end
        boxplot(dataNzAz.(dataNzAz.Properties.VarNames{i+4}),{dataNzAz.leafletID,nzaz},'labels',dataNzAz.leafletID,'colors','rbrbrbrbrbrr','factorgap',[5 2],'symbol','k+','medianstyle','target','labelverbosity','minor');
          
        set(findall(gca, '-property', 'FontSize'), 'FontSize', 12, 'fontWeight', 'bold');
       
         ylabel(dataNzAz.Properties.VarNames{i+4});
         xlabel('LeafLet ID');
         hLegend = legend(findall(gca,'Tag','Box'), {'Nz','Az'});
         hChildren = findall(get(hLegend,'Children'), 'Type','Line');

         set(hChildren(4),'Color',[1 0 0])
         set(hChildren(2),'Color',[0 0 1])
         %set(hChildren(2),'Color',[0 0.5 0])
         saveas(gcf,strcat(folderPath,filesep,dataNzAz.Properties.VarNames{i+4},'.png'));
         close;
    end
    
    %ploting of the whole leaf Features , such as LeafAra and
    %LeafPEriemeter
    
 if cell2mat( strfind(accesion1.imageName(1), 'Nz'))
      dataNzAzWhole=[accesion1TopPoint;accesion2TopPoint];
 else 
      dataNzAzWhole=[accesion1TopPoint;accesion2TopPoint];
 end
nzazWhole=cellfun(@(x) x(1:2),dataNzAz.imageName(cellfun('length',dataNzAzWhole.imageName) > 1),'un',0);
screen_size = get(0, 'ScreenSize'); 
is=[2,5,7,8];
for iss=is
    hFig = figure('visible','off');
    hold on;
    set(hFig, 'Position', [0 0 screen_size(3) screen_size(4) ] );
    boxplot(dataNzAzWhole.(dataNzAzWhole.Properties.VarNames{iss}),nzaz,'colors','rb');
    %
    h = findobj(gca,'Tag','Box');
    boxPositionsDev=get(h,'XData');
    colorsDev=[colorComb;colorComb;colorComb;colorComb;colorComb;color1;color1];
    for j=1:length(h)
        patch(get(h(j),'XData'),get(h(j),'YData'),colorsDev(length(h)-(j-1),:),'FaceAlpha',1);
    end
    boxplot(dataNzAzWhole.(dataNzAzWhole.Properties.VarNames{iss}),nzaz,'colors','rb');
    %
    set(findall(gca, '-property', 'FontSize'), 'FontSize', 15, 'fontWeight', 'normal');

    ylabel(dataNzAz.Properties.VarNames{iss});
    xlabel('Accesions');
    hLegend = legend(findall(gca,'Tag','Box'), {'Nz','Az'});
    hChildren = findall(get(hLegend,'Children'), 'Type','Line');

    set(hChildren(4),'Color',[1 0 0]);
    set(hChildren(2),'Color',[0 0 1]);
    %set(hChildren(2),'Color',[0 0.5 0])
    saveas(gcf,strcat(folderPath,filesep,dataNzAz.Properties.VarNames{iss},'.png'));
    close;
end
end

