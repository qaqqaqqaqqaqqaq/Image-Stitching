function [ feature coor ] = MSOP_descriptor( anms_list, cos, sin, P, Ig, lv )

coor = []; 
feature = [];
[h w] = size(Ig);

for s = 1:size( anms_list{lv}, 2)
    coor_x = anms_list{lv}{s}(1);
    coor_y = anms_list{lv}{s}(2);
    cos_tmp = cos( coor_x, coor_y);
    sin_tmp = sin( coor_x, coor_y);
    theta_tmp = theta( sin_tmp, cos_tmp); % arc cos
       %% cut patch
    if coor_x >= 6 && coor_x <= (h-6) && coor_y >=7 && coor_y <= (w-5)
        coor = [ coor [coor_y; coor_x] ];
        patch = P{lv}( coor_x-5: coor_x+6, coor_y-6: coor_y+5);
        patch = imrotate(patch, -theta_tmp);
        patch = imresize(patch, 8/size(patch,1)); 
        patch = ( patch - mean(patch(:))*ones(8,8) ) / std(patch(:));
        feature = [feature reshape(patch, [64 1])];
    end
        
end

end

