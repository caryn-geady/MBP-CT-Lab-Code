%%Written by Vlora Riberdy

clear all

%Load the mat file
ourdata = load('C:\Users\vlora\Documents\Overview of Medical Imaging\CT Lab- Group 2\Data\XrayObject.mat');

object = ourdata.Object;
p = ourdata.p;

%Display the image
imshow(object,[])
axis square

%Calculate the total image length in cm
d = length(object)*p;

%Create the Radon Transform and rescale it for our voxel dimensions
[R1,xp] = radon(object,0);
R1 = R1/(1/p);

%Correct position
p1 = d/length(xp);
p2 = xp*p1;

%plot the radon transform
figure
plot(p2, R1)

%Create the sinogram
theta = 0:179;  %set the number f projections

S = radon(object, theta);
S = S/(1/p);    %rescale sinogram data for our voxel dimensions

%Display the sinogram
figure
imshow(S,[],'XData', theta,'YData', p2)
axis square
axis on 





