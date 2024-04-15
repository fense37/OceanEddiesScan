%%TEST the eddyScan function
% Created by Wang Zhuoyue at 2024/4/13
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
%% run the test function
sshp = ssh(320:480, 540:860, 1:12);
latp = lat(320:480);
lonp = lon(540:860);
s = eddiesScan(sshp, latp, lonp, dates(1:12));
