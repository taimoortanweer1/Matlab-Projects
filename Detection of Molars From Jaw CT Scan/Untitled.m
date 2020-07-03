clear all;
k=1; % indice pour la numérotation des images
I=imread('img2.png');
figure(k)
k=k+1;
imshow(I);
I_hsv=rgb2hsv(I);
figure(k)
k=k+1;
imshow(I_hsv);
I_h=I_hsv(:,:,1);
I_s=I_hsv(:,:,2);
I_v=I_hsv(:,:,3);
figure(k)
k=k+1;
imshow(I_h)
figure(k)
k=k+1;
imshow(I_s)
figure(k)
k=k+1;
imshow(I_v)
%%Hue
[Gx, Gy] = imgradientxy(I_h);
[Gmag, Gdir] = imgradient(Gx, Gy);
% figure(k);
% k=k+1;
% imshowpair(Gmag, Gdir, 'montage');
I_bw1=Gmag>mean(quantile(Gmag,0.99));
figure(k);
k=k+1;
imshowpair(Gmag,I_bw1,'montage');
%%Saturation
[Gx, Gy] = imgradientxy(I_s);
[Gmag, Gdir] = imgradient(Gx, Gy);
% figure(k);
% k=k+1;
% imshowpair(Gmag, Gdir, 'montage');
I_bw2=Gmag>mean(quantile(Gmag,0.99));
figure(k)
k=k+1;
imshowpair(Gmag,I_bw2,'montage');
%%Variance
[Gx, Gy] = imgradientxy(I_v);
[Gmag, Gdir] = imgradient(Gx, Gy);
% figure(k);
% k=k+1;
% imshowpair(Gmag, Gdir, 'montage');
I_bw3=Gmag>mean(quantile(Gmag,0.99)); % choisir le bon quantile
figure(k)
k=k+1;
imshowpair(Gmag,I_bw3,'montage');
%%Addition images du gradient
I_recomp=I_bw1+I_bw2+I_bw3;
figure(k);
k=k+1;
imshow(I_recomp);
%%Dilatation - fill - erosion
% Element structurant diamond
% Dilatation
SE=strel('octagon',3); % doit être un multiple de 3 !
I_dil=imdilate(I_recomp,SE);
% figure(k)
% k=k+1;
% imshow(I_dil);
% Fill
I_fill=imfill(I_dil,'holes');
% Erosion
I_er=imerode(I_fill,SE);
% figure(k)
% k=k+1;
% imshow(I_er);
%%Elimination du bruit en appliquant un imerode <taille minimale des plastiques en pixels
% Erosion - dilatation
SE=strel('octagon',6); % mesurer la taille maximale d'un plastic en pixel avec imdistline !
I_bruit=imdilate(imerode(I_er,SE),SE);
figure(k)
k=k+1;
imshow(I_bruit);
%%Séparation des particules avec watershed
I_bwdist=-bwdist(~I_bruit);
figure(k);
k=k+1;
imshow(I_bwdist,[]);
I_water=watershed(I_bwdist);
I_bruit(I_water==0)=0;
figure(k);
k=k+1;
imshow(I_bruit);
%%Comptage des particules
cc=bwconncomp(I_bruit);
cc.NumObjects
L=labelmatrix(cc);
RGB_label=label2rgb(L);
figure(k);
k=k+1;
imshow(RGB_label);