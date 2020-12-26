function [X,Y,CC]=PIVensemble(im1,im2,tcorr,window,res,zpad,D,Zeromean,fracval,X,Y,Uin,Vin)
% --- DPIV Ensemble Correlation ---
imClass = 'double';

%     This file is part of prana, an open-source GUI-driven program for
%     calculating velocity fields using PIV or PTV.
%
%     Copyright (C) 2012  Virginia Polytechnic Institute and State
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


%convert input parameters
im1=cast(im1,imClass);
im2=cast(im2,imClass);
L = size(im1);

%convert to gridpoint list
X=X(:);
Y=Y(:);

%preallocate velocity fields and grid format
Nx = window(1);
Ny = window(2);
if nargin <=12
    Uin = zeros(length(X),1,imClass);
    Vin = zeros(length(X),1,imClass);
end
Uin = Uin(:);
Vin = Vin(:);

%sets up extended domain size
if zpad~=0
    Sy=2*Ny;
    Sx=2*Nx;
elseif strcmpi(tcorr,'DCC')
    Sy = res(1,2)+res(2,2)-1;
    Sx = res(1,1)+res(2,1)-1;
else
    Sy=Ny;
    Sx=Nx;
end

%fftshift indices
fftindy = [ceil(Sy/2)+1:Sy 1:ceil(Sy/2)];
fftindx = [ceil(Sx/2)+1:Sx 1:ceil(Sx/2)];

%window masking filter
sfilt1 = windowmask([Nx Ny],[res(1, 1) res(1, 2)]);
sfilt2 = windowmask([Nx Ny],[res(2, 1) res(2, 2)]);

% bigfilt1 = zeros(2*Ny, 2*Nx);
% bigfilt2 = zeros(2*Ny, 2*Nx);
% bigfilt1(1:Ny,1:Nx) = sfilt1;
% bigfilt2(1:Ny,1:Nx) = sfilt2;
% 
% sfilt12 = ifft2(fft2(bigfilt2).*conj(fft2(bigfilt1)));
% sfilt12 = ifftshift(sfilt12);
% sfilt12 = sfilt12( (Ny/2+1):(3*Ny/2) , (Nx/2+1):(3*Nx/2) ) / sum(sfilt1(:).*sfilt2(:));
% % keyboard


%correlation plane normalization function (always off).  
% This is only used in the DRPC code.
cnorm = ones(Ny,Nx,imClass);
%#####################################
% This is for the Dynamic RPC.  The DRPC requires a call to the subpixel
% function which requires infromation about which peak located the user
% would like to use.  Right now is is hard coded to be '1' which means 3pt
% Guassian fit.
Peaklocator = 1;
%#####################################

%RPC spectral energy filter
spectral = fftshift(energyfilt(Sx,Sy,D,0));

% This is a check for the fractionally weighted correlation.  We won't use
% the spectral filter with FWC or GCC
if strcmpi(tcorr,'FWC')
    frac = fracval;
    spectral = ones(size(spectral));
elseif strcmpi(tcorr,'GCC')
    frac = 1;
    spectral = ones(size(spectral));
else
    frac = 1;
end

% For dynamic rpc flip this switch which allows for dynamic calcuation of
% the spectral function using the diameter of the autocorrelation.
if strcmpi(tcorr,'DRPC')
    dyn_rpc = 1;
else
    dyn_rpc = 0;
end

switch upper(tcorr)

    %Standard Cross Correlation
    case 'SCC'

        %initialize correlation tensor
        CC = zeros(Sy,Sx,length(X),imClass);

        if size(im1,3) == 3
        Gens=zeros(Ny,Nx,3,imClass);
        for n=1:length(X)

            %apply the second order discrete window offset
            x1 = X(n) - floor(round(Uin(n))/2);
            x2 = X(n) +  ceil(round(Uin(n))/2);

            y1 = Y(n) - floor(round(Vin(n))/2);
            y2 = Y(n) +  ceil(round(Vin(n))/2);

            xmin1 = x1- ceil(Nx/2)+1;
            xmax1 = x1+floor(Nx/2);
            xmin2 = x2- ceil(Nx/2)+1;
            xmax2 = x2+floor(Nx/2);
            ymin1 = y1- ceil(Ny/2)+1;
            ymax1 = y1+floor(Ny/2);
            ymin2 = y2- ceil(Ny/2)+1;
            ymax2 = y2+floor(Ny/2);

            for r=1:size(im1,3);
            %find the image windows
            zone1 = im1( max([1 ymin1]):min([L(1) ymax1]),max([1 xmin1]):min([L(2) xmax1]),r );
            zone2 = im2( max([1 ymin2]):min([L(1) ymax2]),max([1 xmin2]):min([L(2) xmax2]),r );
            if size(zone1,1)~=Ny || size(zone1,2)~=Nx
                w1 = zeros(Ny,Nx,imClass);
                w1( 1+max([0 1-ymin1]):Ny-max([0 ymax1-L(1)]),1+max([0 1-xmin1]):Nx-max([0 xmax1-L(2)]) ) = zone1;
                zone1 = w1;
            end
            if size(zone2,1)~=Ny || size(zone2,2)~=Nx
                w2 = zeros(Ny,Nx,imClass);
                w2( 1+max([0 1-ymin2]):Ny-max([0 ymax2-L(1)]),1+max([0 1-xmin2]):Nx-max([0 xmax2-L(2)]) ) = zone2;
                zone2 = w2;
            end
            
            if Zeromean==1
                zone1=zone1-mean(mean(zone1));
                zone2=zone2-mean(mean(zone2));
            end
            
            %apply the image spatial filter
            region1 = (zone1).*sfilt1;
            region2 = (zone2).*sfilt2;

            %FFTs and Cross-Correlation
            f1   = fftn(region1,[Sy Sx]);
            f2   = fftn(region2,[Sy Sx]);
            P21  = f2.*conj(f1);

            %Standard Fourier Based Cross-Correlation
            G = ifftn(P21,'symmetric');
            G = G(fftindy,fftindx);
            G = abs(G);
            region1_std = std(region1(:));
            region2_std = std(region2(:));
            if region1_std == 0 || region2_std == 0
                Gens(:,:,r) = zeros(Ny,Nx);
            else
                Gens(:,:,r) = G/region1_std/region2_std/length(region1(:));
            end
            
            %store correlation matrix
            end
            CC(:,:,n) = mean(Gens,3);
%             CC(:,:,n) = mean(Gens,3)./sfilt12;
        end
        else
            for n=1:length(X)

            %apply the second order discrete window offset
            x1 = X(n) - floor(round(Uin(n))/2);
            x2 = X(n) +  ceil(round(Uin(n))/2);

            y1 = Y(n) - floor(round(Vin(n))/2);
            y2 = Y(n) +  ceil(round(Vin(n))/2);

            xmin1 = x1- ceil(Nx/2)+1;
            xmax1 = x1+floor(Nx/2);
            xmin2 = x2- ceil(Nx/2)+1;
            xmax2 = x2+floor(Nx/2);
            ymin1 = y1- ceil(Ny/2)+1;
            ymax1 = y1+floor(Ny/2);
            ymin2 = y2- ceil(Ny/2)+1;
            ymax2 = y2+floor(Ny/2);

            %find the image windows
            zone1 = im1( max([1 ymin1]):min([L(1) ymax1]),max([1 xmin1]):min([L(2) xmax1]) );
            zone2 = im2( max([1 ymin2]):min([L(1) ymax2]),max([1 xmin2]):min([L(2) xmax2]) );
            if size(zone1,1)~=Ny || size(zone1,2)~=Nx
                w1 = zeros(Ny,Nx,imClass);
                w1( 1+max([0 1-ymin1]):Ny-max([0 ymax1-L(1)]),1+max([0 1-xmin1]):Nx-max([0 xmax1-L(2)]) ) = zone1;
                zone1 = w1;
            end
            if size(zone2,1)~=Ny || size(zone2,2)~=Nx
                w2 = zeros(Ny,Nx,imClass);
                w2( 1+max([0 1-ymin2]):Ny-max([0 ymax2-L(1)]),1+max([0 1-xmin2]):Nx-max([0 xmax2-L(2)]) ) = zone2;
                zone2 = w2;
            end
            
            if Zeromean==1
                zone1=zone1-mean(zone1(:));
                zone2=zone2-mean(zone2(:));
            end
            
            %apply the image spatial filter
            region1 = (zone1).*sfilt1;
            region2 = (zone2).*sfilt2;

            %FFTs and Cross-Correlation
            f1   = fftn(region1,[Sy Sx]);
            f2   = fftn(region2,[Sy Sx]);
            P21  = f2.*conj(f1);

            %Standard Fourier Based Cross-Correlation
            G = ifftn(P21,'symmetric');
            G = G(fftindy,fftindx);
            G = abs(G);
            region1_std = std(region1(:));
            region2_std = std(region2(:));
            if region1_std == 0 || region2_std == 0
                G = zeros(Ny,Nx,imClass);
            else
                G = G/std(region1(:))/std(region2(:))/length(region1(:));
            end
            
            %store correlation matrix
            CC(:,:,n) = G;
%             CC(:,:,n) = G./sfilt12;
            end
        end
        
        %Direct Cross Correlation
    case 'DCC'
        
        %initialize correlation tensor
        CC = zeros(Sy,Sx,length(X),imClass);
        
        if size(im1,3) == 3
            Gens=zeros(res(1,2)+res(2,2)-1,res(1,1)+res(2,1)-1,3,imClass);
            for n=1:length(X)
                
                %apply the second order discrete window offset
                x1 = X(n) - floor(round(Uin(n))/2);
                x2 = X(n) +  ceil(round(Uin(n))/2);
                
                y1 = Y(n) - floor(round(Vin(n))/2);
                y2 = Y(n) +  ceil(round(Vin(n))/2);
                
                xmin1 = x1- ceil(res(1,1)/2)+1;
                xmax1 = x1+floor(res(1,1)/2);
                xmin2 = x2- ceil(res(2,1)/2)+1;
                xmax2 = x2+floor(res(2,1)/2);
                ymin1 = y1- ceil(res(1,2)/2)+1;
                ymax1 = y1+floor(res(1,2)/2);
                ymin2 = y2- ceil(res(2,2)/2)+1;
                ymax2 = y2+floor(res(2,2)/2);
                
                for r=1:size(im1,3);
                    %find the image windows
                    zone1 = im1( max([1 ymin1]):min([L(1) ymax1]),max([1 xmin1]):min([L(2) xmax1]),r );
                    zone2 = im2( max([1 ymin2]):min([L(1) ymax2]),max([1 xmin2]):min([L(2) xmax2]),r );
                    if size(zone1,1)~=Ny || size(zone1,2)~=Nx
                        w1 = zeros(res(1,2),res(1,1),imClass);
                        w1( 1+max([0 1-ymin1]):res(1,2)-max([0 ymax1-L(1)]),1+max([0 1-xmin1]):res(1,1)-max([0 xmax1-L(2)]) ) = zone1;
                        zone1 = w1;
                    end
                    if size(zone2,1)~=Ny || size(zone2,2)~=Nx
                        w2 = zeros(res(2,2),res(2,1),imClass);
                        w2( 1+max([0 1-ymin2]):res(2,2)-max([0 ymax2-L(1)]),1+max([0 1-xmin2]):res(2,1)-max([0 xmax2-L(2)]) ) = zone2;
                        zone2 = w2;
                    end
                    
                    if Zeromean==1
                        zone1=zone1-mean(mean(zone1));
                        zone2=zone2-mean(mean(zone2));
                    end
                    
                    %apply the image spatial filter
                    region1 = (zone1);%.*sfilt1;
                    region2 = (zone2);%.*sfilt2;
                                    
                    %correlation done using xcorr2 which is faster then fft's
                    %for strongly uneven windows.
                    %G = xcorr2(region2,region1);
                    % This is a stripped out version of xcorr2
                    G = conv2(region2, rot90(conj(region1),2));
                    
%                 % Comment out this section because it will mess up single
%                 % pixel correlation methods.
%                     region1_std = std(region1(:));
%                     region2_std = std(region2(:));
%                     if region1_std == 0 || region2_std == 0
%                         G = zeros(Sy,Sx);
%                     else
%                         G = G/std(region1(:))/std(region2(:))/length(region1(:));
%                     end
                    Gens(:,:,r) = G;
                    
                    %store correlation matrix
                end
                CC(:,:,n) = mean(Gens,3);
%                 CC(:,:,n) = mean(Gens,3)./sfilt12;
            end
        else
            for n=1:length(X)
                
                %apply the second order discrete window offset
                x1 = X(n) - floor(round(Uin(n))/2);
                x2 = X(n) +  ceil(round(Uin(n))/2);
                
                y1 = Y(n) - floor(round(Vin(n))/2);
                y2 = Y(n) +  ceil(round(Vin(n))/2);
                
                xmin1 = x1- ceil(res(1,1)/2)+1;
                xmax1 = x1+floor(res(1,1)/2);
                xmin2 = x2- ceil(res(2,1)/2)+1;
                xmax2 = x2+floor(res(2,1)/2);
                ymin1 = y1- ceil(res(1,2)/2)+1;
                ymax1 = y1+floor(res(1,2)/2);
                ymin2 = y2- ceil(res(2,2)/2)+1;
                ymax2 = y2+floor(res(2,2)/2);
                
                %find the image windows
                zone1 = im1( max([1 ymin1]):min([L(1) ymax1]),max([1 xmin1]):min([L(2) xmax1]) );
                zone2 = im2( max([1 ymin2]):min([L(1) ymax2]),max([1 xmin2]):min([L(2) xmax2]) );
                if size(zone1,1)~=res(1,2) || size(zone1,2)~=res(1,1)
                    w1 = zeros(res(1,2),res(1,1),imClass);
                    w1( 1+max([0 1-ymin1]):res(1,2)-max([0 ymax1-L(1)]),1+max([0 1-xmin1]):res(1,1)-max([0 xmax1-L(2)]) ) = zone1;
                    zone1 = w1;
                end
                if size(zone2,1)~=res(2,2) || size(zone2,2)~=res(2,1)
                    w2 = zeros(res(2,2),res(2,1),imClass);
                    w2( 1+max([0 1-ymin2]):res(2,2)-max([0 ymax2-L(1)]),1+max([0 1-xmin2]):res(2,1)-max([0 xmax2-L(2)]) ) = zone2;
                    zone2 = w2;
                end

                if Zeromean==1
                    zone1=zone1-mean(zone1(:));
                    zone2=zone2-mean(zone2(:));
                end
                
                %apply the image spatial filter
                region1 = (zone1);%.*sfilt1;
                region2 = (zone2);%.*sfilt2;
                
                %correlation done using xcorr2 which is faster then fft's
                %for strongly uneven windows.
                %G = xcorr2(region2,region1);
                % This is a stripped out version of xcorr2
                G = conv2(region2, rot90(conj(region1),2));
                
%                 % Comment out this section because it will mess up single
%                 % pixel correlation methods.
%                region1_std = std(region1(:));
%                region2_std = std(region2(:));
%                if region1_std == 0 || region2_std == 0
%                    G = zeros(Sy,Sx);
%                else
%                    G = G/std(region1(:))/std(region2(:))/length(region1(:));
%                end
                CC(:,:,n) = G;
                        
            end
        end

    %Robust Phase Correlation
    case {'RPC','DRPC','GCC','FWC'}

        %initialize correlation tensor
        CC = zeros(Sy,Sx,length(X),imClass);
        
        if size(im1,3) == 3
        Gens=zeros(Ny,Nx,3,imClass);     %matrix for storing each color correlation for color ensemble      
        for n=1:length(X)

            %apply the second order discrete window offset
            x1 = X(n) - floor(round(Uin(n))/2);
            x2 = X(n) +  ceil(round(Uin(n))/2);

            y1 = Y(n) - floor(round(Vin(n))/2);
            y2 = Y(n) +  ceil(round(Vin(n))/2);

            xmin1 = x1- ceil(Nx/2)+1;
            xmax1 = x1+floor(Nx/2);
            xmin2 = x2- ceil(Nx/2)+1;
            xmax2 = x2+floor(Nx/2);
            ymin1 = y1- ceil(Ny/2)+1;
            ymax1 = y1+floor(Ny/2);
            ymin2 = y2- ceil(Ny/2)+1;
            ymax2 = y2+floor(Ny/2);

            for r=1:size(im1,3);
            %find the image windows
            zone1 = im1( max([1 ymin1]):min([L(1) ymax1]),max([1 xmin1]):min([L(2) xmax1]),r );
            zone2 = im2( max([1 ymin2]):min([L(1) ymax2]),max([1 xmin2]):min([L(2) xmax2]),r );
            if size(zone1,1)~=Ny || size(zone1,2)~=Nx
                w1 = zeros(Ny,Nx,imClass);
                w1( 1+max([0 1-ymin1]):Ny-max([0 ymax1-L(1)]),1+max([0 1-xmin1]):Nx-max([0 xmax1-L(2)]) ) = zone1;
                zone1 = w1;
            end
            if size(zone2,1)~=Ny || size(zone2,2)~=Nx
                w2 = zeros(Ny,Nx,imClass);
                w2( 1+max([0 1-ymin2]):Ny-max([0 ymax2-L(1)]),1+max([0 1-xmin2]):Nx-max([0 xmax2-L(2)]) ) = zone2;
                zone2 = w2;
            end
            
            if Zeromean==1
                zone1=zone1-mean(zone1(:));
                zone2=zone2-mean(zone2(:));
            end

            %apply the image spatial filter
            region1 = zone1.*sfilt1;
            region2 = zone2.*sfilt2;

            %FFTs and Cross-Correlation
            f1   = fftn(region1,[Sy Sx]);
            f2   = fftn(region2,[Sy Sx]);
            P21  = f2.*conj(f1);

            %Phase Correlation
            W = ones(Sy,Sx,imClass);
            Wden = sqrt(P21.*conj(P21));
            W(Wden~=0) = Wden(Wden~=0);
            if frac ~=1
                R = P21./(W.^frac);%apply factional weighting to the normalization
            else
                R = P21./W;
            end
            
            % If DRPC, the calculate the spectral function
            % dynamically based on the autocorrelation
            if dyn_rpc
                CPS = ifftn(Wden,'symmetric');
                [~,~,~,Drpc]=subpixel(CPS(fftindy,fftindx),Sx,Sy,cnorm,Peaklocator,0,D);
                spectral = fftshift(energyfilt(Sx,Sy,Drpc./sqrt(2),0));
            end

            %Robust Phase Correlation with spectral energy filter
            G = ifftn(R.*spectral,'symmetric');
            G = G(fftindy,fftindx);
            Gens(:,:,r) = abs(G);
            
            end
            %store correlation matrix
            CC(:,:,n) = mean(Gens,3);
%             CC(:,:,n) = mean(Gens,3)./sfilt12;

        end
        else
            for n=1:length(X)

            %apply the second order discrete window offset
            x1 = X(n) - floor(round(Uin(n))/2);
            x2 = X(n) +  ceil(round(Uin(n))/2);

            y1 = Y(n) - floor(round(Vin(n))/2);
            y2 = Y(n) +  ceil(round(Vin(n))/2);

            xmin1 = x1- ceil(Nx/2)+1;
            xmax1 = x1+floor(Nx/2);
            xmin2 = x2- ceil(Nx/2)+1;
            xmax2 = x2+floor(Nx/2);
            ymin1 = y1- ceil(Ny/2)+1;
            ymax1 = y1+floor(Ny/2);
            ymin2 = y2- ceil(Ny/2)+1;
            ymax2 = y2+floor(Ny/2);

            %find the image windows
            zone1 = im1( max([1 ymin1]):min([L(1) ymax1]),max([1 xmin1]):min([L(2) xmax1]) );
            zone2 = im2( max([1 ymin2]):min([L(1) ymax2]),max([1 xmin2]):min([L(2) xmax2]) );
            if size(zone1,1)~=Ny || size(zone1,2)~=Nx
                w1 = zeros(Ny,Nx,imClass);
                w1( 1+max([0 1-ymin1]):Ny-max([0 ymax1-L(1)]),1+max([0 1-xmin1]):Nx-max([0 xmax1-L(2)]) ) = zone1;
                zone1 = w1;
            end
            if size(zone2,1)~=Ny || size(zone2,2)~=Nx
                w2 = zeros(Ny,Nx,imClass);
                w2( 1+max([0 1-ymin2]):Ny-max([0 ymax2-L(1)]),1+max([0 1-xmin2]):Nx-max([0 xmax2-L(2)]) ) = zone2;
                zone2 = w2;
            end
            
            if Zeromean==1
                zone1=zone1-mean(zone1(:));
                zone2=zone2-mean(zone2(:));
            end

            %apply the image spatial filter
            region1 = zone1.*sfilt1;
            region2 = zone2.*sfilt2;

            %FFTs and Cross-Correlation
            f1   = fftn(region1,[Sy Sx]);
            f2   = fftn(region2,[Sy Sx]);
            P21  = f2.*conj(f1);

            %Phase Correlation
            W = ones(Sy,Sx,imClass);
            Wden = sqrt(P21.*conj(P21));
            W(Wden~=0) = Wden(Wden~=0);
            if frac ~=1
                R = P21./(W.^frac);%apply factional weighting to the normalization
            else
                R = P21./W;
            end
            
            % If DRPC, the calculate the spectral function
            % dynamically based on the autocorrelation
            if dyn_rpc
                CPS = ifftn(Wden,'symmetric');
                [~,~,~,Drpc]=subpixel(CPS(fftindy,fftindx),Sx,Sy,cnorm,Peaklocator,0,D);
                spectral = fftshift(energyfilt(Sx,Sy,Drpc./sqrt(2),0));
            end

            %Robust Phase Correlation with spectral energy filter
            G = ifftn(R.*spectral,'symmetric');
            G = G(fftindy,fftindx);
            G = abs(G);
            
            %store correlation matrix
            CC(:,:,n) = G;
%             CC(:,:,n) = G./sfilt12;

            end
        end
        
    %Spectral Phase Correlation    
    case 'SPC'
        
        %initialize correlation tensor
        CC.U = zeros(3,Sx,length(X),imClass);
        CC.V = zeros(3,Sy,length(X),imClass);
        CC.C = zeros(3, 1,length(X),imClass);
        u_unwrapped = zeros(Sy,3,imClass);
        v_unwrapped = zeros(Sx,3,imClass);
        
        for n=1:length(X)

            %apply the second order discrete window offset
            x1 = X(n) - floor(round(Uin(n))/2);
            x2 = X(n) +  ceil(round(Uin(n))/2);

            y1 = Y(n) - floor(round(Vin(n))/2);
            y2 = Y(n) +  ceil(round(Vin(n))/2);

            xmin1 = x1- ceil(Nx/2)+1;
            xmax1 = x1+floor(Nx/2);
            xmin2 = x2- ceil(Nx/2)+1;
            xmax2 = x2+floor(Nx/2);
            ymin1 = y1- ceil(Ny/2)+1;
            ymax1 = y1+floor(Ny/2);
            ymin2 = y2- ceil(Ny/2)+1;
            ymax2 = y2+floor(Ny/2);

            %find the image windows
            zone1 = im1( max([1 ymin1]):min([L(1) ymax1]),max([1 xmin1]):min([L(2) xmax1]) );
            zone2 = im2( max([1 ymin2]):min([L(1) ymax2]),max([1 xmin2]):min([L(2) xmax2]) );
            if size(zone1,1)~=Ny || size(zone1,2)~=Nx
                w1 = zeros(Ny,Nx,imClass);
                w1( 1+max([0 1-ymin1]):Ny-max([0 ymax1-L(1)]),1+max([0 1-xmin1]):Nx-max([0 xmax1-L(2)]) ) = zone1;
                zone1 = w1;
            end
            if size(zone2,1)~=Ny || size(zone2,2)~=Nx
                w2 = zeros(Ny,Nx,imClass);
                w2( 1+max([0 1-ymin2]):Ny-max([0 ymax2-L(1)]),1+max([0 1-xmin2]):Nx-max([0 xmax2-L(2)]) ) = zone2;
                zone2 = w2;
            end
            
            if Zeromean==1
                zone1=zone1-mean(zone1(:));
                zone2=zone2-mean(zone2(:));
            end

            %apply the image spatial filter
            region1 = zone1.*sfilt1;
            region2 = zone2.*sfilt2;

            %FFTs and Cross-Correlation
            f1   = fftn(region1,[Sy Sx]);
            f2   = fftn(region2,[Sy Sx]);
            P21  = f2.*conj(f1);

            %Phase Correlation
            W = ones(Sy,Sx);
            Wden = sqrt(P21.*conj(P21));
            W(P21~=0) = Wden(P21~=0);
            R = P21./W;
            R = R(fftindy,fftindx);
            [u,s,v]=svd(R);

            %Unwrap the 3 most dominant modes and save their eigenvalues
            for m=1:3
                v_unwrapped(:,m)=unwrap(angle(v(:,m)'))'; % U-component
                u_unwrapped(:,m)=unwrap(angle(u(:,m)'))'; % V-component
            end
            Ctemp=[s(1,1) s(2,2) s(3,3)]';
            
            %Shift so that the midpoint of the data crosses the origin
            um=(v_unwrapped-repmat(v_unwrapped(Sx/2+1,:),[length(v_unwrapped) 1]))';
            vm=(u_unwrapped-repmat(u_unwrapped(Sy/2+1,:),[length(u_unwrapped) 1]))';

            %store data
            CC.U(:,:,n) = um;
            CC.V(:,:,n) = vm;
            CC.C(:,:,n) = Ctemp;
        end
        
    otherwise
        error('Correlation type not supported')

end
end
