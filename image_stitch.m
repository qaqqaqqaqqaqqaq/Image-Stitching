function [I_p_adj I_p] = image_stitch(directory, image_type, CLOCKWISE, FEATURE_TYPE, LK_ALIGN)

data = dir([ directory 'original/*.' image_type]);
load([directory 'original/f.txt']);

SIFT_path = genpath('SIFT_library');
addpath(SIFT_path);
MSOP_path = genpath('MSOP');
addpath(MSOP_path);

RANSAC_iter = 100;
LK_iter = 200;

begin = cputime;
%%
fprintf('Performing cylindrical projection...\n');
reverseStr = '';
tic;
I = {length(data)};
for i = 1:length(data)
    msg = sprintf('Processing image: %d/%d\n', i, length(data));
    fprintf([reverseStr, msg]);
    reverseStr = repmat(sprintf('\b'), [1 length(msg)]);
    if CLOCKWISE
        I{i} = cylindrical_project(double(imread([directory 'original/' data(length(data)-i+1).name])), f);
    else
        I{i} = cylindrical_project(double(imread([directory 'original/' data(i).name])), f);
    end
end
toc;

%%
tic;
% MV = zeros(2, length(data));
fprintf('\nComputing motion vectors...\n');
reverseStr = '';
IM = [];
coor_ref = [];
for i = 1:length(data)-1
    msg = sprintf('Processing stichcing pairs: %d/%d\n', i, length(data)-1);
    fprintf([reverseStr, msg]);
    reverseStr = repmat(sprintf('\b'), [1 length(msg)]);
    
    I_ref = I{i+1};
    I_stitch = I{i};        

    if i == 1
        [coor_ref feature_ref] = feature_extract(I_ref, FEATURE_TYPE);
        [coor_stitch feature_stitch] = feature_extract(I_stitch, FEATURE_TYPE);
    else
        [coor_ref feature_ref] = feature_extract(I_ref, FEATURE_TYPE);
    end
    cost = realmax;
    switch FEATURE_TYPE
        % MSOP
        case 1,
            tt = min(RANSAC_iter, size(feature_stitch, 2));
            idx = randperm(size(feature_stitch, 2), tt);
            seq = zeros(1, size(feature_stitch, 2));
            for j = 1:size(feature_stitch, 2)
                err = repmat(feature_stitch(:, j), [1 size(feature_ref, 2)]) - feature_ref;
                [s n] = min(sum(err.^2)');
                seq(j) = n(1);
            end
            plot_match(I_stitch, I_ref, coor_ref, coor_stitch, [seq; 1:size(feature_stitch, 2)], [directory 'matched/matched_pair_' num2str(i)]);
            for j = 1:tt
                n = seq(idx(j));
                coor_R = coor_ref(:, n);
                coor_S = coor_stitch(:, idx(j));
                coor_dif = coor_R - coor_S;
                if coor_dif(1) > 0
                    cost_tmp = cost_function(coor_R, coor_S, I_ref, I_stitch);
                    if cost > cost_tmp
                        cost = cost_tmp;
                        MV_tmp = coor_dif;
                    end
                    
                end
            end
        % SIFT
        case 2,
            sift_match = vl_ubcmatch(feature_ref, feature_stitch);
            plot_match(I_stitch, I_ref, coor_ref, coor_stitch, sift_match, [directory 'matched/matched_pair_' num2str(i)]);
            tt = min(size(sift_match, 2), RANSAC_iter);
            for j = 1:tt
                coor_R = coor_ref(:, sift_match(1, j));
                coor_S = coor_stitch(:, sift_match(2, j));
                coor_dif = coor_R - coor_S;
                if coor_dif(1) > 0
                    cost_tmp = cost_function(coor_R, coor_S, I_ref, I_stitch);
                    if cost > cost_tmp
                        cost = cost_tmp;
                        MV_tmp = coor_dif;
                    end
                end
            end        
    end
    % modify with LK
    if LK_ALIGN
        [h w ~] = size(I_ref);
        x_begin = max(1, 1 + MV_tmp(1));
        x_end = min(w, w + MV_tmp(1));
        y_begin = max(1, 1 + MV_tmp(2));
        y_end = min(h, h + MV_tmp(2));
        Y1 = rgb2gray(image_normalize(I_ref(y_begin:y_end, x_begin:x_end, :)));
        I1 = zeros(20+size(Y1, 1), 20+size(Y1, 2));
        I1(11:size(Y1, 1)+10, 11:size(Y1, 2)+10) = Y1;
        Y2 = rgb2gray(image_normalize(I_stitch((y_begin:y_end)-MV_tmp(2), (x_begin:x_end)-MV_tmp(1), :)));
        I2 = zeros(20+size(Y2, 1), 20+size(Y2, 2));
        I2(11:size(Y2, 1)+10, 11:size(Y2, 2)+10) = Y2;
        M = eye(3);
        for j = 1:LK_iter
            M = LK(M, I2, I1);
            I2 = back_warp(M, I2, 2, 1);
        end
        MV_tmp = round(M(1:2, 3) + MV_tmp);
    end
    MV(:, i) = MV_tmp;
    
    coor_stitch = coor_ref;
    feature_stitch = feature_ref;
end
toc;

%%
% TODO: blending
fprintf('\nPerforming image stitching...\n');
tic;
reverseStr = '';
for i = 1:length(data)-1
    msg = sprintf('Stitching image pair: %d/%d\n', i, length(data)-1);
    fprintf([reverseStr, msg]);
    reverseStr = repmat(sprintf('\b'), [1 length(msg)]);
    if i == 1
        I_p = stitch(MV(:, i), I{i+1}, I{i});
    else
        I_p = stitch(MV(:, i), I{i+1}, I_p);
    end
end
toc;


%%
tic;
fprintf('\nAdjusting...\n');
I_p_drift = drift_adjust(I{1}, I_p);
I_p_adj = bundle_adjust(I_p_drift, 0.95);
toc;

%%
interval = cputime - begin;
fprintf ('\nTotal running time: %fs\n', interval);

%%
figure, imshow(I_p/255);
figure, imshow(I_p_adj/255);

imwrite(I_p/255, [directory 'stitched/result.png']);
imwrite(I_p_adj/255, [directory 'stitched/result_adjust.png']);