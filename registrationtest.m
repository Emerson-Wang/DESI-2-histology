[TY, B, t] = emregister(pointsdesi,pointshisto, false);
tform = affine2d([B(1,:),0;B(2,:),0;t(1),t(2),1]);
newim = imwarp(histo(:,:,1:3), tform);
figure;
imshow(newim);
%{
tform = affine2d([B(1,:),0;B(2,:),0;0,0,1]);
Nm = B*pointsdesi + t;
figure;
plot(Nm(1,:), Nm(2,:), 'ro'); hold off;
tDesi = imwarp(desi, tform);
figure;
imshow(desi);
figure;
imshow(tDesi);
figure
imshow(histo(:,:,1:3));
%}