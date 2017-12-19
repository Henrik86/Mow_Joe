function [ output_args ] = plotMetaLeaf( allCordsCutpointTransformed,allCordsCrossingpointTransformed,allBasesTransformed,allTopPointsTransformed,allCordsCentersTransformed,allLeafletIDs )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
  
  hold on
  plot(allCordsCentersTransformed(:,2),allCordsCentersTransformed(:,1),'o','MarkerEdgeColor','k','MarkerFaceColor','m')
  plot(allCordsCutpointTransformed(:,2),allCordsCutpointTransformed(:,1),'o','MarkerEdgeColor','k','MarkerFaceColor','b')
  plot(allCordsCrossingpointTransformed(:,2),allCordsCrossingpointTransformed(:,1),'o','MarkerEdgeColor','k','MarkerFaceColor','g')
  
  %%%%
  allLID=unique(allLeafletIDs);
  meanLeafletsCenter=[];
  meanLeafletsCutpoint=[];
  meanLeafletsCrossing=[];
  for li=allLID
    indicesLeaf=(allLeafletIDs==li);  
    if(numel(find(indicesLeaf))>1)
        mCC=mean(allCordsCentersTransformed(allLeafletIDs==li,:));
        meanLeafletsCenter=[meanLeafletsCenter;mCC];
        mLC=mean(allCordsCutpointTransformed(allLeafletIDs==li,:));
        meanLeafletsCutpoint=[meanLeafletsCutpoint;mLC];
        mCP=mean(allCordsCrossingpointTransformed(allLeafletIDs==li,:));
        meanLeafletsCrossing=[meanLeafletsCrossing;mCP];
        line([mCC(2) mLC(2)],[mCC(1),mLC(1)],'LineWidth',2,'color','b')
        line([mLC(2) mCP(2)],[mLC(1),mCP(1)],'LineWidth',2,'color','b')
        plot(mCC(2),mCC(1),'o','MarkerEdgeColor','k','MarkerFaceColor','m','MarkerSize',15, 'LineWidth',2)
        plot(mLC(2),mLC(1),'o','MarkerEdgeColor','k','MarkerFaceColor','b','MarkerSize',15, 'LineWidth',2)
        plot(mCP(2),mCP(1),'o','MarkerEdgeColor','k','MarkerFaceColor','g','MarkerSize',15, 'LineWidth',2)
        
    else
        mCC=mean(allCordsCentersTransformed);
        meanLeafletsCenter=[meanLeafletsCenter;mCC];
        mLC=mean(allCordsCutpointTransformed);
        meanLeafletsCutpoint=[meanLeafletsCutpoint;mLC];
        mCP=mean(allCordsCrossingpointTransformed);
        meanLeafletsCrossing=[meanLeafletsCrossing;mCP];
    end
  end
  %%%%
  meanTopPoint=mean(allTopPointsTransformed);
  line([allBasesTransformed(1) allBasesTransformed(2)],[meanTopPoint(2),meanTopPoint(1)],'LineWidth',2)
  plot(allBasesTransformed(:,2),allBasesTransformed(:,1),'o','MarkerEdgeColor','k','MarkerFaceColor','y','MarkerSize',10, 'LineWidth',2)
  plot(allTopPointsTransformed(:,2),allTopPointsTransformed(:,1),'o','MarkerEdgeColor','k','MarkerFaceColor','y','MarkerSize',10, 'LineWidth',2)

end

