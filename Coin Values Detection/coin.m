close all;
img = (imread('img2.jpg'));
%figure, imshow(img);
img_gray = rgb2gray(img);
%

% Filter image for easier edge detection
m = 12;
n = 12;
img_filter = imfilter(img_gray, fspecial('average', [m n]));
%figure, imshow(f), title('f')

% Edge detection
[~, threshold] = edge(img_filter, 'canny');
fudgeFactor = 1.5;
img_edge = edge(img_filter, 'canny', threshold * fudgeFactor);
figure, imshow(img_edge), title('edge detection')

%Dilate image to make the coin edges complete without holes
se_disk = strel('disk',4);
se_line1 = strel('line',3,100);
se_line2 = strel('line',3,100);
img_dilated = imdilate(img_edge, se_disk);
img_dilated = imdilate(img_dilated, [se_line1 se_line2]);
figure, imshow(img_dilated), title('dilate')

%img_dilated = img_edge;

% Remove stuff touching the image border and fill complete objects
img_clearborder = imclearborder(img_dilated, 4);
%figure, imshow(BWclear), title('cleared border image');
img_fill = imfill(img_clearborder, 'holes');
figure, imshow(img_fill), title('fill holes')

% Erode image to make a clear cut between objects
se_diamond = strel('diamond',10);
img_erode = imerode(img_fill,se_diamond);
for k=1:3
    img_erode = imerode(img_erode,se_diamond);
end
img_nosmall = bwareaopen(img_erode,500); % Remove small objects (noise)
figure, imshow(img_nosmall), title('erode')

[B, L] = bwboundaries(img_nosmall);
figure, imshow(label2rgb(L, @jet, [.5 .5 .5])), title('boundaries')
hold on
for k = 1:length(B)
  boundary = B{k};
  plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
end

stats = regionprops(L,img(:,:,1),...
    'Area','Centroid','Orientation','EquivDiameter','Image','BoundingBox');
threshold = 0.70; % For differentiating coins from matches based on an objects circularity

coinCentroids = [];
coinTypes = []; % 0 for one, 1 for two, 2 for five
coinValues = []; % 1, 2, 5
coinAreas = [];
silverCoinAreas = [];
goldCoinAreas = [];

matchCentroids = [];
matchAngles = [];
radiusRange = [8,40];

for k = 1:length(B)
    boundary = B{k};
    delta_sq = diff(boundary).^2;
    perimeter = sum(sqrt(sum(delta_sq,2)));
    area = stats(k).Area;
    metric = 4*pi*area/perimeter^2;
    metric_string = sprintf('%2.2f',metric);
    angle_string = sprintf('%2.2f',stats(k).Orientation);
    centroid = stats(k).Centroid;
    if metric > threshold
        % Object is round, therefore a coin
        coinValues = [coinValues; 0];
        coinAreas = [coinAreas; area];
        coinCentroids = [coinCentroids; centroid];
        bbox = stats(k).BoundingBox;
        im = imcrop(img,bbox);
        %figure, imshow(im);
        [centers,radii] = imfindcircles(im,radiusRange,'ObjectPolarity','bright');
        
            coinTypes = [coinTypes; 1];
            goldCoinAreas = [goldCoinAreas; area];
        %end

    else
        % Object is a match
        angle = stats(k).Orientation;
        matchCentroids = [matchCentroids; centroid];
        matchAngles = [matchAngles; angle];
    end

    %plot(centroid(1),centroid(2),'ko');
    % text(boundary(1,2)-35,boundary(1,1)+13,angle_string,'Color','y',...
    %   'FontSize',14,'FontWeight','bold');
    
    
end

oneThreshold = 0.65;
twoThreshold = 0.85;
fiveThreshold = 0.4;

maxGold = max(goldCoinAreas);
for k=1:length(coinTypes)
    area = coinAreas(k);
        %if area <= maxGold-maxGold*fiveThreshold            
        if area >= maxGold*twoThreshold            
            coinValues(k) = 2;
        elseif area >= maxGold*oneThreshold && area <= maxGold*twoThreshold                    
            coinValues(k) = 1;
        elseif area < maxGold*oneThreshold        
            coinValues(k) = 5;
        end    
end

% OUTPUT:
coinCentroids
coinValues
matchCentroids
matchAngles

TotalSum = sum(coinValues)


