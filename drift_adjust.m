function I_drift = drift_adjust(I, I_p)    

total_drift = size(I_p, 1) - size(I, 1);
if total_drift >= 3
    I_drift = zeros(size(I, 1), size(I_p, 2), size(I_p, 3));
    idx = total_drift/size(I_p, 2) * (1:size(I_p, 2));
    for i = 1:size(I_p, 2)
        I_drift(:, i, :) = I_p(ceil(idx(i)):ceil(idx(i))+size(I, 1)-1, i, :);
    end
else
    I_drift = I_p;
end

end
