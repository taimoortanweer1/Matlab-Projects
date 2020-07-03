clear all;
close all; 

% Reading an image file


%X1=imread('D:\Work\FreelancerProjects\Image Compression\2.jpg');

for 
X1=imread('D:\Work\FreelancerProjects\Image Compression\CASIA-IrisV1\CASIA Iris Image Database\');

X = imresize(X1, [320 320]); 
X = imresize(X, 0.8); 
%[cratio,bpp] = wcompress('c',X,'1.wtc','spiht','maxloop',12);
%[cratio,bpp] = wcompress('c',X,'1.wtc','wdr');

[cratio,bpp] = wcompress('c',X,'1.wtc','spiht','cc','rgb','maxloop',11,'plotpar','step');
cratio
bpp
xc = wcompress('u','1.wtc','step');


