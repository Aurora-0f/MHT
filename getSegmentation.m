function [ A,L] = getSegmentation( I,method,NeighborhoodSize)
toPlot = 0;
level = graythresh(I); 
lines = size(I,1);
cols = size(I,2)
im=I;
if method == -1,
   A = I;
   CC = bwconncomp(A, 8);
   L = labelmatrix(CC);
   return;
end

if method == 0,
    [A,L] = getLymphocyteSegmentation(I);
    return;
end

if method == 1, 
    A = imbinarize(I,level);
elseif method >= 2, 
     A = HTT(im);
end

if method == 5,
   A = imbinarize(I,100);
end

CC = bwconncomp(A, 8); 
S = regionprops(CC,I, 'Area','Perimeter','MaxIntensity','Extrema');
L = labelmatrix(CC); 

[hasBorder] = getBorders(L,S,lines,cols);
TreshP = getAreaThreshold(hasBorder,S,250);% Area constraint£¬T¦Á

R = zeros(1,length(S));
M = mean(I(:));
MeanRatio = R;

for i=1:length(S),
    Area = S(i).Area;
    Perimeter = S(i).Perimeter;
    R(i) = (4*Area*pi)/(Perimeter^2); % Roundness constraint£¬R>0.2
    MeanRatio(i) = S(i).MaxIntensity/M; % Intensity constraint
end

TreshR = 0.2;

if method <= 2,
    A = ismember(L, find([S.Area] >= TreshP));
elseif method == 3
    A = ismember(L, find([S.Area] >= TreshP & R > TreshR));
elseif method == 4, 
    A = ismember(L, find([S.Area] >= TreshP & R > TreshR));
    A = removeLowIntensityRegion(double(I),A);
end

A = imfill(A,'holes');
CC = bwconncomp(A, 8);
L = labelmatrix(CC); 
if toPlot ==1,
    figure;
    imagesc(I);
    title('Original Image');
    
    figure;
    imagesc(A);
    title('After Denosing');
end


function [A] = removeLowIntensityRegion(I,A)
CC = bwconncomp(A, 8);
S = regionprops(CC,I,'Centroid', 'PixelValues');
L = labelmatrix(CC);
centroids = cat(1, S.Centroid);
mask = voronoi2mask(centroids(:,1),centroids(:,2),size(A)); % Voronoi diagram

% figure;%imshow(mask,[]);
% imshow(mask,[],'border','tight');
% colormap jet;
% figure;imagesc(mask);


mask(A == 1) = 0;
vals0 = I(A == 0);
vals1 = I(A == 1);
m00 = mean(vals0); 
v00 = var(vals0);
m1 = median(vals1);
v1 = max(1,var(vals1));
for i=1:length(S),
    m = mean((S(i).PixelValues));
    v = max(1,var((S(i).PixelValues)));
    vals0 = double(I(mask == i));
    m0 = mean(vals0);
    v0 = var(vals0);
    v0 = max(v0,1);
    d0 = getBhattacharyyaDist(m,v,m0,v0); 
    d1 = getBhattacharyyaDist(m,v,m1,v1);
    if d0 < d1 ,
        A(L == i) = 0;
    end
end

function [d] = getBhattacharyyaDist(m0,var0,m1,var1) % Bhattacharyya distance

d1 = 2+((var0/var1))+((var1/var0));
d2 = (m1-m0)^2 / (var0+var1);
d = 0.25*log(0.25*d1)+0.25*d2;

function [TreshP] = getAreaThreshold(hasBorder,S,initVal)
TreshP = initVal*ones(1,length(S));

for i=1:length(S),
    if hasBorder(i) > 5, 
        x = S(i).Extrema(:,1);
        y = S(i).Extrema(:,2);
        [~,~,R,~] = circfit(x,y);
        logos = S(i).Area/(pi*R^2);
        TreshP(i) = min(initVal,TreshP(i)*logos);
    end
end


function [hasBorder] = getBorders(L,S,lines,cols)

hasBorder = zeros(1,length(S));
for i=1:cols, 
    c = L(1,i);
    if c > 0
        hasBorder(c) = hasBorder(c)+1;
    end
end
for i=1:lines,
    c = L(i,cols);
    if c > 0
        hasBorder(c) = hasBorder(c)+1;
    end
end
for i=1:lines, 
    c = L(i,1);
    if c > 0
        hasBorder(c) = hasBorder(c)+1;
    end
end
for i=1:cols,
    c = L(lines,i);
    if c > 0
        hasBorder(c) = hasBorder(c)+1;
    end
end



