function [coor feature] = feature_extract(I, FEATURE_TYPE)
if size(I, 3) == 3
    I = rgb2gray(image_normalize(I));
else
    I = image_normalize(I);
end

switch FEATURE_TYPE
    case 1,
        lv = 1;

        %% Interest Points //f_HM
        [ P, Interest_value ] = MSHC( I );

        %% Non-maximal suppression (ANMS) // anms_list
        if size(I, 1) > 500
            [ anms_list ] = ANMS( Interest_value, lv , 16);
        else
            [ anms_list ] = ANMS( Interest_value, lv , 64);
        end
        %% Orientation
        [ cos sin ] =  orientation( P{lv} );

        %% Feature Descriptor + Normalisation
        [ feature coor ] = MSOP_descriptor( anms_list, cos, sin, P, I, lv );
    case 2,
        [coor feature] = vl_sift(single(I));
        coor(3:4,:) = [];
        coor = round(coor);
end

end
