%%Written by Vlora Riberdy

clear all

%Load the mat file and extract the data
ourdata = load('C:\Users\vlora\Documents\Overview of Medical Imaging\CT Lab- Group 2\Data\Group2_Section75_2.mat');

data = ourdata.data;
data_lowdose = ourdata.data_lowdose;
theta = ourdata.theta;
p = ourdata.p;

N = length(data);   %Find the length of the data set
l = 1:N;    %Create array with number of voxels
l = p*(l-(N/2));    %Calculate distances from the center (0 point)

%Plot the sinograms
imshow(data,[],'XData',theta,'YData',l);
axis square
axis on
figure 

imshow(data_lowdose,[],'XData',theta,'YData',l);
axis square 
axis on
figure

%%Reconstruct the image

%No Filter

filter1 = 'none';   %Set filter type

%Calculate the inverse radon transform and rescale the data according to 
%our voxel dimensions
mu1 = iradon(data, theta, 'linear', filter1, 1,512)*(1/p);
mu1_low = iradon(data_lowdose, theta, 'linear', filter1, 1,512);

%Show the image
imshow(mu1,[]);
figure

%Ram-Lak filter

filter2 = 'Ram-Lak';    %Set filter type

%Projections from 0 and 90

theta2 = [0,90];    %Set theta array
data_2 = [data(:,1), data(:,91)];   %Extract corresponding projection data
mu2 = iradon(data_2, theta2, 'linear', filter2, 1,512)*(1/p);

imshow(mu2, [], 'XData', r, 'YData',r)
figure

%Every fifteenth projection

a = 1:15:360;   %Extract every 15th index

for i = 1:length(a)
    theta3(i) = theta(a(i)) %Extract every 15th angle
    data_3(:,i) = data(:,a(i))  %Extract every 15th projection data set
end

mu3 = iradon(data_3,theta3,'linear',filter2,1,512)*(1/p);

imshow(mu3, 'XData', r, 'YData', r)
figure

%all projections

mu4 = iradon(data, theta, 'linear', filter2, 1, 512)*(1/p);

imshow(mu4,[],'XData',r,'YData',r)
figure
