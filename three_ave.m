tic
Seg_L=imread('aa\L.png');
Seg_M=imread('aa\M.png');
Seg_H=imread('aa\H.png');
GT=imread('aa\test-gt.png');

Seg=(Seg_L+Seg_M+Seg_H)/3;
figure;imshow(Seg);

% [ GT ] = correctGT( GT);
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

% figure;imshow(I_new,[]);

% Seg=I_new;

LSeg=255*Seg;
[Jaccard, MAD, Hausdorff, DiceFP,DiceFN,FP,FN,LGT] =getStats(GT,Seg,LSeg);
toc