function [P] = back_warp(M, I, int_type, fix_nan)
[h w] = size(I);

[X Y] = meshgrid(1:w, 1:h);
num = w*h;

UV = inv(M)*[reshape(X, [1 num]); reshape(Y, [1 num]); ones(1, num)];
UV = UV(1:2,:)';

xi = reshape(UV(:,1),[h w]);
yi = reshape(UV(:,2),[h w]);

if int_type
    P = interp2(I, xi, yi, 'nearest');
else
    P = interp2(I, xi, yi, 'cubic');
end
P = P(1:size(I, 1), 1:size(I, 2));
if fix_nan
    P(isnan(P)) = 0;
end

end