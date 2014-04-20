% 12 Stanovení intenzity fluorescence nádorových bunìk
% Segmentace bunìk (prahování, watershed), stanovení prùmìrné intenzity v jednotlivých buòkách
%% inicializace
clear all
close all
clc

%% nacteni obrazu
% obr = imread('obrazek31.jpg');
% obr = im2double(obr);
% obr = rgb2gray(obr);

imR = imread('obrazek32.jpg');
imR = rgb2gray(imR);
imR = im2double(imR);

imG = imread('obrazek30.jpg');
imG = rgb2gray(imG);
imG = im2double(imG);
imG = [imG,zeros(531,1)];       % pridani radku nul, aby rozmery odpovidaly zbyvajicim obrazum

imB = imread('obrazek31.jpg');
imB = rgb2gray(imB);
imB = im2double(imB);

%% upravy obrazu, detekce bunek na bazi fluorescence

obr3(:,:,1) = imR;      
obr3(:,:,2) = imG;
obr3(:,:,3) = imB;

obr = max(obr3,[],3);

obr = histeq(obr);          % ekvalizace histogramu

figure
subplot(221)
imshow(obr);
title('originalni obraz')

bw = im2bw(obr,0.55);        % prahovani obrazu

subplot(222)
imshow(bw);
title('prahovany obraz')

SE = strel('diamond',1);
bw = imerode(bw,SE);        % vyhlazeni hran obrazu

subplot(223)
imshow(bw)
title('vyhlazene hrany')

bwd = -bwdist(~bw);         % vytvoreni distancni mapy

h = fspecial('gaussian',[15 15],5); 
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
