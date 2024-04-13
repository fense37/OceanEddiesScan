function [overlat, overlon] = overlaparea(lat1, lon1, lat2, lon2)
%OVERLAPAREA is a function to calculate the overlap area between curve 1 and curve 2
% Created by Wang Zhuoyue at 2024/4/13
%INPUT:
% lat1, lon1: points of curve 1 
% lat1, lon2: points of curve 2
%OUTPUT:
% overlat, overlon = points of overlap area

    % size of curve 1 and curve 2
    if size(lat1, 1) == 1
        lat1 = lat1';
        lon1 = lon1';
    end
    if size(lat2, 1) == 1
        lat2 = lat2';
        lon2 = lon2';
    end

    % point number of curve 1
    N1 = length(lat1);
    if N1 ~= length(lon1)
        error('Wrong 1st curve grid!');
    end
    % point number of curve 2
    N2 = length(lat2);
    if N2 ~= length(lon2)
        error('Wrong 2nd curve grid!');
    end

    % curve 2 points inside curve 1
    in21 = inpolygon(lat1, lon1, lat2, lon2);
    % curve 1 points inside curve 2
    in12 = inpolygon(lat2, lon2, lat1, lon1);

    % the overlap points
    overlat = cat(1, lat2(in21), lat1(~in12));
    overlon = cat(1, lon2(in21), lon1(~in12));

end