%%Written by Vlora Riberdy

clear all

%load and extract our data
ourdata = load('C:\Users\vlora\Documents\Overview of Medical Imaging\CT Lab- Group 2\Data\Group2_Section75_2.mat');

data_lowdose = ourdata.data_lowdose;
theta = ourdata.theta;
p = ourdata.p;

%set the filter type
filter1 = 'Ram-Lak';

%perform the inverse radon transform for varying frequency scales
mu1_low = iradon(data_lowdose, theta, 'linear', filter1, 0.2,512)*(1/p);
mu2_low = iradon(data_lowdose, theta, 'linear', filter1, 0.4,512)*(1/p);
mu3_low = iradon(data_lowdose, theta, 'linear', filter1, 0.6,512)*(1/p);
mu4_low = iradon(data_lowdose, theta, 'linear', filter1, 0.8,512)*(1/p);
mu5_low = iradon(data_lowdose, theta, 'linear', filter1, 1,512)*(1/p);

%display each of the images
imshow(mu1_low,[]);
figure

imshow(mu2_low,[]);
figure

imshow(mu3_low,[]);
figure

imshow(mu4_low,[]);
figure

imshow(mu5_low,[]);
figure