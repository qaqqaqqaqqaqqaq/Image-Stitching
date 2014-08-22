function [ cos sin ] =  orientation( I )

sigma_o = 4.5;
window_size = [5 5];
[Gx Gy] = gradient(I);
GF_o = fspecial('gaussian', window_size, sigma_o);
Drvt_x = imfilter( Gx, GF_o, 'same');
Drvt_y = imfilter( Gy, GF_o, 'same');

len = power( (power(Drvt_x, 2) + power(Drvt_y, 2)), 0.5);

cos = Drvt_x./len;
sin = Drvt_y./len;

cos (find(isnan(cos)) ) = 0;
sin( find(isnan(sin)) ) = 0;

end

