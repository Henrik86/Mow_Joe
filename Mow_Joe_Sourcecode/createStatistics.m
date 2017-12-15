function [ output_args ] = createStatistics( cellClusterM1 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%%%%%%%%%%%%%%%%
indexCell=1:nrows(cellClusterM1);
cellClusterMT=cellClusterM1;
indToDelete=find(cellClusterM1(:,indexStates)==0);
indexCellDT=indexCell;
indexCellDT(indToDelete)=[];
cellClusterMT(indToDelete,:)=[];
statesMT=cellClusterMT(:,indexStates);
colorsPlot=[]
for nC=1:nrows(cellClusterMT) 
    colorsPlot=[colorsPlot;COLORS_STATES(cellClusterMT(nC,indexStates),:)];
end
cellClusterMT=[muN';cellClusterMT(:,1:(indexStates-2))];
[pcF,scoreF,latentF,tsquareF]=princomp(cellClusterMT);
%%%%%
figure
hold on
xlim([min(scoreF(:,1)) max(scoreF(:,1))])
scatter(scoreF(7:nrows(cellClusterMT),1),scoreF(7:nrows(cellClusterMT),2),3,colorsPlot,'+');
scores1=scoreF(7:nrows(cellClusterMT),1);
scores2=scoreF(7:nrows(cellClusterMT),2);
for nH=1:nHStates
    [ x_bin_centers, y_bin_centers,counts ] = createHistMatrix( scores1(statesMT==nH), scores2(statesMT==nH),10 );
    [C H] = contour(x_bin_centers, y_bin_centers, counts',2,'Linecolor',COLORS_STATES(nH,:));
    set (H, 'LineWidth', 2); 
end
scatter(scoreF(1:6,1),scoreF(1:1:6,2),100,COLORS_STATES(1:6,:),'o','filled','MarkerEdgeColor','k');
saveas(gcf,strcat(outputFolderHMM,strcat('PCA'),'.pdf'), 'pdf')
close;
%%%%%
%%%%%
indicesSampled=randsample(numel(indexCellDT),20);
figure
hold on
scores1=scoreF(7:nrows(cellClusterMT),1);
scores2=scoreF(7:nrows(cellClusterMT),2);
scatter(scoreF(7:nrows(cellClusterMT),1),scoreF(7:nrows(cellClusterMT),2),1,colorsPlot,'+');
scatter(scoreF(1:6,1),scoreF(1:1:6,2),100,COLORS_STATES(1:6,:),'o','filled');
scatter(scores1(indicesSampled),scores2(indicesSampled),1,colorsPlot(indicesSampled,:),'s','filled');
text(scores1(indicesSampled),scores2(indicesSampled),num2str(indexCellDT(indicesSampled)'));
saveas(gcf,strcat(outputFolderHMM,strcat('PCA_text'),'.pdf'), 'pdf')
close;
%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PLOT HISTOGRAMS%%%%%%%%%%%%%%%%%%%%%%%%%%
fontSize=12
%%%
nHistStates=10;
indicesSwitched=[(nHistStates/2):nHistStates,1:((nHistStates/2)-1)];
figure ('visible','off');
    hold on
    for indS1=1:numStates
        indS1;
        timepointsState=cellClusterM1(cellClusterM1(:,indexStates)==indS1,indexCC_time)
        [h,b]=hist(timepointsState,[0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0]);
        h=h(indicesSwitched);
        b=b(indicesSwitched);
        p=plot(h,'-o','LineWidth',1,...
                'MarkerEdgeColor',COLORS_STATES(indS1,:),...
                'MarkerFaceColor',COLORS_STATES(indS1,:),...
                'MarkerSize',5);
       set(gca,'XTickLabel', b);
       set(p,'Color',COLORS_STATES(indS1,:),'LineWidth',4)
       set(gca,'FontSize',fontSize)
    end
    hold off

saveas(gcf,strcat(outputFolderHMM,strcat('CC_time_hist_1'),'.pdf'), 'pdf')
close;
%%%%%%%%%%COLORS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hotColors=hot(100);
colors_hot=hotColors(100:-1:30,:);
fontSize=12;
%%%%%%%%%%% write transition matrix Sequences%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    transmat1_nd=transProbSeqN - diag(diag(transProbSeqN));
    
     figure('visible','off')
    g2=subplot(2,2,(1:2));
    subimage(1:numStates,COLORS_STATES)
    colormap(COLORS_STATES)
    set(gca,'xtick',[],'ytick',[])
    p = get(g2,'position');
    p(4) = p(4)*0.35;
    p(3) = 0.2186;% Add 10 percent to height
    p(2) = p(2)-0.13;
    p(1) = 0.5703;
    set(g2, 'position', p);
    set(gca,'xtick',[],'ytick',[])

    g3=subplot(2,2,3);
    subimage((1:numStates)',COLORS_STATES)

    p = get(g3,'position');
    p(1) = p(1)+0.27;
    p(3) = p(3)*0.5; % Add 10 percent to height
    set(g3, 'position', p);
    set(gca,'xtick',[],'ytick',[])
    g4=subplot(2,2,4);
    colormap(colors_hot)
    set(gca,'xtick',[],'ytick',[])
    diffMatrix=abs(transmat1_nd);
    imagesc(diffMatrix)
    colorbar('location','EastOutside')
    p = get(g4,'position');
    set(gca,'xtick',[],'ytick',[])
    set(gca,'FontSize',fontSize)
    saveas(gcf,strcat(outputFolderHMM,strcat('TransitionSeq'),'.png'), 'png')
    close;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
transmat1_nd=transProbSeqN;
D = diag(diag(transmat1_nd));
diagVector=diag(transmat1_nd);
diagM=repmat(diagVector,1,ncols(transmat1_nd));
eBii=1./(1-D);
pBij=transmat1_nd./(1-diagM);
pBij=pBij-diag(diag(pBij));
matrixAll=eBii;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% write transition matrix Division%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('visible','off');
transmat1_nd=transProbDivN;
%%%%%

%%%%%
g2=subplot(2,2,(1:2));
colors=COLORS_STATES(1:numStates,:);
colorsLeft=repmat(colors,numStates,1);
colorsLeft=[];
for i = 1 : numStates
    colorsLeft=[colorsLeft;repmat(COLORS_STATES(i,:),numStates,1)];
end
colorsRight=colorsLeft(indicesXD,:);
%colorsAll= zeros(numStatesDiv*2,3,1)

%colorsAll(1:2:nrows(colorsAll),:)=colorsLeft
%colorsAll(2:2:nrows(colorsAll),:)=colorsRight
colorsAll=[colorsLeft;colorsRight];
subimage([1:numStatesDiv;(numStatesDiv+1):(numStatesDiv*2)],colorsAll)

colormap(repmat(colorsAll,3,1))
set(gca,'xtick',[],'ytick',[])
p = get(g2,'position');
p(4) = p(4)*0.35;
p(3) = 0.2417;% Add 10 percent to height
p(2) = p(2)-0.13;
p(1) = 0.5703;
set(g2, 'position', p);
set(gca,'xtick',[],'ytick',[])

g3=subplot(2,2,3);
subimage((1:numStates)',COLORS_STATES)
colormap(COLORS_STATES)
p = get(g3,'position');
p(1) = p(1)+0.27;
p(3) = p(3)*0.5; % Add 10 percent to height
set(g3, 'position', p);
set(gca,'xtick',[],'ytick',[])
g4=subplot(2,2,4);
colormap(colors_hot)
set(gca,'xtick',[],'ytick',[])
diffMatrix=numTransitions2Division;
imagesc(diffMatrix)
colorbar('location','EastOutside')
p = get(g4,'position');
set(gca,'xtick',[],'ytick',[])
set(gca,'FontSize',fontSize)
set(gcf, 'renderer','opengl'); % or painters, or zbuffer 
saveas(gcf,strcat(outputFolderHMM,strcat('NumTransitionDiv'),'.png'), 'png')
close;
%%%%%%%%%%%%%%%%%%%%% NUM TRANSITIONS DIV %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('visible','off');
%%%%%

%%%%%
g2=subplot(2,2,(1:2));
colors=COLORS_STATES(1:numStates,:);
colorsLeft=repmat(colors,numStates,1);
colorsLeft=[];
for i = 1 : numStates
    colorsLeft=[colorsLeft;repmat(COLORS_STATES(i,:),numStates,1)];
end
colorsRight=colorsLeft(indicesXD,:);
colorsAll=[colorsLeft;colorsRight];
subimage([1:numStatesDiv;(numStatesDiv+1):(numStatesDiv*2)],colorsAll)

colormap(repmat(colorsAll,3,1))
set(gca,'xtick',[],'ytick',[])
p = get(g2,'position');
p(4) = p(4)*0.35;
p(3) = 0.2417;% Add 10 percent to height
p(2) = p(2)-0.13;
p(1) = 0.5703;
set(g2, 'position', p);
set(gca,'xtick',[],'ytick',[])

g3=subplot(2,2,3);
subimage((1:numStates)',COLORS_STATES)
colormap(COLORS_STATES)
p = get(g3,'position');
p(1) = p(1)+0.27;
p(3) = p(3)*0.5; % Add 10 percent to height
set(g3, 'position', p);
set(gca,'xtick',[],'ytick',[])
g4=subplot(2,2,4);
colormap(colors_hot)
set(gca,'xtick',[],'ytick',[])
diffMatrix=abs(transmat1_nd);
imagesc(diffMatrix)
colorbar('location','EastOutside')
p = get(g4,'position');
set(gca,'xtick',[],'ytick',[])
set(gca,'FontSize',fontSize)
set(gcf, 'renderer','opengl'); % or painters, or zbuffer 
saveas(gcf,strcat(outputFolderHMM,strcat('TransitionDiv'),'.png'), 'png')
close;
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Create Number of Transitions %%%%%%%%%%%%%%%%%
numTransitions1=zeros(numStates,numStates);
allTransitions1=0;
for row = 1:nrows(stateMatrix1)
        startSequence=0;
        for col= 1:ncols(stateMatrix1)
            stateNew=stateMatrix1(row,col);
            if(startSequence==1 && stateNew ~= 0 &&  stateNew ~= 0 )
                numTransitions1(stateOld,stateNew)=numTransitions1(stateOld,stateNew)+1;
                allTransitions1=allTransitions1+1;
                stateOld=stateNew;
            end
            if(stateNew ~= 0 && startSequence == 0)
                startSequence=1;
                stateOld=stateMatrix1(row,col);
            end
        end
end
numTransitions1= numTransitions1;%/allTransitions1;

%%%%%%%%%%%%%%%%%%%% Plot Number of Transitions 1 %%%%%%%%%%%%%%%%%%%%%%%%%
figure('visible','off');
%diff matrix without diagonal
g2=subplot(2,2,(1:2));
subimage(1:numStates,COLORS_STATES)
colormap(COLORS_STATES)
set(gca,'xtick',[],'ytick',[])
p = get(g2,'position');
p(4) = p(4)*0.37;
p(3) = 0.2186;% Add 10 percent to height
p(2) = p(2)-0.12;
p(1) = 0.5703;
set(g2, 'position', p);
set(gca,'xtick',[],'ytick',[])

g3=subplot(2,2,3);
subimage((1:numStates)',COLORS_STATES)

p = get(g3,'position');
p(1) = p(1)+0.27;
p(3) = p(3)*0.5; % Add 10 percent to height
set(g3, 'position', p);
set(gca,'xtick',[],'ytick',[])
g4=subplot(2,2,4);
colormap(jet)
set(gca,'xtick',[],'ytick',[])
imagesc(numTransitions1- diag(diag(numTransitions1)))
p = get(g4,'position');
set(gca,'xtick',[],'ytick',[])
colorbar('location','EastOutside')
set(gca,'FontSize',fontSize)
saveas(gcf,strcat(outputFolderHMM,strcat('NumberOfTransitions'),'.png'), 'png')
close;
%%%%%%%%%%%%%%%%%%%% Plot Number of Transitions 1 Division %%%%%%%%%%%%%%%%%%%%%%%%%
figure('visible','off');
%diff matrix without diagonal
g2=subplot(2,2,(1:2));
subimage(1:numStates,COLORS_STATES)
colormap(COLORS_STATES)
set(gca,'xtick',[],'ytick',[])
p = get(g2,'position');
p(4) = p(4)*0.37;
p(3) = 0.2186;% Add 10 percent to height
p(2) = p(2)-0.12;
p(1) = 0.5703;
set(g2, 'position', p);
set(gca,'xtick',[],'ytick',[])

g3=subplot(2,2,3);
subimage((1:numStates)',COLORS_STATES)

p = get(g3,'position');
p(1) = p(1)+0.27;
p(3) = p(3)*0.5; % Add 10 percent to height
set(g3, 'position', p);
set(gca,'xtick',[],'ytick',[])
g4=subplot(2,2,4);
colormap(jet)
set(gca,'xtick',[],'ytick',[])
imagesc(numTransitions1- diag(diag(numTransitions1)))
p = get(g4,'position');
set(gca,'xtick',[],'ytick',[])
colorbar('location','EastOutside')
set(gca,'FontSize',fontSize)
saveas(gcf,strcat(outputFolderHMM,strcat('NumberOfTransitions'),'.png'), 'png')
close;

end

