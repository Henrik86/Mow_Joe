imageNam=repmat(name,numel(leafletID),1);
    cutCoordinates= cell2mat({graph(cutArray).coordinate}');

    DS=dataset(imageNam,leafletID',(1/imageScale)*distToTerminal',(1/imageScale)*leaveAreas',splitPoints1,splitPoints2,cutCoordinates);
    DS.Properties.VarNames={'imageName','leafletID','distanceToTerminalL','Area','cutpointleafCoordinatesY','cutpointleafCoordinatesX','cutcoordinates'};

    export(DS,'file',strcat(folderPath,'.txt'),'Delimiter','\t');