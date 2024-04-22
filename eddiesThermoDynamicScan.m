function [ eddies ] = eddiesThermoDynamicScan(sst, lat, lon, date, eddies)
%EDDIESTHERMODYNAMICSACN is a function that scan the eddies thermal character 
%INPUT:
% sst: sea surface temperature
% lat: 1D array of the latitudes of sst grid
% lon: 1D array of the longitudes of sst grid
% date: 1D array of the time of sst grid
% eddies: a cell contains the following elements
% center: center lon and lat of the eddy Nx2
% cyc: cyclone type of the eddy Nx1
% r: radius of the eddy Nx1
% u: the speed of the eddy at average of the radius of r Nx1
% ID: eddy identifiy number Nx1
% date: eddy date Nx1
% Seq: eddy life time since in ssh Nx1
%OUPUT:
% eddies: a cell contains the following elements
% center: center lon and lat of the eddy Nx2
% cyc: cyclone type of the eddy Nx1
% r: radius of the eddy Nx1
% u: the speed of the eddy at average of the radius of r Nx1
% ID: eddy identifiy number Nx1
% date: eddy date Nx1
% Seq: eddy life time since in ssh Nx1
% TC: thermal character of the eddy Warm or Cold

    % thermal dynamic detection
    % if the dimension of sst is unequal to the lat, lon and date
    if ~all(size(sst) == [length(lat) length(lon) length(date)])
        error('Invalid sst data size');
    end 
    % filtering the sst field
    ssta = sst;
    % space filter
    resolution = 0.25;  % data resolution
    lambda = 8;
    for k = 1:size(ssta,3)
        sst0 = squeeze(ssta(:,:,k));
        ssta(:,:,k) = filt2(sst0,resolution,lambda,'hp');
    end
    sst = roundn(ssta,-2);
    
    % identify thermo dynamics basic on sst field
    for i = 1:length(eddies)
        track = eddies(i).center;
        tracktime = eddies(i).date;
        trackCold = zeros(size(track, 1), 1);
        if mod(i, 10) == 0
            fprintf('Scanning the %dth eddies, total eddies amount: %d\n', i, length(eddies));
        end
        for j = 1:length(tracktime);
            % if none of given date contains the tracktime
            if ~any(date == tracktime(j))
                trackCold(j) = NaN;
                continue;
            end
            center = track(j, :);
            % the index of the eddy center
            [~, latIndex] = min(abs(lat - center(1)));
            [~, lonIndex] = min(abs(lon - center(2)));
            % use the sst around the center to judge if it's a warm or cold core
            flat = latIndex-1:latIndex+1;
            if flat(1) == 0
                flat = flat + 1;
            else
                if flat(end) == length(lat)+1
                    flat = flat - 1;
                end
            end
            flon = lonIndex-1:lonIndex+1;
            if flon(1) == 0
                flon = flon + 1;
            else
                if flon(end) == length(lon)+1
                    flon = flon - 1;
                end
            end
            fsst = sst(flat, flon, date==tracktime(j));
            q = nanmean(fsst(:));
            if sst(latIndex, lonIndex, date==tracktime(j)) < q
                % if the center temperature is lower than the surrounding
                trackCold(j) = 1;
            else
                trackCold(j) = -1;
            end
        end
        eddies(i).Cold = trackCold;
    end


end