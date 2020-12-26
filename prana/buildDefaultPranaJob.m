function [defaultdata] = buildDefaultPranaJob()

%     This file is part of prana, an open-source GUI-driven program for
%     calculating velocity fields using PIV or PTV.
%
%     Copyright (C) 2012-2013  Virginia Polytechnic Institute and State
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

defaultdata.clientversion='2.6.0';
%defaultdata.version='2.0'; %gets set below in call to pranaPIVcode('version')
if ispc
    defaultdata.imdirec='C:\';
    defaultdata.imdirec2='C:\';
    defaultdata.outdirec='C:\';
    defaultdata.maskdirec='C:\';
else
    defaultdata.imdirec='/';
    defaultdata.imdirec2='/';
    defaultdata.outdirec='/';
    defaultdata.maskdirec='/';
end

defaultdata.numcams='1';

defaultdata.imbase='Img_';
defaultdata.imbase2='Img_';
defaultdata.imzeros='6';
defaultdata.imext='tif';
defaultdata.imcstep='1';
defaultdata.imfstep='1';
defaultdata.imfstart='1';
defaultdata.imfend='1';

defaultdata.wrmag='1';
defaultdata.wrsamp='1';
defaultdata.wrsep='1';
defaultdata.batchname='Proc1';
defaultdata.datout='0';
defaultdata.multiplematout='1';

defaultdata.exp_date='';
defaultdata.exp_L='';
defaultdata.exp_v0='';
defaultdata.exp_notes={'Camera Description:' '' 'Lens Description:' '' 'Notes:' ''};
defaultdata.exp_density='1000';
defaultdata.exp_viscosity='1.308e-3';
defaultdata.exp_surfacetension='0.07197';
defaultdata.exp_partD='';
defaultdata.exp_partdensity='';
defaultdata.exp_wavelength='.532';
defaultdata.exp_pixelsize='';
defaultdata.exp_lensfocal='';
defaultdata.exp_lensfnum='';
defaultdata.exp_micro='0';
defaultdata.exp_NA='';
defaultdata.exp_n='';
defaultdata.exp_Re='';
defaultdata.exp_St='';
defaultdata.exp_M='';
defaultdata.exp_ROI='';
defaultdata.exp_diffractiondiameter='';
defaultdata.exp_depthoffocus='';

defaultdata.input_vel_type = 'none';
defaultdata.input_velocity = '';
defaultdata.input_veldirec = '';
defaultdata.input_velbase  = '';

defaultdata.masktype='none';
defaultdata.staticmaskname='';
defaultdata.maskbase='maskfor_Img_';
defaultdata.maskzeros='6';
defaultdata.maskext='tif';
defaultdata.maskfstep='1';
defaultdata.maskfstart='1';

defaultdata.runPIV='1';

defaultdata.PIV0.winres='32,32; 32,32';
%     defaultdata.PIV0.winres1='32,32';
%     defaultdata.PIV0.winres2='32,32';
defaultdata.PIV0.winsize='64,64';
defaultdata.PIV0.winauto='1';
defaultdata.PIV0.gridres='8,8';
defaultdata.PIV0.winoverlap='75,75';
defaultdata.PIV0.gridtype='1';
defaultdata.PIV0.gridbuf='8,8';
defaultdata.PIV0.BWO='0,0';
defaultdata.PIV0.corr='RPC';
defaultdata.PIV0.RPCd='2.8,2.8';
defaultdata.PIV0.frac_filt='1';
defaultdata.PIV0.zeromean='1';
defaultdata.PIV0.peaklocator='1';
defaultdata.PIV0.velsmooth='0';
defaultdata.PIV0.velsmoothfilt='2';
defaultdata.PIV0.deform_min ='1';
defaultdata.PIV0.deform_max ='1';
defaultdata.PIV0.deform_conv ='0.1';
defaultdata.PIV0.val='0';           %turn on the validation postprocessing
defaultdata.PIV0.uod='1';           %apply UOD and replacement
defaultdata.PIV0.bootstrap='0';     %apply bootstrapping outlier detection and replacement
defaultdata.PIV0.thresh='0';        %check whether the velocity is greater than some pixel thresh
defaultdata.PIV0.corrpeaktest='0';  %check whether the correlation peak is less (abs or rel) than some thresh
defaultdata.PIV0.uod_type='2';
defaultdata.PIV0.uod_window='3,3;3,3';
defaultdata.PIV0.uod_thresh='3,2';
defaultdata.PIV0.bootstrap_percentsampled='15';
defaultdata.PIV0.bootstrap_iterations='700';
defaultdata.PIV0.bootstrap_passes='12';
defaultdata.PIV0.valuthresh='-16,16';
defaultdata.PIV0.valvthresh='-16,16';
defaultdata.PIV0.corrpeak_absthresh='0';        %set to 0 so no values are excluded
defaultdata.PIV0.corrpeak_ratiothresh='1.2';    %set to 1.2 following Keane and Adrian 1990,1992
defaultdata.PIV0.uncertaintyestimate='0'; % Check if uncertainty estimation needs to be performed.
defaultdata.PIV0.ppruncertainty='0';      % Check if PPR uncertainty method is selected.
defaultdata.PIV0.miuncertainty='0';      % Check if MI uncertainty method is selected.
defaultdata.PIV0.imuncertainty='0';      % Check if IM uncertainty method is selected.
defaultdata.PIV0.mcuncertainty='0';      % Check if MC uncertainty method is selected.
defaultdata.PIV0.valextrapeaks='0';
defaultdata.PIV0.savepeakinfo='0';
defaultdata.PIV0.corrpeaknum='1';
defaultdata.PIV0.savepeakmag='0';
defaultdata.PIV0.savepeakvel='0';
defaultdata.PIV0.saveplane='0';
defaultdata.PIV0.outbase='PIV_';
defaultdata.PIV0.write='1';

defaultdata.PIV1=defaultdata.PIV0;
defaultdata.PIV2=defaultdata.PIV0;

defaultdata.passes='2';
defaultdata.method='2';
defaultdata.velinterp='3';
defaultdata.iminterp='2';  %'1'=Sinc, '2'=Sinc w/ Blackman, '3'=Bicubic, '4'=B-splines
defaultdata.framestep='3';
defaultdata.PIVerror='0.1';
defaultdata.channel = '1';

%Do we want to save the dewarped images in a subfolder of the vector output
%directory named imDeform/?
%Currently, this switch is not accessible in the GUI
defaultdata.SaveIMdeform = '0';


% --- Tracking Default Values ---
% ID Default values
defaultdata.ID.runid        = '0';
defaultdata.ID.method       = '2';
defaultdata.ID.imthresh     = '10';
defaultdata.ID.savebase     = 'ID_';
% Sizing Default values
defaultdata.Size.runsize    = '0';
defaultdata.Size.method     = 'GEO';
defaultdata.Size.min_area   = '0';
defaultdata.Size.std        = '4';
defaultdata.Size.savebase   = 'SIZE_';
% Tracking Default values
defaultdata.Track.runtrack  = '0';
defaultdata.Track.method    = '2';
defaultdata.Track.prediction= '1';
defaultdata.Track.PIVweight = '0.5';
defaultdata.Track.radius    = '15';
defaultdata.Track.disweight = '1.0';
defaultdata.Track.sizeweight= '0.5';
defaultdata.Track.intensityweight = '0.5';
defaultdata.Track.estradius = '15';
defaultdata.Track.estweight = '.1';
defaultdata.Track.savebase  = 'Track_';
defaultdata.Track.trackdat  = '0';
defaultdata.Track.trackmat  = '1';
defaultdata.Track.vectors   = '3';
defaultdata.Track.iterations= '3';
% Tracking Validation Values
defaultdata.Track.valprops.run   = '1';
defaultdata.Track.valprops.valcoef = '0,0,0.2';
defaultdata.Track.valprops.valrad = '20,20,0';
defaultdata.Track.valprops.MAD_U = '1,0.75,0';
defaultdata.Track.valprops.MAD_V = '1,0.75,0';
if ispc
    %         defaultdata.loaddirec=[pwd '\'];
    defaultdata.ID.save_dir        = [pwd,'\ID\'];
    defaultdata.Size.save_dir      = [pwd,'\Size\'];
    defaultdata.Track.save_dir     = [pwd,'\Track\'];
    defaultdata.Track.PIVprops.load_dir= [pwd,'\'];
else
    %         defaultdata.loaddirec=[pwd '/'];
    defaultdata.ID.save_dir        = [pwd,'/ID/'];
    defaultdata.Size.save_dir      = [pwd,'/Size/'];
    defaultdata.Track.save_dir     = [pwd,'/Track/'];
    defaultdata.Track.PIVprops.load_dir= [pwd,'/'];
end

defaultdata.splash='1';

%JJC: shouldn't this be in the catch statement as well?
if ~isfield(defaultdata,'outputpassbasename')
    defaultdata.outputpassbase = 'PIV_';
    defaultdata.PIV0.outbase = [defaultdata.outputpassbase 'pass0_'];
    defaultdata.PIV1.outbase = [defaultdata.outputpassbase 'pass1_'];
    defaultdata.PIV2.outbase = [defaultdata.outputpassbase 'pass2_'];
end

defaultdata.version=pranaPIVcode('version');  %why isn't this done in the catch statement above?
defaultdata.ptv_version=pranaPTVcode('version');
end
