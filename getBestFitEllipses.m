function [EL,area,TotalPerf] = getBestFitEllipses(I,EL,NUMEllipses,area)
p = [];
s = 0;
for k=1:NUMEllipses,
    [EL,~,p1] = getBestFitEllipse(I,EL,k);
    p = union(p,p1);
end
TotalPerf = size(p,1)/area;
