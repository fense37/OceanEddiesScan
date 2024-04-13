function [ aver ] = calCirAver(field, lat, lon, center, r)
%CALCIRAVER is a function the calculate the average on the circle of a radius of r
% Basically use for calculate the speed average to cal EKE
% Create by Wang Zhuoyue at 2024/4/12
%OUTPUT:
% aver: the average of field on the circle
%INPUT:
%field: field of speed or other stuff, should be the same dimension with lat and lon
% lat: 1D array of the latitudes of field
% lon: 1D array of the longitudes of field
% center: 1x2 array of the center latitudes and longtitudes
% r: the radius of the circle we need to get aver

    % If the center size is not 1x2
    if size(center) != [1,2]
        error('Invalid center size!');
    end

    % if the dimension of field is unequal to the lat and lon
    if ~all(size(field) == [length(lat) length(lon)])
        error('Invalid field data size!');
    end 

    % if the center is not on the field
    if all(lat < center) | all(lat > center) | all(lon < center) | all(lon > center)
        error('Invalid center point!');
    end

    % calculate the average length of each grid for ref
    dl = dLatLon(lat(1), lat(end), lon(1), lon(end)) / sqrt(length(lat)^2 + length(lon)^2);

    % find the index of center in lat and lon
    % center point
    centerLat = center(1);
    centerLon = center(2);
    % center index
    [~, latIndex] = min(abs(lat-centerLat));
    [~, lonIndex] = min(abs(lon-centerLon));

    % if the circle is fully on the field
    if dLatLon(lat(1), lat(latIndex), lon(lonIndex), lon(lonIndex))   < r | ...
       dLatLon(lat(end), lat(latIndex), lon(lonIndex), lon(lonIndex)) < r | ...
       dLatLon(lat(latIndex), lat(latIndex), lon(1), lon(lonIndex))   < r | ...
       dLatLon(lat(latIndex), lat(latIndex), lon(end), lon(lonIndex)) < r 
       error('The circle is out of the range of field!');
    end

    % find points on the circle 
    cn = 1;
    for i = 1:length(lat)
        for j = 1:length(lon)
            res = dLatLon(lat(i),centerLat,Lon(j),centerLon) - r;
            if abs(res) < dl / 2
                fieldValueCir(cn) = field(i, j);
                cn = cn + 1;
            end
        end
    end

    % if didnt find the circle point
    if cn == 1
        error('no points on the circle!');
    end

    % calculate the average on the circle
    aver = nanmean(fieldValueCir);

end