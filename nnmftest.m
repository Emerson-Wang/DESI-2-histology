xyzmat = spec2xyz(matxy,matspec);
ti = Tiff('kidney07histo.tif','r');
histo = read(ti);
%histo = imread('liver08histo.PNG');
%%{
% Flatten DESI image
flattendesi = [];
parfor ix = 1:size(xyzmat,1)
   for jx = 1:size(xyzmat,2)
       flattendesi = [flattendesi,reshape(xyzmat(ix,jx,:),[1000,1])];
   end
end
%%}
% Perform NMF on flattened DESI image
[m,n,~] = size(histo);
k = 10;
[W, H] = nnmf(flattendesi,k);
nnmfimage = zeros(size(xyzmat,1),size(xyzmat,2),3);
for ix = 1:size(xyzmat,1)
   for jx = 1:size(xyzmat,2)
       for kk = 1:3
          nnmfimage(ix,jx,kk) = reshape(xyzmat(ix,jx,:),[1,1000]) * W(:,kk+2);
       end
   end
end
nnmfimage(:, :, 1) = (nnmfimage(:,:,1)/max(max(nnmfimage(:,:,1)))).^2;
nnmfimage(:, :, 2) = (nnmfimage(:,:,2)/max(max(nnmfimage(:,:,2)))).^0.45;
nnmfimage(:, :, 3) = (nnmfimage(:,:,3)/max(max(nnmfimage(:,:,3)))).^0.45;

% CONVERT TO GREYSCALE
desigrey = rgb2gray(nnmfimage);
histogrey = rgb2gray(histo(:,:,1:3));
figure;
imshowpair(desigrey,histogrey,'montage');
% MAXIMIZE EDGE PIXELS FOR DESI
avgdesi = mean(mean(desigrey));
desigrey(desigrey<(0.4*avgdesi)) = 0;
avgdesi = mean(mean(desigrey));
desigrey(desigrey>(0.95*avgdesi)) = 1;
% MAXIMIZE EDGE PIXELS FOR HISTO
histogrey = imcomplement(histogrey);
highesthist = max(max(histogrey));
lowesthist = min(min(histogrey));
r = highesthist-lowesthist;
histogrey(histogrey-lowesthist>(0.350*r)) = highesthist;
% GET EDGES
edgedesi = edge(desigrey,'canny',[0.4,0.95]);
edgedesi = imresize(edgedesi,[m,n]);
edgehisto = edge(histogrey,'canny',[0.4,0.85],1);
% GET POINTS FROM BW IMAGES
pointsdesi = bw2points(edgedesi);
pointshisto = bw2points(edgehisto);
% PLOT THINGS
figure;
imshow(nnmfimage);
figure;
imshowpair(desigrey,histogrey,'montage');
figure;
imshowpair(edgedesi,edgehisto,'montage');
figure;
plot(pointsdesi(1,:), pointsdesi(2,:), 'bo'); hold on;
axis('manual');
plot(pointshisto(1,:), pointshisto(2,:), 'ro'); hold off;
drawnow;
clear n m ix jx kk v c W H k