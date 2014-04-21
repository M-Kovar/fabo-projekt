% 12 Stanovenï¿½ intenzity fluorescence nï¿½dorovï¿½ch bunï¿½k
% Segmentace bunï¿½k (prahovï¿½nï¿½, watershed), stanovenï¿½ prï¿½mï¿½rnï¿½ intenzity v jednotlivï¿½ch buï¿½kï¿½ch
%% inicializace
clear all
close all
clc

%% nacteni obrazu
% obr = imread('obrazek31.jpg');
% obr = im2double(obr);
% obr = rgb2gray(obr);

%%Obrázek 1

% imR = imread('obrazek32.tif');
% if size(imR,3)==4, imR = imR(:,:,1:3); end    % Umazani 4. rozmeru tiffu
% imR = rgb2gray(imR);
% imR = im2double(imR);
% 
% imG = imread('obrazek30.tif');
% if size(imG,3)==4, imG = imG(:,:,1:3); end
% imG = rgb2gray(imG);
% imG = im2double(imG);
% imG = [imG,zeros(531,1)];       % pridani radku nul, aby rozmery odpovidaly zbyvajicim obrazum
% 
% imB = imread('obrazek31.tif');
% if size(imB,3)==4, imB = imB(:,:,1:3); end
% imB = rgb2gray(imB);
% imB = im2double(imB);

%% Obrázek 2
imR = imread('obrazek36.tif');
if size(imR,3)==4, imR = imR(:,:,1:3); end    % Umazani 4. rozmeru tiffu
imR = rgb2gray(imR);
imR = im2double(imR);

imG = imread('obrazek34.tif');
if size(imG,3)==4, imG = imG(:,:,1:3); end
imG = rgb2gray(imG);
imG = im2double(imG);
% imG = [imG,zeros(531,1)];       % pridani radku nul, aby rozmery odpovidaly zbyvajicim obrazum

imB = imread('obrazek35.tif');
if size(imB,3)==4, imB = imB(:,:,1:3); end
imB = rgb2gray(imB);
imB = im2double(imB);
imB = imB(1:532,1:708);


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

% bw = im2bw(obr,0.55);        % prahovani obrazu - první obraz
bw = im2bw(obr,0.65);        % prahovani obrazu - druhý obraz

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
