  
   [x111,x22]=findPathcolor(SN,graph,map,1,cutArray(1));

   dilatedSkel = imdilate(S2,strel('disk',5));
   dilatedSkel1 = imdilate(x22,strel('disk',5));
   
   redChannel = rgbImage(:, :, 1);
   greenChannel = rgbImage(:, :, 2);
   blueChannel = rgbImage(:, :, 3);

   
   redChannel(dilatedSkel==rachis)=30;
   greenChannel(dilatedSkel==rachis)=144;
   blueChannel(dilatedSkel==rachis)=255;
   DRGB=cat(3,redChannel,greenChannel,blueChannel);
   figure,imshow(DRGB);
%    93,71,139
   redChannel(dilatedSkel==leaf)=240;
   greenChannel(dilatedSkel==leaf)=255;
   blueChannel(dilatedSkel==leaf)=240;
   DRGB=cat(3,redChannel,greenChannel,blueChannel);
%    82,139,139   240,255,240 255-105-180
   redChannel(dilatedSkel1==0.5)=255;
   greenChannel(dilatedSkel1==0.5)=105;
   blueChannel(dilatedSkel1==0.5)=180;
   DRGB=cat(3,redChannel,greenChannel,blueChannel);
   h=figure;
   imshow(DRGB);

   hold
   visulisePointLabel(DRGB,graph,cutArray,'y');
   visulisePointLabel(DRGB,graph,crossingPoint,'m');
   saveas(h,strcat(folderPath,'\','DRGBLikli'),'png');
   hold off
   
