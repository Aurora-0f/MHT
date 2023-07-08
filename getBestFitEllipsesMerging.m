function [EL,area,TotalPerf] = getBestFitEllipsesMerging(I,EL,NUMEllipses,area)
p = [];
for k=1:NUMEllipses,
    [EL,~,p1] = getBestFitEllipse(I,EL,k);
    p = union(p,p1);
end
TotalPerf = size(p,1)/area;
