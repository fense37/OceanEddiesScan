%%TEST the singleSliceScan function
% Created by Wang Zhuoyue at 2024/4/13
clc,clear,close all
%% load the test Data
disp('DataLoading...');
dataFile = dir(fullfile('../testData', '*.mat'));
fnames = {dataFile.name};
for i = 1:size(fnames, 2)
    fname = ['../testData/' strjoin(cellstr(fnames(i)))];
    load(fname);
end
disp('Load complete!');
%% load the function
addpath('../utils/');
%% run the test function
s = singleSliceScan(data, lat, lon);
%% viewing result
[mlon, mlat] = meshgrid(lon, lat);
contourf(mlat, mlon, data);shading interp;colorbar;
hold on;
for i = 1: 10
    scatter(s(i).center(1), s(i).center(2), '.');
    hold on;
end