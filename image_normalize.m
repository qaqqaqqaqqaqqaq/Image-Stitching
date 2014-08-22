function img = image_normalize(img)
if size(img, 3) ~= 1
    for i = 1:size(img, 3)
        img = img - min(min(img(:, :, i))');
        img = img / max(max(img(:, :, i))'); 
    end
else
   img = img - min(img(:));
   img = img / max(img(:)); 
end