
 imagefiles = dir(fullfile('leafimages1','*.jpg'));

% imagefiles = dir(fullfile('getDirectory','*.jpg'));
nfiles = length(imagefiles);    % Number of files found
finalDS=dataset;
for ii=58:nfiles
   imageStringName = ['leafimages1/' ,imagefiles(ii).name];
   output='C:\Users\nasim\Documents\MATLAB\new\';
   latestScript;
   close all;  
   statArea{ii}=leaveAreas';
   statDist{ii}=distToTerminal;
   %finalDS=[finalDS;T];

   clearvars -except imagefiles nfiles statArea statDist finalDS;
   
end
% for theCountofImages = 19:1:23
%     imgageCount=theCountofImages;
%    filename = ['leaves/' num2str(theCountofImages) '.png'];
% %    img{theCountofImages} = imread(filename);
%   % imageStringName=num2str(theCountofImages);
%    imageStringName=filename;
% %  I=img{theCountofImages};
% %  newCode;
%    latestScript;
% %    save (num2str(imgageCount),'graph','crossingPoint','cutArray','leaveAreas','distToTerminal')
% %    statArea{theCountofImages}=leaveAreas';
% %    statDist{theCountofImages}=distToTerminal;
% %    clearvars -except statArea statDist;
% close all;    
% clear;
%     
% %    
% end
% ii =7 ,26,35,52,59,60,87,96,105
