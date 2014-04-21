% 12 Stanoven� intenzity fluorescence n�dorov�ch bun�k
% Segmentace bun�k (prahov�n�, watershed), stanoven� pr�m�rn� intenzity v jednotliv�ch bu�k�ch
%% inicializace
clear all
close all
clc

%% nacteni obrazu
% obr = imread('obrazek31.jpg');
% obr = im2double(obr);
% obr = rgb2gray(obr);

%%Obr�zek 1

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

%% Obr�zek 2
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


% Sjednoceni rozmeru obrazu:
dims = zeros(3,2);
dims(1,:) = size(imR);      % Ulozeni rozmeru vsech obrazu
dims(2,:) = size(imG);
dims(3,:) = size(imB);

min_size = min(dims);       % Minimalni rozmery

imR = imR(1:min_size(1),1:min_size(2));   % Oriznuti obrazu na minimalni rozmery
imG = imG(1:min_size(1),1:min_size(2));
imB = imB(1:min_size(1),1:min_size(2));


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

% bw = im2bw(obr,0.55);        % prahovani obrazu - prvn� obraz
bw = im2bw(obr,0.65);        % prahovani obrazu - druh� obraz

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
