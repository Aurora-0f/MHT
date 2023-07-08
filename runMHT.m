close all;
clear all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Method Selection
%Set METHOD = 0 to only test the Segmentation Stage, 
%Set METHOD = 1 to run DEFA method, 
%Set METHOD = 2 to run AEFA method, 
%else you run EMAR method  
%Set METHODSEG = 0  to run ICPR 2010 method
%Set METHODSEG = 1  to run OTSU method
%Set METHODSEG = 2 to run Adaptive Thresh method, Bradley¡¯s segmentation method
%Set METHODSEG = 3 to run Adaptive Thresh+extra method LADA+, 
%Set METHODSEG = 4 to run ICIP 2018 method [2],
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% SET PARAMETERS (selected for Dataset NIH3T3)
tic
METHOD = 1; 
METHODSEG = 4;
global Constraints
Constraints = [250 0.1 0.2]; 
%Constraints(1) = areaLim ( < 250)
%Constraints(2) = min area / max area ratio e.g. < 0.1 
%Constraints(3) = max overlaping > 0.2

AICBIC_SELECTION = 1; %Set AICBIC_SELECTION = 1, to use AIC is selected else BIC is used
set(0,'DefaultFigureColormap',jet);

DataDirD{1} = 'Dataset_NIH3T3//'; %NIH3T3 dataset
DataDirD{2} = 'Dataset_U20S//';  %U20S dataset

filesD{1} = ['dna-0-0 dna-1-0 dna-10-0 dna-11-0 dna-12-0 dna-13-0 dna-14-0 dna-15-0 dna-16-0 dna-17-0 dna-18-0 dna-19-0 dna-2-0 dna-20-0 dna-21-0 dna-22-0 dna-23-0 dna-24-0 dna-26-0 dna-27-0 dna-28-0 dna-29-0 dna-3-0 dna-30-0 dna-31-0 dna-32-0 dna-33-0 dna-34-0 dna-35-0 dna-36-0 dna-37-0 dna-38-0 dna-39-0 dna-4-0 dna-40-0 dna-41-0 dna-42-0 dna-43-0 dna-44-0 dna-45-0 dna-46-0 dna-47-0 dna-48-0 dna-49-0 dna-5-0 dna-6-0 dna-7-0 dna-8-0 dna-9-0 '];
filesD{2} = ['dna-0-0 dna-1-0 dna-10-0 dna-11-0 dna-12-0 dna-13-0 dna-14-0 dna-15-0 dna-16-0 dna-17-0 dna-18-0 dna-19-0 dna-2-0 dna-20-0 dna-21-0 dna-22-0 dna-23-0 dna-24-0 dna-25-0 dna-26-0 dna-27-0 dna-28-0 dna-29-0 dna-3-0 dna-30-0 dna-32-0 dna-33-0 dna-34-0 dna-35-0 dna-36-0 dna-37-0 dna-38-0 dna-39-0 dna-4-0 dna-40-0 dna-41-0 dna-42-0 dna-44-0 dna-45-0 dna-46-0 dna-47-0 dna-48-0 dna-49-0 dna-5-0 dna-6-0 dna-7-0 dna-8-0 dna-9-0 '];

DATASET = 1;
ResultsDirD{1} = 'RES_NIH3T3//';
ResultsDirD{2} = 'RES_U20S//';
DataDir = DataDirD{DATASET};
ResultsDir = ResultsDirD{DATASET};

RUN_EXAMPLE = 1;%Run a specific example from dataset NIH3T3
if DATASET == 1 
    NeighborhoodSize = 101;
else
    NeighborhoodSize = 151;
end
if RUN_EXAMPLE == 1
    fname = 'test';
    fnameGT = 'test-gt';
    [I] = imread(sprintf('%s%s.png',DataDir,fname));
    GT = imread(sprintf('%s%s.png',DataDir,fnameGT));
    [ GT ] = correctGT( GT);
    [IClustTotal,totEll,INITSEG] = runMainAlgo(imgaussfilt(I,2),AICBIC_SELECTION,METHOD,METHODSEG,NeighborhoodSize,0.5,0);
    %Statistics of segmentation 
   [REC, PR, F1, Overlap,BP,BDE,RECL,PRL,F1L,LGT] = getInitSegmentationStats(GT,INITSEG,IClustTotal);
   [Jaccard, MAD, Hausdorff, DiceFP,DiceFN,FP,FN,LGT] =getStats(GT,INITSEG,IClustTotal);
    %save result image 
    myImWriteOnRealImages(I,IClustTotal,LGT,ResultsDir,fname,1 );
    return;
end
toc