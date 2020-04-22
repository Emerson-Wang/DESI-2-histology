function [pointcloud] = bw2points(im)
    pointcloud = [];
    for ix = 1:size(im,1)
        for jx = 1:size(im,2)
            if(im(ix,jx) == max(max(im)))
                pointcloud = [pointcloud, [jx; -ix]];
            end
        end
    end