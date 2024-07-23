function result = transform_coords(coordinates,x_ratio, y_ratio)
% [ox, oy, oz, ux, uy, uz, vx, vy, vz] = coordinates;
ox = coordinates(1);
oy = coordinates(2);
oz = coordinates(3);
ux = coordinates(4);
uy = coordinates(5);
uz = coordinates(6);
vx = coordinates(7);
vy = coordinates(8);
vz = coordinates(9);

coord_q = [x_ratio, y_ratio, 1] * [ux uy uz; vx vy vz;ox oy oz];
xq = coord_q(1);
yq = coord_q(2);
zq = coord_q(3);
                                        
result = [ xq  yq  zq  1 ] * [ 0 0 25  0 ;-25 0   0  0; 0 -25   0  0;13175  7975   0  1 ];
result = result([3,2,1]) / 10;
end