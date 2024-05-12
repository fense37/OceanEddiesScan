function [eddies] = singleSliceScan(ssh, lat, lon)
%SINGLESLICESCAN can scan the eddies in one slice of ssh
%Created by Wang Zhuoyue at 2024/4/12
%OUTPUT:
% eddies: a class of eddy which contains
% center: center lon and lat of the eddy Nx2
% cyc: cyclone type of the eddy Nx1
% date: eddy date Nx1
% ID: eddy identifiy number Nx1
% r: radius of the eddy Nx1
% Seq: eddy life time since in ssh Nx1
% u: the speed of the eddy at average of the radius of r Nx1
%INPUT:
% ssh: ssh(latxlonxtime), if only one slice in the 3rd dimension scan single
% lat: 1D array of the latitudes of ssh grid
% lon: 1D array of the longitudes of ssh grid

    % Basic parameter
    % min and max pixel criterion 
    % should change within different resolution
    minPixel = 8;
    maxPixel = 1000;
    minAmp   = 1;    % unit centimeter
    maxAmp   = 150;  % unit centimeter
    minError = 1e-4; 
    resolution = 0.25;  % data resolution
    warning('off', 'all');


    % filtering the ssh field
    ssha = ssh;
    % space filter
    lambda = 8;
    for k = 1:size(ssha,3)
        ssh0 = squeeze(ssha(:,:,k));
        ssha(:,:,k) = filt2(ssh0,resolution,lambda,'hp');
    end
    ssh = roundn(ssha,-2);
    % calculate the average length of each grid for ref
    dl = dLatLon(lat(1), lat(end), lon(1), lon(end)) / sqrt(length(lat)^2 + length(lon)^2);
    % 2d grid of lat and lon
    [mlon, mlat] = meshgrid(lon, lat);
    % land mask
    mask = ~isnan(ssh);
    % calculate the coutour
    s = contourData(ssh, lat, lon);


    % search the right coutour
    eddyNumber = 0;
    for i = 1: size(s, 2)
        % print very 10 times
        if mod(i, 100) == 0
            fprintf('Contour searching in %d/%d, Eddy Number = %d\r', i, size(s,2), eddyNumber);
        end 
        % calculate the area of the coutour
        % the lat and lon of the coutour
        slat = s(i).x;
        slon = s(i).y;
        % x and y distance from the first point
        sx = sign(slat-slat(1)) .* dLatLon(slat(1), slat, slon(1), slon(1));
        sy = sign(slon-slon(1)) .* dLatLon(slat(1), slat(1), slon(1), slon);
        % calculate the coutour area unit km2
        area = polyarea(sx, sy);
        % calculate the radius of the area unit km
        sr = sqrt(area / pi);
        % calculate the circle base on the centroid
        % calculate the pixel number
        inCircle = inpolygon(mlat, mlon, slat, slon);
        npixel = sum(inCircle(:));
        % calculate the eddy area
        infield = ssh .* inCircle;
        infield(~mask) = 0;
        % calculate the centroid
        centLat = sum(sum(infield .* mlat)) / sum(infield(:));
        centLon = sum(sum(infield .* mlon)) / sum(infield(:));
        % calculate the circle with the radius of sqrt(area/pi)
        res = dLatLon(mlat,centLat,mlon,centLon) - sr;
        % total points of circle
        circle =  abs(res) < dl;
        cn = sum(circle(:));
        [cirLatIndex, cirLonIndex] = find(circle);
        cirLat = lat(cirLatIndex);
        cirLon = lon(cirLonIndex);
        % if didnt find the circle point
        if cn == 0
            continue;
        end
        % calculate the overlaps
        [overLat, overLon] = overlaparea(slat, slon, cirLat, cirLon);
        % x and y distance from the first point
        if isempty(overLat)
            continue;
        end
        overx = sign(overLat-overLat(1)) .* dLatLon(overLat(1), overLat, overLon(1), overLon(1));
        overy = sign(overLon-overLon(1)) .* dLatLon(overLat(1), overLat(1), overLon(1), overLon);
        % calculate the overlaps area
        overArea = polyarea(overx, overy);
        % calculate the shape error
        % shape error <= 55%
        shapeError = 1 - overArea / area;
        % if shape error > 55%, seak the next coutour
        if shapeError > 0.55
            continue;
        end
        % if the pixel inside the coutour is between min and max
        if npixel > maxPixel || npixel < minPixel
            continue;
        end
        % amplitude search
        % cover the NaN value first
        peak = imregionalmax(abs(infield));
        % if not only one peak
        if sum(peak(:)) ~= 1
            continue;
        end
        % if the peak is beyond the max and min amplitude
        amp = infield(peak);
        if abs(amp) < minAmp || abs(amp) > maxAmp
            continue;
        end
        % calculate the center
        [mlon, mlat] = meshgrid(lon, lat);
        sCenter(1) = mlat(peak);
        sCenter(2) = mlon(peak);
        % calculate the cyclone 
        if amp < mean(infield(:))
            % if the ampltitude is smaller than the surrounding
            % it's a cyclone
            cyc = 1;
        else 
            % if the ampltitude is bigger than the surrounding
            cyc = -1;
        end
        % seak if there is an inside eddy
        j = 1;
        % if the eddy is inside other eddy
        isSmaller = 0;
        while j <= eddyNumber
            if abs(eddies(j).amp - amp)<minError && ...
               abs(eddies(j).center(1) - sCenter(1))<minError &&...
               abs(eddies(j).center(2) - sCenter(2))<minError &&...
               eddies(j).cyc == cyc
               if eddies(j).r < sr
                   eddies(j) = [];
                   eddyNumber = eddyNumber - 1;
                   j = j - 1;
               else 
                   isSmaller = 1;
               end
            end
            j = j + 1;
        end
        if isSmaller
            continue;
        end
        if size(slat, 1) ~= 1
            slat = slat';
            slon = slon';
        end  
        eddyNumber = eddyNumber + 1;
        eddies(eddyNumber).amp    = amp;
        eddies(eddyNumber).center = sCenter;
        eddies(eddyNumber).cyc    = cyc;
        eddies(eddyNumber).r      = sr;
        eddies(eddyNumber).contour = {[slat;slon]};
    end

    if eddyNumber == 0
        eddies = 0;
    end

    disp('Slice completed!');
end
