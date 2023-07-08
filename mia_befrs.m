function seedpoints = mia_befrs(I,radii, alpha, stdFactor, mode,t,se,thr,vis)
% mia_befrs find the location of nanoparticles as seed points (center of symmetry) . 

%   Synopsis
        %       seedpoints = mia_befrs(I,radii, alpha, stdFactor, mode,t,se,thr,vis)
%   Description
                %  1. First, a predefined number of erosions is applied
                %  primarily to  extract the separable seed regions by erosion
                 
                %  2. Next FRS along with duplicate seed point removal produces the
                %      final seed point results  

%   Inputs 
        %         - I      grayscale image
        %         - radii      radial range
        %         - alpha      radial stricness
        %         - stdFactor  gradient threshold
        %         - mode       three different modes are available: 
        %                      'bright', 'dark', 'both'
        %         - t          number of erosion operations
        %         - se         type of structuring element
        %         - thr        thershold for removing duplicated seedpoints  
        %         - vis       0 or 1, to visualize the seedpoint extraction 
                   

%   Outputs
%                   - seedpoint     struct contating the location of each  
%                                   seedpoint.  
%         
%   Authors
%          Sahar Zafari <sahar.zafari(at)lut(dot)fi>

%   Changes
%       14/01/2016  First Edition

    % set up FRS meta parameters
    se = strel(se,1);
    % Bound Erosion
    for i= 1:t
        I = imerode(I,se);
    end
    %  Seedpoint Exctraction by Fast Radial Symmetry  
    [seedpoints]= mia_cmpseedpoints_frst(I, radii, alpha, stdFactor, mode);
       
    for i=1:length(seedpoints)
        xymc(i,:) = [seedpoints(i).xmc;seedpoints(i).ymc];
    end

       markeridx = 1:size(xymc,1);
       j = 0;
       while ~isempty(markeridx);
         j = j + 1;
         i = markeridx(1);
         d = pdist2(xymc(i,:),xymc(markeridx,:));
         markermerg(j).xmc = mean(xymc(markeridx(d<thr),1));
         markermerg(j).ymc = mean(xymc(markeridx(d<thr),2));
         markeridx(d<thr) = [];
       end
       seedpoints = markermerg;
       
   if vis==1
       figure();imshow(I);hold on
%        mkdir x
%        imwrite(I,'x/SCA2.png')
       for i=1:length(seedpoints)
        %disp(seedpoints(i).xmc);
        %disp(seedpoints(i).ymc);
        %disp('----');
        plot(seedpoints(i).xmc,seedpoints(i).ymc,'sr'); hold on
       end
       title('Detected Seedpoints')
       fprintf('press any key to continue to start contour evidence extraction...\n')
       pause;
   end
end   
 
   

