function [ RGB ] = myImWriteOnRealImages(I,IClustTotal,LGT,ResultsDir,fname,toPlot )
S = regionprops(IClustTotal,'Centroid');
for i=1:length(S),
    CR(i,1:2) = [S(i).Centroid(1) S(i).Centroid(2)];
end

S = regionprops(LGT,'Centroid');
for i=1:length(S),
    CGT(i,1:2) = [S(i).Centroid(1) S(i).Centroid(2)];
end

lines = size(I,1);
cols = size(I,2);
[Gx, Gy] = imgradientxy(IClustTotal);
[Gmag, ~] = imgradient(Gx, Gy);
Gmag(Gmag >0) = 1;
se = strel('disk', 1);
Gmag = imdilate(Gmag,se);
RGB = uint8(zeros(lines,cols,3));
for i=1:lines,
    for j=1:cols,
        for k=1:3,
            RGB(i,j,k) = I(i,j);
        end
    end
end
I1 = zeros(lines,cols);
I2 = zeros(lines,cols);
se1 = strel('disk', 1);
se2 = strel('disk', 3);
try
    I1 = I1(:,:,1);
    I2 = insertMarker(I2,round(CGT),'+','color',[1 1 1],'size',14);
    I2 = I2(:,:,1);
    I1 = imdilate(I1,se2);
    I2 = imdilate(I2,se1);
catch ME
    
end

for i=1:lines,
    for j=1:cols,
        if I1(i,j) == 1,
            RGB(i,j,1:3) = [0 255 0];
        elseif I2(i,j) == 1,
            RGB(i,j,1:3) = [255 0 0];
        elseif Gmag(i,j) == 1,
            RGB(i,j,1:3) = [0 255 0];
        end
    end
end
imwrite(RGB,sprintf('%s%sGT.tiff',ResultsDir,fname),'tiff');

% figure;imshow(Gmag,[]);
% mkdir a
% imwrite(Gmag,'a/Gmag.png');

if toPlot == 1,
    [Gx, Gy] = imgradientxy(LGT); 
    [Gmag, ~] = imgradient(Gx, Gy); 
    Gmag(Gmag >0) = 1;     
    figure; imagesc(RGB); 
%      title('Segmentation+GT');
end



