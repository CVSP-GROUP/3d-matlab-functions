function [pcloud] = depthToCloud(depth, camera_info, topleft)
% depthToCloud.m - Convert depth image into 3D point cloud
% Author: Liefeng Bo and Kevin Lai
%
% Input: 
% depth - the depth image
% topleft - the position of the top-left corner of depth in the original depth image. Assumes depth is uncropped if this is not provided
%
% Output:
% pcloud - the point cloud, where each channel is the x, y, and z euclidean coordinates respectively. Missing values are NaN.
% distance - euclidean distance from the sensor to each point
%

if nargin < 3
    topleft = [1 1];
end

depth = double(depth);
depth(depth == 0) = nan;

% RGB-D camera constants
center = [camera_info.cx, camera_info.cy];
[imh, imw] = size(depth);
fx = camera_info.fx;
fy = camera_info.fy;
MM_PER_M = 1000;

% convert depth image to 3d point clouds
pcloud = zeros(imh,imw,3);
[xgrid,ygrid] = meshgrid(topleft(1)-center(1):imw+topleft(1)-1-center(1),topleft(2)-center(2):imh+topleft(2)-1-center(2));

pcloud(:,:,1) = xgrid.*depth/fx/MM_PER_M;
pcloud(:,:,2) = ygrid.*depth/fy/MM_PER_M;
pcloud(:,:,3) = depth/MM_PER_M;
