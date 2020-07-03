clear all;
close all;

%input rgb image
im2 = imread('part1.jpg');

%convert rgb image to grayscale image (a)
I2 = rgb2gray(im2);


%Guassian kernel use for smoothing input image
h = fspecial('gaussian',2);
MotionBlur = imfilter(I2,h);

figure;
subplot(1,2,1);
imshow(MotionBlur);
title('Step 1 : Gaussian Kernel applied on original image');

%closing of result of image after smoothing
se = strel('disk',3);
closeBW = imclose(MotionBlur,se);

%figure;
subplot(1,2,2);
imshow(closeBW)
title('Step 2 : Closing of filtered image');

%again applying gaussian filter on the result of previous step
Ip = imfilter(closeBW,h);

figure;
subplot(1,2,1);
imshow(Ip);
title('Step 3 : Smoothing closed image again');

%converting gray to rgb image and replicating masks
rgbImage = repmat(Ip,[1 1 3]);
rgbImage = cat(3,Ip,Ip,Ip);


%loop for boundary scanning
%it is supposed that scar comes at an intensity of pixel less than 40
m = 150;
b = 0;
k = 40;


%loop 1 
for y=72:104 %y axis pixel range/location of kidney
    for x=17:65 %x axis pixel range/location of kidney
        
        %updating highest intensity pixel in kidney area which indicates kidney boundary
        if(Ip(x,y) > b) %if next intensity is greater than the previous, update
            b = Ip(x,y); 
        end
        
        %updating lowest intensity pixel in kidney area which indicates
        %kidney center
        if(Ip(x,y) < m)%if next intensity is less than the previous, update
            m = Ip(x,y);
        end    
        
        %comparing different intensities in kidney ares
        if(Ip(x,y) > 200 && Ip(x,y) < 255) %black color rgb values
            rgbImage(x,y,1) = 10;
            rgbImage(x,y,2) = 10;
            rgbImage(x,y,3) = 10;
        end
        
        if(Ip(x,y) > 120 && Ip(x,y) < 200)
            rgbImage(x,y,1) = 0;    %green color rgb values
            rgbImage(x,y,2) = 255;
            rgbImage(x,y,3) = 0;
        end
        
        if(Ip(x,y) > 60 && Ip(x,y) < 120)
            rgbImage(x,y,1) = 0; %blue color rgb values
            rgbImage(x,y,2) = 0;
            rgbImage(x,y,3) = 255;
        end
        
        if(Ip(x,y) > 30 && Ip(x,y) < 60)
            rgbImage(x,y,1) = 255;%yellow/orange color rgb values
            rgbImage(x,y,2) = 255;
            rgbImage(x,y,3) = 0;        
        end
        
        if(Ip(x,y) > 30 && Ip(x,y) < 40)
            rgbImage(x,y,1) = 255;%red color rgb values
            rgbImage(x,y,2) = 0;
            rgbImage(x,y,3) = 0;        
        end
        
        if(Ip(x,y) > 20 && Ip(x,y) < 30)
            rgbImage(x,y,1) = 255;
            rgbImage(x,y,2) = 0;
            rgbImage(x,y,3) = 0;        
        end
        
        if(Ip(x,y) > 0 && Ip(x,y) < 20)
            rgbImage(x,y,1) = 255;
            rgbImage(x,y,2) = 0;
            rgbImage(x,y,3) = 0;        
        end
        
    end
end

for y=227:262 %y axis pixel range/location of kidney
    for x=17:65 %x axis pixel range/location of kidney
        
        %updating highest intensity pixel in kidney area which indicates kidney boundary
        if(Ip(x,y) > b) %if next intensity is greater than the previous, update
            b = Ip(x,y); 
        end
        
        %updating lowest intensity pixel in kidney area which indicates
        %kidney center
        if(Ip(x,y) < m)%if next intensity is less than the previous, update
            m = Ip(x,y);
        end    
        
        %comparing different intensities in kidney ares
        if(Ip(x,y) > 200 && Ip(x,y) < 255) %black color rgb values
            rgbImage(x,y,1) = 10;
            rgbImage(x,y,2) = 10;
            rgbImage(x,y,3) = 10;
        end
        
        if(Ip(x,y) > 120 && Ip(x,y) < 200)
            rgbImage(x,y,1) = 0;    %green color rgb values
            rgbImage(x,y,2) = 255;
            rgbImage(x,y,3) = 0;
        end
        
        if(Ip(x,y) > 60 && Ip(x,y) < 120)
            rgbImage(x,y,1) = 0; %blue color rgb values
            rgbImage(x,y,2) = 0;
            rgbImage(x,y,3) = 255;
        end
        
        if(Ip(x,y) > 30 && Ip(x,y) < 60)
            rgbImage(x,y,1) = 255;%yellow/orange color rgb values
            rgbImage(x,y,2) = 255;
            rgbImage(x,y,3) = 0;        
        end
        
        if(Ip(x,y) > 30 && Ip(x,y) < 40)
            rgbImage(x,y,1) = 255;%red color rgb values
            rgbImage(x,y,2) = 0;
            rgbImage(x,y,3) = 0;        
        end
        
        if(Ip(x,y) > 20 && Ip(x,y) < 30)
            rgbImage(x,y,1) = 255;
            rgbImage(x,y,2) = 0;
            rgbImage(x,y,3) = 0;        
        end
        
        if(Ip(x,y) > 0 && Ip(x,y) < 20)
            rgbImage(x,y,1) = 255;
            rgbImage(x,y,2) = 0;
            rgbImage(x,y,3) = 0;        
        end
        
    end
end

for y=386:489 %y axis pixel range/location of kidney
    for x=17:65 %x axis pixel range/location of kidney
        
        %updating highest intensity pixel in kidney area which indicates kidney boundary
        if(Ip(x,y) > b) %if next intensity is greater than the previous, update
            b = Ip(x,y); 
        end
        
        %updating lowest intensity pixel in kidney area which indicates
        %kidney center
        if(Ip(x,y) < m)%if next intensity is less than the previous, update
            m = Ip(x,y);
        end    
        
        %comparing different intensities in kidney ares
        if(Ip(x,y) > 200 && Ip(x,y) < 255) %black color rgb values
            rgbImage(x,y,1) = 10;
            rgbImage(x,y,2) = 10;
            rgbImage(x,y,3) = 10;
        end
        
        if(Ip(x,y) > 120 && Ip(x,y) < 200)
            rgbImage(x,y,1) = 0;    %green color rgb values
            rgbImage(x,y,2) = 255;
            rgbImage(x,y,3) = 0;
        end
        
        if(Ip(x,y) > 60 && Ip(x,y) < 120)
            rgbImage(x,y,1) = 0; %blue color rgb values
            rgbImage(x,y,2) = 0;
            rgbImage(x,y,3) = 255;
        end
        
        if(Ip(x,y) > 30 && Ip(x,y) < 60)
            rgbImage(x,y,1) = 255;%yellow/orange color rgb values
            rgbImage(x,y,2) = 255;
            rgbImage(x,y,3) = 0;        
        end
        
        if(Ip(x,y) > 30 && Ip(x,y) < 40)
            rgbImage(x,y,1) = 255;%red color rgb values
            rgbImage(x,y,2) = 0;
            rgbImage(x,y,3) = 0;        
        end
        
        if(Ip(x,y) > 20 && Ip(x,y) < 30)
            rgbImage(x,y,1) = 255;
            rgbImage(x,y,2) = 0;
            rgbImage(x,y,3) = 0;        
        end
        
        if(Ip(x,y) > 0 && Ip(x,y) < 20)
            rgbImage(x,y,1) = 255;
            rgbImage(x,y,2) = 0;
            rgbImage(x,y,3) = 0;        
        end
        
    end
end


for y=545:579 %y axis pixel range/location of kidney
    for x=17:65 %x axis pixel range/location of kidney
        
        %updating highest intensity pixel in kidney area which indicates kidney boundary
        if(Ip(x,y) > b) %if next intensity is greater than the previous, update
            b = Ip(x,y); 
        end
        
        %updating lowest intensity pixel in kidney area which indicates
        %kidney center
        if(Ip(x,y) < m)%if next intensity is less than the previous, update
            m = Ip(x,y);
        end    
        
        %comparing different intensities in kidney ares
        if(Ip(x,y) > 200 && Ip(x,y) < 255) %black color rgb values
            rgbImage(x,y,1) = 10;
            rgbImage(x,y,2) = 10;
            rgbImage(x,y,3) = 10;
        end
        
        if(Ip(x,y) > 120 && Ip(x,y) < 200)
            rgbImage(x,y,1) = 0;    %green color rgb values
            rgbImage(x,y,2) = 255;
            rgbImage(x,y,3) = 0;
        end
        
        if(Ip(x,y) > 60 && Ip(x,y) < 120)
            rgbImage(x,y,1) = 0; %blue color rgb values
            rgbImage(x,y,2) = 0;
            rgbImage(x,y,3) = 255;
        end
        
        if(Ip(x,y) > 30 && Ip(x,y) < 60)
            rgbImage(x,y,1) = 255;%yellow/orange color rgb values
            rgbImage(x,y,2) = 255;
            rgbImage(x,y,3) = 0;        
        end
        
        if(Ip(x,y) > 30 && Ip(x,y) < 40)
            rgbImage(x,y,1) = 255;%red color rgb values
            rgbImage(x,y,2) = 0;
            rgbImage(x,y,3) = 0;        
        end
        
        if(Ip(x,y) > 20 && Ip(x,y) < 30)
            rgbImage(x,y,1) = 255;
            rgbImage(x,y,2) = 0;
            rgbImage(x,y,3) = 0;        
        end
        
        if(Ip(x,y) > 0 && Ip(x,y) < 20)
            rgbImage(x,y,1) = 255;
            rgbImage(x,y,2) = 0;
            rgbImage(x,y,3) = 0;        
        end
        
    end
end

for y=698:738 %y axis pixel range/location of kidney
    for x=17:65 %x axis pixel range/location of kidney
        
        %updating highest intensity pixel in kidney area which indicates kidney boundary
        if(Ip(x,y) > b) %if next intensity is greater than the previous, update
            b = Ip(x,y); 
        end
        
        %updating lowest intensity pixel in kidney area which indicates
        %kidney center
        if(Ip(x,y) < m)%if next intensity is less than the previous, update
            m = Ip(x,y);
        end    
        
        %comparing different intensities in kidney ares
        if(Ip(x,y) > 200 && Ip(x,y) < 255) %black color rgb values
            rgbImage(x,y,1) = 10;
            rgbImage(x,y,2) = 10;
            rgbImage(x,y,3) = 10;
        end
        
        if(Ip(x,y) > 120 && Ip(x,y) < 200)
            rgbImage(x,y,1) = 0;    %green color rgb values
            rgbImage(x,y,2) = 255;
            rgbImage(x,y,3) = 0;
        end
        
        if(Ip(x,y) > 60 && Ip(x,y) < 120)
            rgbImage(x,y,1) = 0; %blue color rgb values
            rgbImage(x,y,2) = 0;
            rgbImage(x,y,3) = 255;
        end
        
        if(Ip(x,y) > 30 && Ip(x,y) < 60)
            rgbImage(x,y,1) = 255;%yellow/orange color rgb values
            rgbImage(x,y,2) = 255;
            rgbImage(x,y,3) = 0;        
        end
        
        if(Ip(x,y) > 30 && Ip(x,y) < 40)
            rgbImage(x,y,1) = 255;%red color rgb values
            rgbImage(x,y,2) = 0;
            rgbImage(x,y,3) = 0;        
        end
        
        if(Ip(x,y) > 20 && Ip(x,y) < 30)
            rgbImage(x,y,1) = 255;
            rgbImage(x,y,2) = 0;
            rgbImage(x,y,3) = 0;        
        end
        
        if(Ip(x,y) > 0 && Ip(x,y) < 20)
            rgbImage(x,y,1) = 255;
            rgbImage(x,y,2) = 0;
            rgbImage(x,y,3) = 0;        
        end
        
    end
end

%figure;
subplot(1,2,2);
imshow(rgbImage);
title('Step 4 : Colors showing boundaries ');