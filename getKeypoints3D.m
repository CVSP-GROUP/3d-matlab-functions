function y = getKeypoints3D(keypoints, depth, camera_info)
% Convert 2D keypoints and depth image into 3D keypoints
%
% Inputs:
%  keypoints: N x K, K must be multiple of 3. Each group of 3 columns
%             correspond to x, y and confidence for a certain keypoint, as
%             given for example by the OpenPose library. x and y are 0-based.
%  depth: depth image (values in mm)
%  camera_info: struct with fields fx, fy, cx, cy (camera intrisic parameters)
%
% Output:
%  y: 3D keypoints, each group of 3 columns is X, Y and Z of a certain keypoint

fx = camera_info.fx;
fy = camera_info.fy;
cx = camera_info.cx;
cy = camera_info.cy;

ind = 1:length(keypoints);
ind(3:3:end) = [];
indX = round(keypoints(1:3:end)) + 1;
indY = round(keypoints(2:3:end)) + 1;
depthHeight = size(depth, 1);
depthWidth = size(depth, 2);
Z = nan(size(indX));
c = indX>0 & indY>0 & indX<=depthWidth & indY<=depthHeight;
Z(c) = depth(indY(c) + (indX(c)-1)*depthHeight) / 1000;
X = (indX-cx).*Z/fx;
Y = (indY-cy).*Z/fy;
y = [X;Y;Z];
y = y(:)';

end
