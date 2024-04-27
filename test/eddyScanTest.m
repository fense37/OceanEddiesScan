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
%% cut slice
sshp = ssh(320:480, 540:860, 1:12);
latp = lat(320:480);
lonp = lon(540:860);
% choose area lon value is uncontinus
lonp(lonp < 0) = lonp(lonp < 0) +360;
%% run the test function
s = eddiesScan(sshp, latp, lonp, dates(1:12));
%% show the result
[mlon, mlat] = meshgrid(lonp, latp); 
levels = [-50:1:50];
for t = 1:12

m_proj('mill','long',[min(mlon(:)),max(mlon(:))],'lat',[min(latp), max(latp)]); 

[CS, CH] = m_contourf(mlon, mlat, sshp(:,:,t), levels);
hold on;
for i = 1: length(s)
    track = s(i).center;
    m_plot(track(:,2), track(:,1), 'color','k','linewidth',3);
    hold on;
end
m_gshhs_c('patch',[0.7 0.7 0.7],'edgecolor','k');
m_coast('patch', [.7 .7 .7], 'edgecolor', 'none');
m_grid('linestyle', '-', 'box', 'fancy', 'fontsize', 10, 'gridcolor', 'k');
colormap jet;
caxis([-max(max(sshp(:,:,1))) max(max(sshp(:,:,1)))])  % 颜色设置
[ax, h] = m_contfbar([.3 .68], .1, CS, CH, 'endpiece', 'yes', 'axfrac', .02);  % colorbar
title([num2str(t)]);
end


