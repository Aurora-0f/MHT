function [A] = HTT(I)
%I=imread('D:\ellipse detection\code\cell segmentation\MHT\Dataset_NIH3T3\test.png');
% figure,imshow(I);
% I1=rgb2gray(I);
% figure;
% imshow(I1);
[m,n]=size(I); 
%%% Low
I1=I;
% I1=imgaussfilt(I1,sqrt(2)/2);                         
GK1=zeros(1,256);%预创建存放灰度出现概率的向量
% imhist(I1);
for k=0:255
     GK1(k+1)=length(find(I1==k))/(m*n); 
end
% GK1=imgaussfilt(GK1,sqrt(2)/2);
x=0:255;
y=GK1;
yy=y;
t1=find_maxd(GK1);
% A=im2bw(I,t1/255);
% figure,imshow(A);
% set(gca,'xtick',[]),set(gca,'ytick',[]);
% figure,plot(x,yy,'k','LineWidth',1.5);
% figure,plot(x,yy,'k','LineWidth',1.5),hold on,plot(t1-1,GK1(t1), '.', 'MarkerSize', 20,"Color",'r');
% xlabel('Piexl Gray Level'),ylabel('Frequency');
% % x=0:0:0;yy=0:0:0;set(gca,'xtick',x);set(gca,'ytick',yy);
% % set(gca,'xtick',[]),set(gca,'ytick',[]);
% figure,bar(0:255,GK1,'k');
% xlabel('Piexl Gray Level'),ylabel('Frequency');

%%% Medium
% I2=imgaussfilt(I1,2);
GK2=zeros(1,256);
for k=0:255
     GK2(k+1)=length(find(I1==k))/(m*n);   
end
% GK2=imgaussfilt(GK2,sqrt(2));
x2=0:255;
y2=GK2;
yy=y2;
t2=find_maxd(y2);
% figure,plot(x2,yy,'k','LineWidth',1.5);
% x2=0:0:0;yy=0:0:0;set(gca,'xtick',x2);set(gca,'ytick',yy); 
% figure,bar(0:255,GK2,'g'); 
% xlabel('Piexl Gray Level'),ylabel('Frequency');
% saveas(gcf,'aa/gs2.png');
% A2=im2bw(I,t2/255);  
% 
%%% High 
% I3=imgaussfilt(I1,sqrt(2)*2);
GK3=zeros(1,256);
for k=0:255
     GK3(k+1)=length(find(I1==k))/(m*n);   
end
% GK3=imgaussfilt(GK3,sqrt(2)*2);
x3=0:255;
y3=GK3;
yy=y3;
t3=find_maxd(y3);
% figure,plot(x3,yy,'k','LineWidth',1.5);
% x3=0:0:0;yy=0:0:0;set(gca,'xtick',x3);set(gca,'ytick',yy);                  
% xlabel('Piexl Gray Level'),ylabel('Frequency');
% saveas(gcf,'aa/gs3.png');
% % figure,bar(0:255,GK3,'g');                  
% % A3=im2bw(I,20/255);  


for k=0:255
    GK(k+1)=(GK1(k+1)+GK2(k+1)+GK3(k+1))/3;
end
x=0:255;
y=GK;
yy=y;
t=find_maxd(y);
% % figure,plot(x,yy,'k','LineWidth',1.5),hold on,plot(t1-1,GK1(t1), '.', 'MarkerSize', 20,"Color",'r');
% figure,plot(x,yy,'k','LineWidth',1.5);
% % x=0:0:0;yy=0:0:0;set(gca,'xtick',x);set(gca,'ytick',yy);                  
% xlabel('Piexl Gray Level'),ylabel('Frequency');
% saveas(gcf,'aa/gs-rh.png');

A=im2bw(I,t/255);



function [T]=find_maxd(GK)
mi = min(GK);
for k=0:255
    if GK(k+1)==mi
        id_mi=k+1;
    end
end
ma = max(GK);
for k=0:255
    if GK(k+1)==ma
        id_ma=k+1;
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
[maxd,T]=max(d);




