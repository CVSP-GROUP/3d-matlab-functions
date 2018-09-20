function p = world2image(P, camera_info)
% Convert a set of 3D points to a set of pixel-depth pairs
%
% Inputs:
%  P: N x 3 array, columms are X, Y, Z respectively (values in metres)
%  camera_info: struct with fields fx, fy, cx, cy (camera intrisic parameters)
% Output:
%  m: N x 3 array, columms are x, y, z respectively (x, y in pixels, z in mm)

fx = camera_info.fx;
fy = camera_info.fy;
cx = camera_info.cx;
cy = camera_info.cy;

P = P*1000;
X = P(:,1);
Y = P(:,2);
Z = P(:,3);

x = X*fx./Z + cx;
y = Y*fy./Z + cy;
z = Z;
p = [x,y,z];

end

