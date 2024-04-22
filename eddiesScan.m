function [ eddies ] = eddiesScan( ssh, lat, lon, date, varargin)
%EDDIESSCAN for scan the ssh field to return a eddies sets which contains
% Create by Wang Zhuoyue at 2024/4/12
%OUTPUT:
% center: center lon and lat of the eddy Nx2
% cyc: cyclone type of the eddy Nx1
% r: radius of the eddy Nx1
% u: the speed of the eddy at average of the radius of r Nx1
% ID: eddy identifiy number Nx1
% date: eddy date Nx1
% Seq: eddy life time since in ssh Nx1
%INPUT:
% ssh: ssh(latxlonxtime), if only one slice in the 3rd dimension scan single
% lat: 1D array of the latitudes of ssh grid
% lon: 1D array of the longitudes of ssh grid
% date: 1D array of the time of ssh grid
% sst: sea surface temperature as the same time-space field as the ssh field
% u: eastward speed field as the same time-space field as the ssh field 
% v: northward speed field as the same time-space field as the ssh field
% SCAN TYPE:
% use the bottom-up scanning from the minima of the field

    % dynamic characters of eddies 
    % if the dimension of ssh is unequal to the lat, lon and date
    if ~all(size(ssh) == [length(lat) length(lon) length(date)])
        error('Invalid ssh data size');
    end 
    % add path
    addpath('../utils/')
    % scan ssh to get eddies
    % scan the 1st day
    eddies = singleSliceScan(ssh(:, :, 1), lat, lon);
    % intial the eddies: add ID, dates, and Seq
    eddies = initialEddy(eddies, date(1));
    % calculate the next day to update the eddies
    for i = 2:length(date)
        fprintf('start to scan eddies %d / %d\n', i, length(date));
        % calculate the new day eddy to update
        eddiesUpdate = singleSliceScan(ssh(:, :, i), lat, lon);
        % update the eddies
        eddies = eddyTrack(eddies, eddiesUpdate, date(i));
        fprintf('%d th day eddies updated sucessfully! Eddy numbers:%d\n', i, length(eddies));
    end

end 