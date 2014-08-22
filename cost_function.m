function cost = cost_function(coor_ref, coor_stitch, I_ref, I_stitch)
[h w ~] = size(I_ref);
coor_dif = coor_ref - coor_stitch;

x_begin = max(1, 1+coor_dif(1));
x_end = min(w, w+coor_dif(1));
y_begin = max(1, 1+coor_dif(2));
y_end = min(h, h+coor_dif(2));

err = I_ref(y_begin:y_end, x_begin:x_end, :) - I_stitch((y_begin:y_end)-coor_dif(2), (x_begin:x_end)-coor_dif(1), :);
cost = norm(err(:))/length(err(:));

end
