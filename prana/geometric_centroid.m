function [x_centroid,y_centroid,diameter,I0] = geometric_centroid(p_mat,im,min_area)
% function [x,y,diameter,Io] = geometric_centroid(seg_image,raw_image,min_area)
% This function calculates the geometric centroids on objcets in an images.
% The function takes output from mapparticles_v3 and uses that to find the
% geometric center.  This function different from the Intensity weighted
% centroid in that it doesn't use any intensity information for finding the
% cetner just the simple geometric shape.  This might not be accurate for
% particles but it works well for irregularly shaped objects that are
% wished to be tracked.  The output of this code is the x and y centroid,
% along with the corresponding diameter in pixels and the objects maximum
% intesnity.

% Written by: Sam Raben 2012.04.24

%     This file is part of prana, an open-source GUI-driven program for
%     calculating velocity fields using PIV or PTV.
%     Copyright (C) 2012  Virginia Polytechnic Institute and State
%     University
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


% Take the segmented region and find the centroid, area, max intensity, and
% pixel index list for each feature.
R = regionprops(p_mat,im,'Area','Centroid','MaxIntensity','PixelIdxList');

% This loop fines all of the features that are 1 pixel or less in size as
% well as it removes features that are less then the user defined minimum
% area.
for i = 1:length(R)
    if length(R(i).PixelIdxList) > 1 && R(i).Area >= min_area
        keep(i) = i;%#ok        
    end
end

% Once of those features have been found they can be removed
keep(keep==0) = [];

% Preallocate the variables based on the new total number of features
x_centroid = zeros(length(keep),1);
y_centroid = zeros(length(keep),1);
diameter   = zeros(length(keep),1);
I0         = zeros(length(keep),1);

% Loop throug the remaining features and extract the relevant infromation
for j = 1:length(keep)
        x_centroid(j) = R(keep(j)).Centroid(1);
        y_centroid(j) = R(keep(j)).Centroid(2);
        diameter(j)   = R(keep(j)).Area;
        I0(j)         = R(keep(j)).MaxIntensity;
end
end
