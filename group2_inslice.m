clear
dcmpath = genpath('\Users\Kenneth\Desktop\MBP\Overview of Medical Imaging\ct_lab\section8.1_q1');
file = '1.2.392.200036.9116.2.6.1.48.1221390955.1476842418.731678.dcm';
X = dicomread(file);
a = dicominfo(file);
p=a.SharedFunctionalGroupsSequence.Item_1.PixelMeasuresSequence.Item_1.PixelSpacing;
pz=a.SharedFunctionalGroupsSequence.Item_1.PixelMeasuresSequence.Item_1.SliceThickness;
disp([p(1) pz(1)])
X = squeeze(X);
cropsize = 40;
ROI = avgROI(X,100,250,cropsize,120);
%disp(ROI)
PSF = suppressbg(ROI,90);

PSF = double(PSF);
sz = size(PSF);
ar = 1/(5/sz(1));
ac = 1/(5/sz(2));
window = gausswin(sz(1),ar)*gausswin(sz(2),ac)';
disp(size(window))
cleanPSF = PSF.*window;
pix_size = p(1);
freq_pix = 1/((cropsize+1)*pix_size);

figure;
set(gca,'fontsize',10)
low_pt = -(cropsize/2)*pix_size;
up_pt = (cropsize/2)*pix_size;
x = linspace(low_pt,up_pt,sz(1));
y = linspace(low_pt,up_pt,sz(2));
[xi, yi] = meshgrid(low_pt:0.1:up_pt);
PSFi = interp2(x,y,cleanPSF,xi,yi);
subplot(1,2,1);
surf(xi,yi,PSFi,'Edgecolor','None');
colormap bone;
colorbar();
set(gca,'XTick',[-5 -4 -3 -2 -1 0 1 2 3 4 5])
%set(gca,'YTick',[-5 -4 -3 -2 -1 0 1 2 3 4 5])
xlim([-5 5])
ylim([-5 5])
title('Point Spread Function of in-slice')
xlabel('x-axis (mm)')
ylabel('y-axis (mm)')
view(2);

xi_mid = floor(size(xi)/2)+1;
yi_mid = floor(size(yi)/2)+1;
PSF_x = PSFi(yi_mid(1),:);
PSF_y = PSFi(:,xi_mid(1));
xi_x = xi(xi_mid(1),:);
yi_y = yi(:,yi_mid(1));
disp(yi_y)
%disp(PSFi)
subplot(1,2,2);
plot(xi_x,PSF_x,'g',yi_y,PSF_y,'b');
xlim([-2 2]);
xlabel('principle axis (mm)');
ylabel('PSF');
title('PSF along the two principle axes');
legend('PSF_x','PSF_y');

FTimg = abs(fft2(cleanPSF));
norm_FTimg = fftshift(FTimg)/FTimg(1,1);
finalMTF = correctMTF(norm_FTimg,freq_pix);
low_ptf = -1/(2*pix_size);
up_ptf = 1/(2*pix_size);
figure;
set(gca,'fontsize',10)
x2 = linspace(low_ptf,up_ptf,sz(1));
y2 = linspace(low_ptf,up_ptf,sz(2));
[x2i, y2i] = meshgrid(low_ptf:0.05:up_ptf);
finalMTFi = interp2(x2,y2,finalMTF,x2i,y2i);
subplot(1,2,1);
surf(x2i,y2i,finalMTFi,'Edgecolor','None');
colormap bone;
colorbar();
%set(gca,'XTick',[-5 -4 -3 -2 -1 0 1 2 3 4 5])
%set(gca,'YTick',[-5 -4 -3 -2 -1 0 1 2 3 4 5])
xlim([-1/(2*pix_size) 1/(2*pix_size)])
ylim([-1/(2*pix_size) 1/(2*pix_size)])
title('MTF of cross-slice')
xlabel('x frequency (1/mm)')
ylabel('y frequency (1/mm)')
view(2);

x2i_mid = floor(size(x2i)/2)+1;
y2i_mid = floor(size(y2i)/2)+1;
MTF_x = finalMTFi(y2i_mid(1),:);
MTF_y = finalMTFi(:,x2i_mid(1));
x2i_x = x2i(x2i_mid(1),:);
y2i_y = y2i(:,y2i_mid(1));
disp(x2i_mid+1)
%disp(PSFi)
subplot(1,2,2);
plot(x2i_x,MTF_x,'g',y2i_y,MTF_y,'b');
xlim([low_ptf up_ptf]);
xlabel('principle axis (1/mm)');
ylabel('MTF');
title('MTF along the two principle axes');
legend('MTF_x','MTF_y');