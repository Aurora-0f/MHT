tic
Seg_L=imread('L.png');
Seg_M=imread('M.png');
Seg_H=imread('H.png');
GT=imread('gt.png');

% Seg=(Seg_L+Seg_M+Seg_H)/3;

% [ GT ] = correctGT( GT);

labelL=bwlabel(Seg_L,4);
numObjectsL = max(labelL(:));
for i = 1 : numObjectsL
    objectL = labelL == i;
    L_edge{i} = bwboundaries(objectL);
%     figure;imshow(L_edge{i},[]);
end

labelM=bwlabel(Seg_M,4);
numObjectsM = max(labelM(:));
for i = 1 : numObjectsM
    objectM = labelM == i;
    M_edge{i} = bwboundaries(objectM);
%     figure;imshow(L_edge,[]);
end

labelH=bwlabel(Seg_H,4);
numObjectsH = max(labelH(:));
for i = 1 : numObjectsH
    objectH = labelH == i;
    H_edge{i} = bwboundaries(objectH);
%     figure;imshow(L_edge,[]);
end

num = min(min(numObjectsL,numObjectsM),numObjectsH);
for i= 1 : num
    edge{i} = (L_edge{i}{1,1}+M_edge{i}{1,1}+H_edge{i}{1,1})./3;
end
Seg = edge;

% CC_Seg_L=bwconncomp(Seg_L,4);
% S_Seg_L=regionprops(CC_Seg_L,Seg_L,'Centroid','PixelIdxList','BoundingBox');
% 
% CC_Seg_M=bwconncomp(Seg_M,4);
% S_Seg_M=regionprops(CC_Seg_M,Seg_M,'Centroid','PixelIdxList','BoundingBox');
% 
% CC_Seg_H=bwconncomp(Seg_H,4);
% S_Seg_H=regionprops(CC_Seg_H,Seg_H,'Centroid','PixelIdxList','BoundingBox');
% 
% k1=length(S_Seg_L);
% k2=length(S_Seg_M);
% k3=length(S_Seg_H);
% k=min(k1,k3);
% 
% [r,c]=size(Seg_L);
% I=zeros(r,c);
% 
% I1 = seg_ave(k,S_Seg_H,S_Seg_L,Seg_L,I);
% CC_Seg_I1=bwconncomp(I1,4);
% S_Seg_I1=regionprops(CC_Seg_I1,Seg_I1,'Centroid','PixelIdxList','BoundingBox');
% k_I1=length(S_Seg_I1);
% k=min(k2,k_I1);
% I_new = seg_ave(k,S_Seg_M,S_Seg_I1,I1,I);

% Seg=I_new;

LSeg=255*Seg;
[Jaccard, MAD, Hausdorff, DiceFP,DiceFN,FP,FN,LGT] =getStats(GT,Seg,LSeg);
toc
