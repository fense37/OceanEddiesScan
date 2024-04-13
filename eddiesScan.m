function [ eddies ] = eddiesScan( ssh, lat, lon, date)
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
% SCAN TYPE:
% use the bottom-up scanning from the minima of the field

    % if the dimension of ssh is unequal to the lat, lon and date
    if ~all(size(ssh) == [length(lat) length(lon) length(date)])
        error('Invalid ssh data size');
    end 

    % scan ssh to get eddies
    for i = 1:length(date)
        fprintf('start to scan eddies %d\n', i);
        eddiesIDay    = singleSliceScan(ssh(:, :, i), lat, lon);
        eddiesCenter = cat(1,eddiesCenter, eddiesIDayCenter);
        eddiesCyc    = cat(1,eddiesCyc,    eddiesIDayCyc);
        eddiesR      = cat(1,eddiesR,      eddiesIDayR);
        eddiesU      = cat(1,eddiesU,      eddiesIDayU);
        eddiesID     = cat(1,eddiesID,     eddiesIDayID);
        eddiesDate   = cat(1,eddiesDate,   eddiesIDayDate);
        eddiesSeq    = cat(1,eddiesSeq,    eddiesIDaySeq);
    end

    % save data 
    save('eddies.mat','eddies');

end 