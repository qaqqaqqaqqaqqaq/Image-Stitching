str = {'../image/parrington/' '../image/house/' '../image/bio/' '../artifact/'};
I = [];
I_adjust = [];
FEATURE_TYPE = 1;   % our MSOP

%% run parrington
fprintf ('Performing image stitching: %s\n', str{1});
[I_adjust{1} I{1}] = image_stitch(str{1}, 'jpg', 0, FEATURE_TYPE, 0, 1);

%% run house
fprintf ('Performing image stitching: %s\n', str{1});
[I_adjust{2} I{2}] = image_stitch(str{2}, 'png', 1, FEATURE_TYPE, 0, 1);

%% run bio
fprintf ('Performing image stitching: %s\n', str{1});
[I_adjust{3} I{3}] = image_stitch(str{3}, 'JPG', 0, FEATURE_TYPE, 1, 1);

%% run artifact
fprintf ('Performing image stitching: %s\n', str{1});
[I_adjust{4} I{4}] = image_stitch(str{4}, 'JPG', 0, FEATURE_TYPE, 0, 1);
