%Returns the equal area BestFitEllipse 
function [EL,area,p] = getBestFitEllipse(I,EL,val)
BW = I == val;
BW0 = I > 0;

lines = size(I,1);
cols = size(I,2);

[x y] = meshgrid(1:max(lines,cols),1:max(lines,cols));
X0 = EL(val).C(1);
Y0 = EL(val).C(2);
el=((x-X0)/EL(val).a).^2+((y-Y0)/EL(val).b).^2<=1;
el = rotateAround(el,Y0,X0,EL(val).phi,'nearest');
el = el(1:lines,1:cols);
el = min(el,BW0);
BW1 = max(BW,el);
stats = regionprops(double(BW1), 'Area','Centroid','MajorAxisLength','MinorAxisLength','Orientation');
if sum(sum(BW)) == 0,
    p = [];
    area = 0;
    return;
end
area = stats.Area;
C = stats.Centroid;
e =  stats.MajorAxisLength / stats.MinorAxisLength;
X0 = C(1);
Y0 = C(2);
phi = stats.Orientation;
a = sqrt(e*area/pi);
b = a/e;
el=((x-X0)/a).^2+((y-Y0)/b).^2<=1;
el = rotateAround(el,Y0,X0,phi,'nearest');
el = el(1:lines,1:cols);
p1 = [];
p2 = [];
[p1(:,1) p1(:,2)] = find(el == 1 & BW == 1);
[p2(:,1) ~] = find(el == 1 | BW == 1);

tomh_area = size(p1,1) / area;
tomh_enwsh = size(p1,1) / size(p2,1);

EL(val).a = a;
EL(val).b = b;
EL(val).C = C;
EL(val).phi = phi;
EL(val).InArea = size(p1,1);
EL(val).outPixels = size(p2,1) - size(p1,1);
EL(val).tomh_area = tomh_area;
EL(val).tomh_enwsh = tomh_enwsh;
EL(val).Label = val;
EL(val).ELLSET = EL(val).ELLSET;

p = p1(:,1)+lines*cols*p1(:,2);

