function [diroutlist,scaling]=stereoreconstruction(caldata,planarjob,rectype)
%This function does both Soloff and Willert Reconstructions
%
%Inputs:-
%caldata=calibration job structure
%planarjob=prana 2d job structure
%rectype{1}='Willert'; rectype{2}='Soloff'
%diroutlist=output directorylist where all the processings and different
%vector fields are stored.
%scaling=magnifications for soloff and willert based on dewarped grid
%
%
%set pulsesep in prana laser pulse separation box in Prana while setting the 2D job
%
%

%     This file is part of prana, an open-source GUI-driven program for
%     calculating velocity fields using PIV or PTV.
%
%     Copyright (C) 2014  Virginia Polytechnic Institute and State
%     University
% 
%     Copyright 2014.  Los Alamos National Security, LLC. This material was
%     produced under U.S. Government contract DE-AC52-06NA25396 for Los 
%     Alamos National Laboratory (LANL), which is operated by Los Alamos 
%     National Security, LLC for the U.S. Department of Energy. The U.S. 
%     Government has rights to use, reproduce, and distribute this software.
%     NEITHER THE GOVERNMENT NOR LOS ALAMOS NATIONAL SECURITY, LLC MAKES ANY
%     WARRANTY, EXPRESS OR IMPLIED, OR ASSUMES ANY LIABILITY FOR THE USE OF
%     THIS SOFTWARE.  If software is modified to produce derivative works,
%     such modified software should be clearly marked, so as not to confuse
%     it with the version available from LANL.
%
%     prana is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.

pulsesep=str2double(planarjob.wrsep)*(1e-6);
planarjob.wrsep = '1';
% If you are going to set the pulse separation to 1 to get things in pixel
% units you should also change the magnificaiton to sure that things come
% out correctly.
planarjob.wrmag = '1';

% pulsesep
% planarjob.wrsep

% Loop throught the different reconstruction types that need to be
% performed.  This now allows for rectype to be less then 2 as well as the
% first choice can be 'Soloff'.  A pervious version of the code crashed
% under these two conditions.
for j = 1:length(rectype)
    %Planar Field Calculation
    if strcmp(rectype{j},'Willert')
        fprintf('Processing for Geometric Reconstruction... \n');
        %Dewarp the camera images
        [dewarpdirlist,dewarp_grid,wil_scaling]=imagedewarp(caldata,'Willert',planarjob);
%         [Xg,Yg] = meshgrid(-34:.45:20,-27:.45:27);
%         [dewarpdirlist,dewarp_grid,wil_scaling]=imagedewarp_predefined_grid(caldata,'Willert',planarjob,[],Xg,Yg,8);
        diroutlist.dewarpdirlist=dewarpdirlist;
        %2D processing for camera1
        job1=planarjob;
        job1.imdirec=dewarpdirlist.dewarpdir1;
        job1.imbase=planarjob.imbase;
        job1.imdirec2=dewarpdirlist.dewarpdir1;
        job1.imbase2=planarjob.imbase;
        % By creating a variable "cam1dir" I know only have to update one
        % location if I want to change the form of this directory.  The
        % previous way it was written I would have to update multiple locations
        % increasing the chance I would miss one of them.
        cam1dir = fullfile(job1.outdirec,rectype{j},['Camera',num2str(caldata.camnumber(1)),filesep]);
        if ~exist(cam1dir,'dir');
            mkdir(cam1dir);
        end
        
        job1.outdirec=cam1dir;
        diroutlist.willert2dcam1=job1.outdirec;
        fprintf(['\nProcessing Planar Fields for Camera:',num2str(caldata.camnumber(1)),'\n']);
        pranaPIVcode(job1);
        clear job1;
        %2D processing for camera2
        job1=planarjob;
        job1.imdirec=dewarpdirlist.dewarpdir2;
        job1.imbase=planarjob.imbase2;
        job1.imdirec2=dewarpdirlist.dewarpdir2;
        job1.imbase2=planarjob.imbase2;
        
        cam2dir = fullfile(job1.outdirec,rectype{j},['Camera',num2str(caldata.camnumber(2)),filesep]);
        if ~exist(cam2dir,'dir')
            mkdir(cam2dir);
        end
        
        job1.outdirec=cam2dir;
        diroutlist.willert2dcam2=job1.outdirec;
        fprintf(['\nProcessing Planar Fields for Camera:',num2str(caldata.camnumber(2)),'\n']);
        pranaPIVcode(job1);
        clear job1;
        
        stereodir = fullfile(planarjob.outdirec,rectype{j},['Camera',num2str(caldata.camnumber(1)),'Camera',num2str(caldata.camnumber(2)),'_3Cfields',filesep]); 
        if ~exist(stereodir,'dir')
            mkdir(stereodir);
        end
        diroutlist.willert3cfields=fullfile(planarjob.outdirec,rectype{j},['Camera',num2str(caldata.camnumber(1)),'Camera',num2str(caldata.camnumber(2)),'_3Cfields',filesep]);
        
        %stereo reconstruction
        fprintf('\n Doing Geometric Stereo Reconstructions.... \n')
        willert_vec_reconstruct(diroutlist,caldata,dewarp_grid,wil_scaling,pulsesep);
        scaling.wil=wil_scaling;
        %keyboard;
        
        
    elseif strcmp(rectype{j},'Soloff')
        fprintf('Processing for Genaralized Reconstruction... \n');
        %2D processing for camera1
        job1=planarjob;
        job1.imdirec=planarjob.imdirec;
        job1.imbase=planarjob.imbase;
        job1.imdirec2=planarjob.imdirec;
        job1.imbase2=planarjob.imbase;
        
        if ~exist(fullfile(job1.outdirec,rectype{j},['Camera',num2str(caldata.camnumber(1)),filesep]),'dir')
            mkdir(fullfile(job1.outdirec,rectype{j},['Camera',num2str(caldata.camnumber(1)),filesep]));
        end
        
        job1.outdirec=fullfile(job1.outdirec,rectype{j},['Camera',num2str(caldata.camnumber(1)),filesep]);
        diroutlist.soloff2dcam1=job1.outdirec;
        fprintf(['\nProcessing Planar Fields for Camera:',num2str(caldata.camnumber(1)),'\n']);
        pranaPIVcode(job1);
        
        clear job1;
        %2D processing for camera2
        job1=planarjob;
        job1.imdirec=planarjob.imdirec2;
        job1.imbase=planarjob.imbase2;
        job1.imdirec2=planarjob.imdirec2;
        job1.imbase2=planarjob.imbase2;
        
        mkdir(fullfile(job1.outdirec,rectype{j},['Camera',num2str(caldata.camnumber(2)),filesep]));
        job1.outdirec=fullfile(job1.outdirec,rectype{j},['Camera',num2str(caldata.camnumber(2)),filesep]);
        diroutlist.soloff2dcam2=job1.outdirec;
        fprintf(['\nProcessing Planar Fields for Camera:',num2str(caldata.camnumber(2)),'\n']);
        pranaPIVcode(job1);
        
        mkdir(fullfile(planarjob.outdirec,rectype{j},['Camera',num2str(caldata.camnumber(1)),'Camera',num2str(caldata.camnumber(2)),'_3Cfields',filesep]));
        diroutlist.soloff3cfields=fullfile(planarjob.outdirec,rectype{j},['Camera',num2str(caldata.camnumber(1)),'Camera',num2str(caldata.camnumber(2)),'_3Cfields',filesep]);
        
        %stereo reconstruction
        fprintf('\n Doing Generalized Stereo Reconstructions.... \n')
        [sol_scaling]=soloff_vec_reconstruction(diroutlist,caldata,pulsesep);
        scaling.sol=sol_scaling;
        
    end
    
    
    
end
