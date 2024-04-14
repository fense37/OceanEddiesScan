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

    % calculate the average length of each grid for ref
    dl = dLatLon(lat(1), lat(end), lon(1), lon(end)) / sqrt(length(lat)^2 + length(lon)^2);
    % calculate the coutour
    s = contourData(ssh, lat, lon);
    % search the right coutour
    eddyNumber = 0;
    for i = 1: size(s, 2)
        % calculate the area of the coutour
        % the lat and lon of the coutour
        slat = s(i).x;
        slon = s(i).y;
        % the centroid of the coutour
        centLat = 0;
        centLon = 0;
        for j = 1:length(slat)
            % x and y distance from the first point
            sx(j) = sign(slat(j)-slat(1)) * dLatLon(slat(1), slat(j), slon(1), slon(1));
            sy(j) = sign(slon(j)-slon(1)) * dLatLon(slat(1), slat(1), slon(1), slon(j));
            % lat and lon index to find ssh point
            [~, latIndex] = min(abs(lat - slat(j)));
            [~, lonIndex] = min(abs(lon - slon(j)));
            % calculate the centroid
            centLat = centLat + ssh(latIndex, lonIndex) * slat(j);
            centLon = centLon + ssh(latIndex, lonIndex) * slon(j);
        end
        % calculate the centroid
        centLat = centLat / (sum(slat));
        centLon = centLon / (sum(slon));
        % calculate the coutour area unit km2
        area = polyarea(sx, sy);
        % calculate the radius of the area unit km
        sr = sqrt(area / pi);
        % calculate the circle base on the centroid
        % circle point number
        cn = 1;
        npixel = 0;
        infield = zeros(size(ssh, 1), size(ssh, 2));
        for j = 1:length(lat)
            for k = 1:length(lon)
                % calculate the circle with the radius of sqrt(area/pi)
                res = dLatLon(lat(j),centLat,lon(k),centLon) - sr;
                if abs(res) < dl / 2
                    cirLat(cn) = lat(j);
                    cirLon(cn) = lon(k);
                    cn = cn + 1;
                end
                % calculate the pixel number
                if inpolygon(lat(j), lon(k), slat, slon)
                    npixel = npixel + 1;
                    % calculate the eddy area
                    inlat(npixel)   = lat(j);
                    inlon(npixel)   = lon(k);
                    infield(j, k)   = ssh(j, k);
                end
            end
        end
        % if didnt find the circle point
        if cn == 1
            continue;
        end
        % calculate the overlaps
        [overLat, overLon] = overlaparea(slat, slon, cirLat, cirLon);
        for j = 1:length(overLat)
            % x and y distance from the first point
            overx(j) = sign(overLat(j)-overLat(1)) * dLatLon(overLat(1), overLat(j), overLon(1), overLon(1));
            overy(j) = sign(overLon(j)-overLon(1)) * dLatLon(overLat(1), overLat(1), overLon(1), overLon(j));
        end
        % calculate the overlaps area
        overArea = polyarea(overx, overy);
        % calculate the shape error
        % shape error <= 55%
        shapeError = overArea / area;
        % if shape error > 55%, seak the next coutour
        if shapeError > 0.55
            continue;
        end
        % if the pixel inside the coutour is between min and max
        if npixel > maxPixel || npixel < minPixel
            continue;
        end
        % amplitude search
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
        eddy = Eddy(amp, sCenter, cyc, sr);
        eddyNumber = eddyNumber + 1;
        eddies(eddyNumber) = eddy;
    end
    if eddyNumber == 0
        eddies = 0;
    end
end