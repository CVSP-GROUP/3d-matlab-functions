function P = image2world(p, camera_info)
% Convert a set of pixel-depth pairs to a set of 3D points
%
% Inputs:
%  p: N x 3 array, columms are x, y, z respectively (x, y in pixels, z in mm)
%  camera_info: struct with fields fx, fy, cx, cy (camera intrisic parameters)
% Output:
%  P: N x 3 array, columms are X, Y, Z respectively (values in metres)

fx = camera_info.fx;
fy = camera_info.fy;
cx = camera_info.cx;
cy = camera_info.cy;

x = p(:,1);
y = p(:,2);
z = p(:,3);

X = (x-cx).*z/fx;
Y = (y-cy).*z/fy;
Z = z;
P = [X,Y,Z]/1000;

end

