function [ output_args ] = folderReadingFunction( input,output,lengthBranch )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

 imagefiles = dir(input);

% imagefiles = dir(fullfile('getDirectory','*.jpg'));
nfiles = length(imagefiles);    % Number of files found
for ii=1:nfiles
    if(~isempty(strfind(imagefiles(ii).name,'.jpg')) || ~isempty(strfind(imagefiles(ii).name,'.jpeg')) || ~isempty(strfind(imagefiles(ii).name,'.tif')))
        imageStringName = [input,filesep,imagefiles(ii).name];
   
        try
             mainScript(imageStringName,output,lengthBranch);
        catch err
            imageStringName   
        end
    end
   %close all;  
%    statArea{ii}=leaveAreas';
%    statDist{ii}=distToTerminal;
   %finalDS=[finalDS;T];

 % clearvars -except imagefiles nfiles handles;
   
end
end
% check for the last image number 59 , there was an error with the
% binarization , also try to make the gui into better one , work on the try
% and catch so it can be run 
