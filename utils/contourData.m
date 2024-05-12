function s = contourData(field, lat, lon)
%CONTOURDATA is a function used for extract the contour info
% Created by Wang Zhuoyue at 2024/4/13
%INPUT:
% field: a 2d dimension field
% lat: 1D array of the latitudes of field
% lon: 1D array of the longitudes of field
%OUTPUT:
% s is a cell which length is the total amount of the contour
% each cell contains an Nx2 array of which the lat and lon set
% and the level info and the points numebr and whether the contour is close

    % Create mesh
    [mlon, mlat] = meshgrid(lon, lat);
    % contour level
    % jude the unit of the field
    max_val = max(field(:));
    min_val = min(field(:));
    % if the unit is meter
    if max_val < 1.5 && min_val > -1.5 
        % change into celimeter
        field = field * 100;
    end
    % level is from -100cm to 100cm, interval is 1cm
    level = [-200: 1: 200];
    % get contour info
    c = contour(mlat, mlon, field, level);
    tol = 1e-12;
    % amount of contour
    k = 1; 
    col = 1;
    % loop to calculate the contour 
    while col < size(c, 2)
        s(k).level = c(1, col);
        s(k).number = c(2, col);
        idx = col + 1: col+c(2, col);
        s(k).x = c(1, idx);
        s(k).y = c(2, idx);
        s(k).isopen = abs(diff(c(1, idx([1 end])))) > tol ||...
            abs(diff(c(2, idx([1 end])))) > tol ;
        k = k + 1;
        col = col + c(2, col) +1;
    end
end