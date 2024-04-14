function [ distance ] = dLatLon(lat1, lat2, lon1, lon2)
%DLATLON is a function to calculation the distance bewteen 1 and 2 in lat and lon
% Create by Wang Zhuoyue at 2024/4/12
%OUTPUT:
% distance: the distance between point1 and point2, unit: km
%INPUT:
% lat1: point1 latitude
% lat2: point2 latitude
% lon1: point1 longtitude
% lon2: point2 longtitude
    
    % radius of earth
    R = 6371; 
    % calculate Cartesian coordinate of the two points
    % point1
    x1 = R * cosd(lat1) .* cosd(lon1);
    y1 = R * cosd(lat1) .* sind(lon1);
    z1 = R * sind(lat1);
    l1 = sqrt(x1.^2 + y1.^2 + z1.^2); 
    % point2
    x2 = R * cosd(lat2) .* cosd(lon2);
    y2 = R * cosd(lat2) .* sind(lon2);
    z2 = R * sind(lat2);
    l2 = sqrt(x2.^2 + y2.^2 + z2.^2); 
    % calculate the angle between two vector
    theta = acos((x1 .* x2 + y1 .* y2 + z1 .* z2) ./ (l1 .* l2));
    % calculate distance
    distance = abs(R * theta);

end