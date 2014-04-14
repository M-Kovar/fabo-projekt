clear all
close all
clc

%% nacteni obrazu
% obr = imread('obrazek31.jpg');
% obr = im2double(obr);
% obr = rgb2gray(obr);

%jen zkousim jak ta pejcovina funguje - bez diakritiky 
imR = imread('obrazek32.jpg');
imR = rgb2gray(imR);
imR = im2double(imR);
imG = imread('obrazek30.jpg');
imG = rgb2gray(imG);
imG = im2double(imG);
imG = [imG,zeros(531,1)];
imB = imread('obrazek31.jpg');
imB = rgb2gray(imB);
imB = im2double(imB);

obr3(:,:,1) = imR;
obr3(:,:,2) = imG;
obr3(:,:,3) = imB;

% close all

% obr = mean(obr3,3);
% figure
% imshow(obr,[])
% 
obr = max(obr3,[],3);
% figure
% imshow(obr,[])



obr = histeq(obr);          % ekvalizace histogramu

figure
subplot(221)
imshow(obr);
title('originalni obraz')

bw = im2bw(obr,0.5);        % prahovani obrazu

subplot(222)
imshow(bw);
title('prahovany obraz')

SE = strel('diamond',1);
bw = imerode(bw,SE);        % vyhlazeni hran obrazu

subplot(223)
imshow(bw)
title('vyhlazene hrany')

bwd = -bwdist(~bw);         % vytvoreni distancni mapy

h = fspecial('gaussian',[10 10],5); 
bwd = filter2(h, bwd);


subplot(224)
imshow(bwd,[])
title('distancni mapa')

bwl = watershed(bwd,8);     % watershed

figure
imshow(bwd,[])

figure
imshow(bwl,[])
title('vysledek watershedu')

bwl = double(bwl);          % prevod na double

bwl = bwl.*bw;              % nasobeni labelu s bunkami

figure
imshow(label2rgb(bwl,'jet','w'))
title('bunky s labely')

imR = imread('obrazek32.jpg');
imR = rgb2gray(imR);
imR = im2double(imR);
imG = imread('obrazek30.jpg');
imG = rgb2gray(imG);
imG = im2double(imG);
imG = [imG,zeros(531,1)];
imB = imread('obrazek31.jpg');
imB = rgb2gray(imB);
imB = im2double(imB);



means = [];
for n = 1:max(max(bwl))
%     tempR
    meanR = mean2(imR.*(bwl==n));    
    meanG = mean2(imG.*(bwl==n));
    meanB = mean2(imB.*(bwl==n));
    means = [means;
             n, meanR, meanG, meanB];
end


figure
bar(means(:,2:4),'stacked');
title('Stack')

% ostranit okrajove bunky?
% nevadi prevod na sedotonovy?
% vyresit nacitani TIFFu
