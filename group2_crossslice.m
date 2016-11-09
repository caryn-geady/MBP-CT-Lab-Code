clear
%dcmpath = genpath('/Users/maxzheng/Documents/Current Projects/Kenneth Chu/Kenneth CT lab/1.2.392.200036.9116.2.6.1.48.1221390955.1476842418.731678.dcm');
dcmpath = genpath('\Users\Kenneth\Desktop\MBP\Overview of Medical Imaging\ct_lab\');
file = '1.2.392.200036.9116.2.6.1.48.1221390955.1476929416.292715.dcm';
X = dicomread(file);
X = squeeze(X);
a = dicominfo(file);
p=a.SharedFunctionalGroupsSequence.Item_1.PixelMeasuresSequence.Item_1.PixelSpacing;
pz=a.SharedFunctionalGroupsSequence.Item_1.PixelMeasuresSequence.Item_1.SliceThickness;
disp([p(1) pz(1)])
cropsize = 40;

ROI = avgROI_cs(X,200,300,cropsize,120);
PSF = suppressbg_cs(ROI,90);
%PSF = PSF/PSF(21,21);
PSF = double(PSF);
sz = size(PSF);
ar = 1/(6/sz(1));
ac = 1/(3/sz(2));
window = gausswin(sz(1),ar)*gausswin(sz(2),ac)';
disp(size(window))
cleanPSF = PSF.*window;
pix_size = p(1);
pix_depth = pz(1);
freq_y = 1/((cropsize+1)*pix_size);
freq_z = 1/((cropsize+1)*pix_depth);
figure;
set(gca,'fontsize',10)
low_pt_z = -(cropsize/2)*pix_depth;
up_pt_z = (cropsize/2)*pix_depth;
low_pt_y = -(cropsize/2)*pix_size;
up_pt_y = (cropsize/2)*pix_size;
%imshow(cleanPSF, [80 200], 'XData', low_pt:10:up_pt, 'YData', low_pt:10:up_pt);
%axis on;
y = linspace(low_pt_y, up_pt_y, sz(1));
z = linspace(low_pt_z, up_pt_z, sz(2));
[yi, zi] = meshgrid(low_pt_y:0.1:up_pt_y, low_pt_z:0.1:up_pt_z);
PSFi = interp2(y,z,PSF,yi,zi);
subplot(1,2,1);
surf(yi*(pz(1)/p(1)),zi*(p(1)/pz(1)),PSFi,'Edgecolor','None');
grid off;
xlim([-5 5]);
ylim([-5 5]);
set(gca,'XTick',[-5 -4 -3 -2 -1 0 1 2 3 4 5])
%set(gca,'YTick',[-5 -4 -3 -2 -1 0 1 2 3 4 5])
title('Point Spread Function of cross-slice')
xlabel('z-axis (mm)')
ylabel('y-axis (mm)')
colormap bone;
colorbar();
view(2);

zi_mid = floor(size(zi)/2)+1;
yi_mid = floor(size(yi)/2)+1;
PSF_z = PSFi(:,yi_mid(2));
PSF_y = PSFi(zi_mid(1),:);
zi_z = zi(:,zi_mid(1));
yi_y = yi(yi_mid(2),:);
%disp(zi_mid+1)
disp([size(zi_z) size(PSF_z)])
disp(PSFi)
disp([yi_mid(2) zi_mid(1)])
subplot(1,2,2);
plot(zi_z*(p(1)/pz(1)),PSF_z,'g',yi_y*(pz(1)/p(1)),PSF_y,'b');
xlim([-5 5]);
set(gca,'XTick',[-5 -4 -3 -2 -1 0 1 2 3 4 5])
xlabel('principle axis (mm)');
ylabel('PSF');
title('PSF along the two principle axes');
legend('PSF_y','PSF_z');

FTimg = abs(fft2(PSF));
norm_FTimg = fftshift(FTimg)/FTimg(2,2);
finalMTF = correctMTF_cs(norm_FTimg,freq_y,freq_z);
low_ptf_y = -1/(2*pix_size);
up_ptf_y = 1/(2*pix_size);
low_ptf_z = -1/(2*pix_depth);
up_ptf_z = 1/(2*pix_depth);
figure;
set(gca,'fontsize',10)
y2 = linspace(low_ptf_y,up_ptf_y,sz(1));
z2 = linspace(low_ptf_z,up_ptf_z,sz(2));
[y2i, z2i] = meshgrid(low_ptf_y:0.05:up_ptf_y,low_ptf_z:0.05:up_ptf_z);
finalMTFi = interp2(y2,z2,finalMTF,y2i,z2i);
subplot(1,2,1);
surf(y2i*(p(1)/pz(1)),z2i*(pz(1)/p(1)),finalMTFi,'Edgecolor','None');
colormap bone;
colorbar();
%set(gca,'XTick',[-5 -4 -3 -2 -1 0 1 2 3 4 5])
%set(gca,'YTick',[-5 -4 -3 -2 -1 0 1 2 3 4 5])
xlim([low_ptf_z up_ptf_z])
ylim([-1 1])
title('MTF of cross-slice')
xlabel('z frequency (1/mm)')
ylabel('y frequency (1/mm)')
view(2);

z2i_mid = floor(size(z2i)/2)+1;
y2i_mid = floor(size(y2i)/2)+1;
MTF_z = finalMTFi(:,y2i_mid(2));
MTF_y = finalMTFi(z2i_mid(1),:);
z2i_z = z2i(:,z2i_mid(1));
y2i_y = y2i(y2i_mid(2),:);
disp(z2i_mid+1)
%disp(PSFi)
subplot(1,2,2);
plot(z2i_z*(pz(1)/p(1)),MTF_z,'g',y2i_y*(p(1)/pz(1)),MTF_y,'b');
xlim([-1.25 1.25]);
xlabel('principle axis (1/mm)');
ylabel('MTF');
title('MTF along the two principle axes');
legend('MTF_y','MTF_z');