function plot_match(I1, I2, coor_ref, coor_stitch, matching, name)

interval = 20;
II = [I2 repmat(ones(size(I2, 1), interval), [1 1 3]) I1];
% Fig = figure('Visible','off');
Fig = figure(101);
imshow(II/255);
hold on,
for i = 1:size(coor_stitch, 2)
    plot(coor_stitch(1, i)+size(I1, 2)+interval, coor_stitch(2, i), 'y+');
end
for i = 1:size(coor_ref, 2)
    plot(coor_ref(1, i), coor_ref(2, i), 'r+');
end
for i = 1:size(matching, 2)
    line([coor_stitch(1, matching(2, i))+size(I1, 2)+interval coor_ref(1, matching(1, i))], [coor_stitch(2, matching(2, i)) coor_ref(2, matching(1, i))]);
end
hold off
saveas(Fig, name, 'jpg');
close 101;
end