function [ anms_list ] = ANMS( Interest_value, lv , radius)
anms_list = [];
rows = [];
cols = [];    
anms_list{lv} = [];

[val, ind] = max( Interest_value{lv}(:) );
[row, col] = ind2sub(size(Interest_value{lv}),ind);
anms_list{lv}{1} = [row, col];
Interest_value{lv}(row, col) = 0;
count = 1;
[val, ind] = max( Interest_value{lv}(:) );
while( val ~= 0)
    %disp(count);
    [row, col] = ind2sub(size(Interest_value{lv}),ind);
    pos = [row, col];
    listsize = size( anms_list{lv}, 2);
    %disp(listsize);
    key = 1;
    for s = 1:listsize
        dist = norm(pos - anms_list{lv}{s} );
        if dist < radius
            key = 0;
            break;
        end
    end
    if key == 1
        count = count + 1;
        anms_list{lv}{count} = [row, col];
    end
    Interest_value{lv}(row, col) = 0;
    [val, ind] = max( Interest_value{lv}(:) );
end
rows{lv} = [];
cols{lv} = [];
for s = 1:size( anms_list{lv}, 2)
    rows{lv}(s) = anms_list{lv}{s}(1);
    cols{lv}(s) = anms_list{lv}{s}(2);
end

radius = radius/2;   
end

