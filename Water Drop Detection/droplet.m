close all;
clear all;

%read image - place images and code file the same folder
img = (imread('20190205_131506.jpg'));


%convert colored image to grayscale
img_gray = rgb2gray(img);

figure, imshow(img_gray);

%Filter image for easier edge detection
img_filter = img_gray;

%Edge detection - sharp edges in image are detected
[~, threshold] = edge(img_filter, 'canny');
fudgeFactor = 2.0;
img_edge = edge(img_filter, 'canny', threshold * fudgeFactor);
figure, imshow(img_edge), title('edge detection')


%create structuring element for filtering process
se_disk = strel('disk',10);

%Dilate image to make the droplet edges complete without a break, its like
%filing a pot-hole on the road with sand

img_dilated = imdilate(img_edge, se_disk);
figure, imshow(img_dilated), title('dilate')


% Remove stuff touching the image border and fill complete objects
img_clearborder = imclearborder(img_dilated, 4);

%all the connected rings/edges detected in above step are filled
img_fill = imfill(img_clearborder, 'holes');
figure, imshow(img_fill), title('fill holes')

% Erode image to make a clear cut between objects, two different droplets
se_diamond = strel('diamond',10);
img_erode = imerode(img_fill,se_diamond);
for k=1:3
    img_erode = imerode(img_erode,se_diamond);
end

%noisy objects corresponding to noise are removed
img_nosmall = bwareaopen(img_erode,200); % Remove small objects (noise)
figure, imshow(img_nosmall), title('erode')

[B, L] = bwboundaries(img_nosmall);
figure, imshow(label2rgb(L, @jet, [.5 .5 .5])), title('boundaries')

hold on
for k = 1:length(B)
  boundary = B{k};
  plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
end

%Area and centroid are retrieved using region props function
stats = regionprops(L,img(:,:,1),...
    'Area','Centroid','Orientation','EquivDiameter','Image','BoundingBox');


%printing area of drop 
 for k = 1:length(B)
     boundary = B{k};
          
     area = stats(k).Area;     
     area_string = sprintf('%2.2f',stats(k).Area);
     centroid = stats(k).Centroid;
     plot(centroid(1),centroid(2),'ko');
     
     text(boundary(1,2)-35,boundary(1,1)+13,area_string,'Color','y','FontSize',10,'FontWeight','bold');
     %text(area,'Color','y','FontSize',14,'FontWeight','bold');
 end
 
 






