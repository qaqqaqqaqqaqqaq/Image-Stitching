function [M] = LK(M_ori, I, I_g)

p = [M_ori(1,1); M_ori(1,2); M_ori(2,1); M_ori(2,2); M_ori(1,3); M_ori(2,3)];

Error = I - I_g;
[Ix Iy] = gradient(I);

Jx = repmat(1:1:size(I, 2), [size(I, 1) 1]);
Jy = repmat((1:1:size(I, 1))', [1 size(I, 2)]);

JdotI(:,1) = reshape(Ix .* Jx, [size(I, 1)*size(I, 2) 1]);
JdotI(:,2) = reshape(Ix .* Jy, [size(I, 1)*size(I, 2) 1]);
JdotI(:,3) = reshape(Iy .* Jx, [size(I, 1)*size(I, 2) 1]);
JdotI(:,4) = reshape(Iy .* Jy, [size(I, 1)*size(I, 2) 1]);
JdotI(:,5) = reshape(Ix,size(Ix,1) .* size(Ix,2),1);
JdotI(:,6) = reshape(Iy,size(Iy,1) .* size(Iy,2),1);

Hessian = JdotI' * JdotI;

del_p = inv(Hessian)*JdotI'*reshape(Error,size(Error,1)*size(Error,2),1);

p = del_p + p;

M = [p(1) p(2) p(5); p(3) p(4) p(6); M_ori(3,1) M_ori(3,2) 1];
end