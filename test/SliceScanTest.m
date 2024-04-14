%%TEST the singleSliceScan function
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
%% run the test function
s = singleSliceScan(data, lat, lon);