%%TEST the contourData function
% Created by Wang Zhuoyue at 2024/4/13
clc,clear,close all
%% load the test Data
dataFile = dir(fullfile('../testData', '*.mat'));
fnames = {dataFile.name};
for i = 1:size(fnames, 2)
    fname = ['../testData/' strjoin(cellstr(fnames(i)))];
    load(fname);
end
%% load the function
addpath('../utils/');
%% run the contourData function
s = contourData(data, lat, lon);
%% plot the contourData points
parfor i = 1:size(s, 2)
    if ~s(i).isopen
        scatter(s(i).x, s(i).y,'.');
        hold on;
    end
end
        
