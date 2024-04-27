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
%% cut the field
latIndex = 360:480;
lonIndex = 720:960;
lat = lat(latIndex);
lon = lon(lonIndex);
lon(lon < 0) = lon(lon < 0) +360;
data = data(latIndex, lonIndex);
%% run the test function
s = singleSliceScan(data, lat, lon);
%% viewing result
[mlon, mlat] = meshgrid(lon, lat);
figure(1)
contourf(mlat, mlon, data);
hold on;
figure(2);
for i = 1:length(s)
    con = s(i).contour;
    edge = con{1};
    if s(i).cyc == 1
        c = 'b';
    else 
        c = 'r';
    end
    scatter(edge(1,:),edge(2,:), '.',c);
    hold on;
    center = s(i).center;
    scatter(center(1),center(2),'.','k');
    hold on;
end
ylim([min(mlon(:)), max(lon(:))]);xlim([min(mlat(:)), max(lat(:))])
