function [means] = fabo_projekt_gui
%% inicializace
clear all
close all
clc

%% vyber souboru

[FileName] = uigetfile({'*.tif'},'Vyberte snimky ve trech kanalech','MultiSelect','on');

a = imread(FileName{1,1});
if size(a,3)==4, a = a(:,:,1:3); end
meanA = [mean2(a(:,:,1)),mean2(a(:,:,2)),mean2(a(:,:,3))];
b = imread(FileName{1,2});
if size(b,3)==4, b = b(:,:,1:3); end
meanB = [mean2(b(:,:,1)),mean2(b(:,:,2)),mean2(b(:,:,3))];
c = imread(FileName{1,3});
if size(c,3)==4, c = c(:,:,1:3); end
meanC = [mean2(c(:,:,1)),mean2(c(:,:,2)),mean2(c(:,:,3))];

[~,maxA] = max(meanA);
[~,maxB] = max(meanB);
[~,maxC] = max(meanC);

switch maxA
    case 1
        imR = a;
    case 2
        imG = a;
    case 3
        imB = a;
end

switch maxB
    case 1
        imR = b;
    case 2
        imG = b;
    case 3
        imB = b;
end

switch maxC
    case 1
        imR = c;
    case 2
        imG = c;
    case 3
        imB = c;
end

% maxABC = [[~,I] = max(meanA),[~,I] = max(meanB),[~,I] = max(meanC)]

% obr = imread('obrazek31.jpg');
% obr = im2double(obr);
% obr = rgb2gray(obr);

% openfiles

% imR = imread('obrazek32.tif');
% 
% imG = imread('obrazek30.tif');
% 
% imB = imread('obrazek31.tif');
% 


[means] = fabo_projekt(imR,imG,imB);

end

