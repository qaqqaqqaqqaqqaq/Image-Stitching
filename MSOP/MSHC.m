function [ P, Interest_value ] = MSHC( I )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
I = I*255;
s = 2;
window_size = [5 5];
sigma_p = 1;
sigma_i = 1.5;
sigma_d = 1;
GF_p = fspecial('gaussian', window_size, sigma_p);
GF_d = fspecial('gaussian', window_size, sigma_d);
GF_i = fspecial('gaussian', window_size, sigma_i);
[h w] = size(I);
level = floor(log2(min(h,w)))-4; % decide floor

P = [];
Ig_tmp = I; % 1-->i
img_tmp = Ig_tmp;
for lv = 1:level
    P{lv} = double(img_tmp);
    [h_tmp w_tmp] = size(img_tmp);
    Ppron = imfilter(img_tmp, GF_p, 'same');
    img_tmp = imresize( Ppron, 0.5 );
end

f_HM = [];
Interest = [];
Interest_value = [];
lv = 1;
   f_HM{lv} = zeros(h_tmp, w_tmp);
   [Gx Gy] = gradient(P{lv});
   [h_tmp w_tmp] = size(P{lv});
   
   Drvt_x = imfilter( Gx, GF_d, 'same');
   Drvt_y = imfilter( Gy, GF_d, 'same');
  
   H = cell( 2, 2 );
   H{1,1} = imfilter( Drvt_x.*Drvt_x, GF_i, 'same');
   H{1,2} = imfilter( Drvt_x.*Drvt_y, GF_i, 'same');
   H{2,1} = imfilter( Drvt_y.*Drvt_x, GF_i, 'same');
   H{2,2} = imfilter( Drvt_y.*Drvt_y, GF_i, 'same');
   for i = 1:h_tmp
       for j = 1:w_tmp
           Mtmp = zeros(2,2);
           Mtmp(1,1) = H{1,1}(i,j);
           Mtmp(1,2) = H{1,2}(i,j);
           Mtmp(2,1) = H{2,1}(i,j);
           Mtmp(2,2) = H{2,2}(i,j);
           d = det(Mtmp);
           t = trace(Mtmp);
           if t~=0
               f_HM{lv}(i,j) = det(Mtmp)/trace(Mtmp);
           elseif t == 0 && d>0
               f_HM{lv}(i,j) = 10;%inf
           else
               f_HM{lv}(i,j) = 0;
           end
       end
   end
   Interest{lv} = zeros(h_tmp, w_tmp);
   Interest_value{lv} = zeros(h_tmp, w_tmp);
   fHMtmp = padarray(f_HM{lv}, [1,1],'replicate');
   for i = 1:h_tmp
       for j = 1:w_tmp
           Ntmp = fHMtmp(i:i+2, j:j+2);
           if (f_HM{lv}(i,j) == max(Ntmp(:))) && (f_HM{lv}(i,j) >= 10)
              Interest{lv}(i,j) = 1; 
              Interest_value{lv}(i,j) = f_HM{lv}(i,j);
           end
       end
   end
end

