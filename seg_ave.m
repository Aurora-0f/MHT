function [I] = seg_ave(k,S_Seg_1,S_Seg_2,Seg,I)
for id=1:k
    dx=S_Seg_1(id).Centroid(1)-S_Seg_2(id).Centroid(1);
    dy=S_Seg_1(id).Centroid(2)-S_Seg_2(id).Centroid(2);
    yy=round(S_Seg_2(id).BoundingBox(1,1));
    xx=round(S_Seg_2(id).BoundingBox(1,2));
    width=round(S_Seg_2(id).BoundingBox(1,3));
    height=round(S_Seg_2(id).BoundingBox(1,4));
    len=length(S_Seg_2(id).PixelIdxList);
    w=yy+width-1;
    h=xx+height-1;
    for t=1:len
        for i=xx:h
            for j=yy:w
                if  Seg(i,j)==1
                    x=ceil(abs(i-dx));
                    y=ceil(abs(j-dy));
                    I(x,y)=1;
                end
            end
        end 
    end  
%     figure;imshow(I,[]);
end