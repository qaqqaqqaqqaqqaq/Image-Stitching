function I = bundle_adjust(I, ratio)

mask = ones(size(I, 1), size(I, 2));
mask(I(:, :, 1) == 0 & I(:, :, 2) == 0 & I(:, :, 3) == 0 ) = 0;
flag = sum(mask')>ratio*size(mask, 2);
for i = 1:length(flag)
    if flag(i) == 1
        I = I(i:end, :, :);
        flag = flag(i:end);
        break;
    end
end
for i = length(flag):-1:1
    if flag(i) == 1
        I = I(1:i, :, :);
        break;
    end
end
flag = sum(mask)>ratio*size(mask, 1);
for i = 1:length(flag)
    if flag(i) == 1
        I = I(:, i:end, :);
        flag = flag(i:end);
        break;
    end
end
for i = length(flag):-1:1
    if flag(i) == 1
        I = I(:, 1:i, :);
        break;
    end
end

end
