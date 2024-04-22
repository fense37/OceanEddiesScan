%%TEST the eddyThermoDynamicScan function
% Created by Wang Zhuoyue at 2024/4/22
clc,clear,close all
%% load the test Data
disp('DataLoading...');
dataFile = dir(fullfile('../testData', '*.mat'));
fnames = {dataFile.name};
ssh = [];
for i = 1:size(fnames, 2)
    fname = ['../testData/' strjoin(cellstr(fnames(i)))];
    if contains(fname, 'ssh')
        sshd = load(fname);
        ssh = cat(3, ssh, sshd.data);
    else
        load(fname);
    end
end
disp('Load complete!');
%% load the function
addpath('../utils/');
addpath('..');
%% cut slice
sshp = ssh(320:480, 540:860, 1:12);
% simluate sst data
sstp = sshp;
latp = lat(320:480);
lonp = lon(540:860);
% choose area lon value is uncontinus
lonp(lonp < 0) = lonp(lonp < 0) +360;
%% run the test function
s = eddiesScan(sshp, latp, lonp, dates);
s = eddiesThermoDynamicScan(sstp, latp, lonp, dates, s);
