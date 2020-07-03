function Out = imagecompression(x,n,wname)
% Wavelet image compression - RGB images
%DWT
%clear all;
%close all;  

% Reading an image file
%X=imread('Hough\CASIA Iris Image Database (version 1.0)\001\1\001_1_1.bmp');

% inputting the decomposition level and name of the wavelet
%n=input('Enter the decomposition level');

%wname = input('Enter the name of the wavelet');

x = double(x);
NbColors = 255;
map = gray(NbColors);
x = uint8(x);

% A wavelet decomposition of the image
%wname = 'haar';
[c,s] = wavedec2(x,n,wname);

% wdcbm2 for selecting level dependent thresholds  
alpha = 1.5; m = 2.7*prod(s(1,:));
[thr,nkeep] = wdcbm2(c,s,alpha,m)

% Compression
[xd,cxd,sxd,perf0,perfl2] = wdencmp('lvd',c,s,wname,n,thr,'h');
disp('Compression Ratio');
disp(perf0);


% Decompression
R = waverec2(c,s,wname);
 rc = uint8(R);
Out = xd;
% Plot original and compressed images.
subplot(221), image(x); 
colormap(map); 
title('Original image')
subplot(222), image(xd); 
colormap(map);
title('Compressed image')

% Displaying the results
xlab1 = ['2-norm rec.: ',num2str(perfl2)];
xlab2 = [' %  -- zero cfs: ',num2str(perf0), ' %'];
xlabel([xlab1 xlab2]);
subplot(223), image(rc); 
colormap(map);
title('Reconstructed image');

% Computing the image size
disp('Original Image');
imwrite(x,'original.tif');
imfinfo('original.tif')
disp('Compressed Image');
imwrite(xd,'compressed.tif');
imfinfo('compressed.tif')
disp('Decompressed Image');
imwrite(rc,'decompressed.tif');
imfinfo('decompressed.tif')
 








