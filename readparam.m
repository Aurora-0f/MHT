function Paramethod = readparam(varargin);
%          - radii     radial range
%         - alpha      radial stricness
%         - stdFactor  Gradient threshold
%         - mode       three different modes are available: 
%                               'bright', 'dark', 'both'
%         - t          number of erosion operations
%         - se        type of structuring element
%         - thr       thershold for duplicate seedpoints removal
%         -lambda     [0:1], divergence weight factor
%         - vis1       0 or 1, to visualize the seedpoint extraction step
%                       step
%         - vis2       0 or 1, to visualize the contour evidenc extraction
%                       step
%         - vis3      0 or 1, to visualize the contour estimation
%                       step


 Paramethod = struct( 'radii',[18:22],... %[11:17] radial range
                'alpha',1,...                 radial stricness
                'stdFactor',0.5,...           Gradient threshold
                'mode','bright',...
                'thr',23,...
                'lambda',0.2,...
                't',2,...
                'se','disk',...
                'r',100,...
                'vis1',1,...
                'vis2',1,...
                'vis3',1);   

 

