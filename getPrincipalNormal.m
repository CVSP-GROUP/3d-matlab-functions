function principalNormal = getPrincipalNormal( depth, camera_info, ax )
% Return the principle normal vector, with the sign controlled by ax. Useful
% for finding the direction of gravity in a room, provided the floor, tabletops
% etc. take up a significant percentage of the image pixels. If not, try crop-
% ping the image and/or removing values beyond a certain depth. When cropping,
% don't forget to change the camera_info values cx and cy accordingly.
%
% Inputs:
%  depth: depth image H x W (values in mm)
%  camera_info: array with values [fx, fy, cx, cy] (camera intrisic parameters)
%               also can be struct with fields fx, fy, cx, cy
%  ax: which axis should be positive or negative. 1,2,3 for x,y,z positive re-
%      spectively, -1,-2,-3 for x,y,z negative respectively. Default = -2
%
% Outputs:
%  principalNormal: 3 x 1

if nargin < 3
    ax = -2;
end
if ~ismember(ax, [-3,-2,-1,1,2,3])
    error('Error. Argument ax must be one of: -3,-2,-1,1,2,3')
end

addpath('util')
addpath('util/GridSphere/')

if ~isstruct(camera_info)
    old_cinfo = camera_info;
    camera_info = struct
    camera_info.fx = old_cinfo(1);
    camera_info.fy = old_cinfo(2);
    camera_info.cx = old_cinfo(3);
    camera_info.cy = old_cinfo(4);
end
pcl = depthToCloud(depth, camera_info);
[N, ~] = computeNormalsSquareSupport(pcl, [], 3, ones(size(depth)));
N = reshape(N, [], 3);
N(isnan(N(:,1)),:) = [];
[az, el, ~] = cart2sph(N(:,1), N(:,2), N(:,3));
toInvert = el < 0;
az(toInvert) = -az(toInvert);
el(toInvert) = -el(toInvert);

numBins = 162;
[latGridInDegs, longGridInDegs] = GridSphere(numBins);
h = FindNearestNeighbors(el*180/pi, az*180/pi, latGridInDegs, longGridInDegs);
[counts, ~] = hist(h, 1:numBins);
[~, maxInd] = max(counts);

[x, y, z] = sph2cart(mean(az(h==maxInd)), mean(el(h==maxInd)), 1);
principalNormal = [x; y; z];

if principalNormal(abs(ax))*ax < 0
    principalNormal = -principalNormal;
end

rmpath('util/GridSphere/')
 
end

