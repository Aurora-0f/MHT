function [A] = HTT1(I)
[m,n]=size(I);                            
GK=zeros(1,256);                           
for k=0:255
     GK(k+1)=length(find(I==k))/(m*n);    
end

mi = min(GK);
for k=0:255
    if GK(k+1)==mi
        id_mi=k;
    end
end

ma = max(GK);
for k=0:255
    if GK(k+1)==ma
        id_ma=k;
    end
end

x1=id_mi;y1=mi;
x2=id_ma;y2=ma;
a=y2-y1;
b=x1-x2;
c=y1*x2-x1*y2;
% plot(x1,y1,'*r',x2,y2,'*g');
% line([x1,x2],[y1,y2]);
for i=id_ma:255
    t1=a*i+b*GK(i)+c;
    t2=sqrt(a^2+b^2);
    d(i)=abs(t1/t2);
end
[i_d,max_d]=max(d);
A=im2bw(I,max_d/255);
% A=im2bw(I,16/255);

  
% figure,imshow(A);


