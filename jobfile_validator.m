function [Data] = jobfile_validator(Data)
%Attempt to make backwards-compatible with older

%     This file is part of prana, an open-source GUI-driven program for
%     calculating velocity fields using PIV or PTV.
%
%     Copyright (C) 2012  Virginia Polytechnic Institute and State
%     University
% 
%     Copyright 2014-2015.  Los Alamos National Security, LLC. This material was
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


%is the version variable present in the job file.
if ~isfield(Data,'version')
    if ~isfield(Data,'par')
        Data.par='0';
        Data.parprocessors='1';
        Data.version='1.5';
    else
        handles.data.version='1.9';
    end
end
if ~isfield(Data,'exp_date')
    Data.exp_date = '';
end
if ~isfield(Data,'exp_wavelength')
    Data.exp_wavelength = '';
end
if ~isfield(Data,'exp_pixelsize')
    Data.exp_pixelsize = '';
end
if ~isfield(Data,'exp_lensfocal')
    Data.exp_lensfocal = '';
end
if ~isfield(Data,'exp_micro')
    Data.exp_micro = '0';
end
if ~isfield(Data,'exp_lensfnum')
    Data.exp_lensfnum = '0';
end
if ~isfield(Data,'exp_partD')
    Data.exp_partD = '';
end
if ~isfield(Data,'exp_partdensity')
    Data.exp_partdensity = '';
end
if ~isfield(Data,'exp_density')
    Data.exp_density = '';
end
if ~isfield(Data,'exp_viscosity')
    Data.exp_viscosity = '';
end
if ~isfield(Data,'exp_surfacetension')
    Data.exp_surfacetension = '';
end
if ~isfield(Data,'exp_L')
    Data.exp_L = '';
end
if ~isfield(Data,'exp_v0')
    Data.exp_v0 = '';
end
if ~isfield(Data,'exp_Re')
    Data.exp_Re = '';
end
if ~isfield(Data,'exp_St')
    Data.exp_St = '';
end
if ~isfield(Data,'exp_M')
    Data.exp_M = '';
end
if ~isfield(Data,'exp_ROI')
    Data.exp_ROI = '';
end
if ~isfield(Data,'exp_diffractiondiameter')
    Data.exp_diffractiondiameter = '';
end
if ~isfield(Data,'exp_depthoffocus')
    Data.exp_depthoffocus = '';
end
if ~isfield(Data,'exp_notes')
    Data.exp_notes = '';
end
% if ~isfield(Data,'selfcal')
%     Data.selfcal = 0;
% end

% If PIV0 doesn't exist, create it.
if ~isfield(Data,'PIV0')
    Data.PIV0 = Data.PIV1;
end

%does the job file have information about the second image directory
if ~isfield(Data,'imdirec2')
    Data.imdirec2 = Data.imdirec;
    Data.imbase2 = Data.imbase;
end
%does the job file know whether whether it should ignore the second camera directory?
if ~isfield(Data,'numcams')
    Data.numcams = '1';
end


%does the job file have the zero mean option
if ~isfield(Data.PIV0,'zeromean')
    for pass=0:str2double(Data.passes)
        eval(['Data.PIV',num2str(pass),'.zeromean=''0'';']);
        eval(['Data.PIV',num2str(pass),'.peaklocator=''1'';']);
    end
end
%does the job file have infromation about the color channels
if ~isfield(Data,'channel')
    Data.channel = '1';
end
%does the job file have a variable for window overlap
if ~isfield(Data.PIV0,'winoverlap')
    for pass=0:str2double(Data.passes)
        eval(['Data.PIV',num2str(pass),'.winoverlap=''1'';']);
    end
end
%does the job file have a variable for fractionally weighted correlations
if ~isfield(Data.PIV0,'frac_filt')
    for pass=0:str2double(Data.passes)
        eval(['Data.PIV',num2str(pass),'.frac_filt=''1'';']);
        %SPC has been moved to '5' so check to see if SPC was used and
        %reset it to '5'.
        if str2double(eval(['Data.PIV' num2str(pass) '.corr'])) == 3
            eval(['Data.PIV',num2str(pass),'.corr=''5'';']);
        end
    end
end
%does the job file have infromation about interative window deformation
if ~isfield(Data.PIV0,'deform_min')
    for pass=0:str2double(Data.passes)
        eval(['Data.PIV',num2str(pass),'.deform_min=''1'';']);
        eval(['Data.PIV',num2str(pass),'.deform_max=''1'';']);
        eval(['Data.PIV',num2str(pass),'.deform_conv=''0.1'';']);
    end
end
if ~isfield(Data,'runPIV')
    Data.runPIV = '1';
end
%does the job file have the ability to save correlation planes
if ~isfield(Data.PIV0,'saveplane')
    for pass=0:str2double(Data.passes)
        eval(['Data.PIV',num2str(pass),'.saveplane=''0'';']);
    end
end

%does the job file have the ability to validate based on correlation peaks
if ~isfield(Data.PIV0,'uncertaintyestimate')
    for pass=0:str2double(Data.passes)
        eval(['Data.PIV',num2str(pass),'.uncertaintyestimate=''0'';']);
        eval(['Data.PIV',num2str(pass),'.ppruncertainty=''0'';']);
        eval(['Data.PIV',num2str(pass),'.miuncertainty=''0'';']);
        eval(['Data.PIV',num2str(pass),'.imuncertainty=''0'';']);
        eval(['Data.PIV',num2str(pass),'.mcuncertainty=''0'';']);
        
    end
end

%does the job file have the ability to estimate uncertainty
if ~isfield(Data.PIV0,'corrpeaktest')
    for pass=0:str2double(Data.passes)
        eval(['Data.PIV',num2str(pass),'.corrpeaktest=''0'';']);
        eval(['Data.PIV',num2str(pass),'.corrpeak_absthresh=''0'';']);
        eval(['Data.PIV',num2str(pass),'.corrpeak_ratiothresh=''1.2'';']);
    end
end

% This performs a check to see if the job files
% contains the field 'outputpassbase' if not then it
% used the output name from the final pass.
if ~isfield(Data,'outputpassbase')
    eval(['Data.outputpassbase = Data.PIV' Data.passes '.outbase;']);
end

%does the job file have infromation about input velocity fields
if ~isfield(Data,'input_vel_type')
    Data.input_vel_type = 'none';
end
if ~isfield(Data,'input_velocity')
    Data.input_velocity = '';
end
if ~isfield(Data,'input_veldirec')
    Data.input_veldirec = '';
end
if ~isfield(Data,'input_velbase')
    Data.input_veldirec = '';
end

% Check to see if the job file is using the old version of correlation
% names with numbers.  The code now uses string names which make it easier
% to add features in the future.
if length(Data.PIV0.corr) == 1
    for pass=0:str2double(Data.passes)
        eval(['ctype = str2double(Data.PIV',num2str(pass),'.corr);']);
        if ctype == 1;
            eval(['Data.PIV',num2str(pass),'.corr = ''SCC'';']);
        elseif ctype == 2;
            eval(['Data.PIV',num2str(pass),'.corr = ''RPC'';']);
        elseif ctype == 3;
            eval(['Data.PIV',num2str(pass),'.corr = ''GCC'';']);
        elseif ctype == 4;
            eval(['Data.PIV',num2str(pass),'.corr = ''FWC'';']);
        elseif ctype == 5;
            eval(['Data.PIV',num2str(pass),'.corr = ''SPC'';']);
        end
    end
end

% This changes the RPC diameter form a 1 dimensional variable to a 2D one.
% This will be used in the spectial energy filter for making 2D filters.
for pass=0:str2double(Data.passes)
    eval(['check = regexp(Data.PIV' num2str(pass) '.RPCd,''[,;]'');'])
    if isempty(check)
        eval(['Data.PIV' num2str(pass) '.RPCd = [num2str(Data.PIV' num2str(pass) '.RPCd) '','' num2str(Data.PIV' num2str(pass) '.RPCd)];'])
    end
end

%Do we want to save the dewarped images in a subfolder of the vector output
%directory named imDeform/?
%Currently, this switch is not accessible in the GUI
if ~isfield(Data,'SaveIMdeform')
    Data.SaveIMdeform = '0';
end



% --- Tacking Info ---
%does the job file have tracking infromation.
if ~isfield(Data,'ID')
    if ispc
%         Data.loaddirec=[pwd '\'];
        Data.ID.save_dir        = [pwd,'\ID\'];
        Data.Size.save_dir      = [pwd,'\Size\'];
        Data.Track.save_dir     = [pwd,'\Track\'];
        Data.Track.PIVprops.load_dir= [pwd,'\'];
    else
%         Data.loaddirec=[pwd '/'];
        Data.ID.save_dir        = [pwd,'/ID/'];
        Data.Size.save_dir      = [pwd,'/Size/'];
        Data.Track.save_dir     = [pwd,'/Track/'];
        Data.Track.PIVprops.load_dir= [pwd,'/'];
    end
end

if ~isfield(Data.ID,'runid')
    
    Data.runPIV = '1';
    
    Data.ID.runid        = '0';
    Data.ID.method       = '2';
    Data.ID.imthresh     = '10';
    Data.ID.savebase     = 'ID_';
    % Sizing Default values
    Data.Size.runsize    = '0';
    Data.Size.method     = 'GEO';
    Data.Size.std        = '4';
    Data.Size.savebase   = 'SIZE_';
    % Tracking Default values
    Data.Track.runtrack  = '0';
    Data.Track.method    = '1';
    Data.Track.prediction= '1';
    Data.Track.PIVweight = '0.5';
    Data.Track.radius    = '15';
    Data.Track.disweight = '1.0';
    Data.Track.sizeweight= '0.5';
    Data.Track.intensityweight = '0.5';
    Data.Track.estradius = '15';
    Data.Track.estweight = '.1';
    Data.Track.savebase  = 'Track_';
    Data.Track.trackdat  = '0';
    Data.Track.trackmat  = '1';
    Data.Track.vectors   = '3';
    Data.Track.iterations= '3';
    % Tracking Validation Values
    Data.Track.valprops.run   = '1';
    Data.Track.valprops.valcoef = '0,0,0.2';
    Data.Track.valprops.valrad = '20,20,0';
    Data.Track.valprops.MAD_U = '1,0.75,0';
    Data.Track.valprops.MAD_V = '1,0.75,0';
end

if ~isfield(Data.Size,'min_area')
    Data.Size.min_area = '0';
end
% Check to see if the job files have the new tracking output options.  If
% not add them to the jobfile setting *.mat as the output.
if ~isfield(Data.Track,'trackdat')
    Data.Track.trackdat  = '0';
    Data.Track.trackmat  = '1';
end

% Check to see if an old job with numerical sizing methods was loaded and
% switch the number to a string.
if ~isnan(str2double(Data.Size.method))
    size_str = {'IWC','TPG','FTG','CFPG','LSG','CLSG'};
    Data.Size.method = size_str{str2double(Data.Size.method)};
end

ver = pranaPIVcode('version');
Data.version = ver;
ver = pranaPTVcode('version');
Data.ptv_version = ver;
% This checks to see if the variables 'winres1' and winres2' exist and if
% so remove them.  The code now will just parse the winres string limiting
% the number of places this data is stored.
if isfield(Data.PIV0,'winres1')
    for i = 0:str2double(Data.passes)
        eval(['Data.PIV' num2str(i) '.winres= sprintf(''%s;%s'',Data.PIV' num2str(i) '.winres1,Data.PIV' num2str(i) '.winres2);'])
        eval(['Data.PIV' num2str(i) '=rmfield(Data.PIV' num2str(i) ',''winres1'');'])
        eval(['Data.PIV' num2str(i) '=rmfield(Data.PIV' num2str(i) ',''winres2'');'])
    end
end
