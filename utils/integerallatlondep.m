function int = integerlatlondep(field, lat, lon, dep)
%INTERLATLONDEP is a function used for integer the lat lon dep of geo situation
%INPUT:
% field: the field you need to integer
% lat: the lat of the points, 1D arrays
% lon: the lon of the points, 1D arrays
% dep: the depth of the points, 1D arrays
%OUTPUT:
% int: the integergal of the field

    % make sure the size of field
    if (size(field) ~= [length(lat) length(lon) length(dep)])
        error('wrong size of field!');
    end
    % build the edge
    %points: 1 2 3 4 5
    %edges: 1 2 3 4 5 6 
    elat = zeros(1, length(lat) + 1);
    elon = zeros(1, length(lon) + 1);
    edep = zeros(1, length(dep) + 1);
    for i = 1: length(elat)
        if i == 1
            elat(i) = lat(i) - 0.5 * abs(lat(i+1) - lat(i));
        else
            if i == length(elat)
                elat(i) = lat(i - 1) + 0.5 * abs(lat(i-1) - lat(i-2));
            else 
                elat(i) = 0.5*(lat(i) + lat(i-1));
            end
        end 
    end
    for i = 1: length(elon)
        if i == 1
            elon(i) = lon(i) - 0.5 * abs(lon(i+1) - lon(i));
        else
            if i == length(elon)
                elon(i) = lon(i - 1) + 0.5 * abs(lon(i-1) - lon(i-2));
            else 
                elon(i) = 0.5*(lon(i) + lon(i-1));
            end
        end 
    end
    for i = 1: length(edep)
        if i == 1
            edep(i) = dep(i) - 0.5 * abs(dep(i+1) - dep(i));
        else
            if i == length(edep)
                edep(i) = dep(i - 1) + 0.5 * abs(dep(i-1) - dep(i-2));
            else 
                edep(i) = 0.5*(dep(i) + dep(i-1));
            end
        end 
    end
    % calculate the volume of everyblock
    volume = zeros(size(field));
    for i = 1:length(lat)
        for j = 1:length(lon)
            for k = 1:length(dep)
                dx = dLatLon(elat(i), elat(i), elon(j), elon(j+1));
                dy = dLatLon(elat(i), elat(i+1), elon(j), elon(j));
                dz = edep(k+1) - edep(k);
                volume(i, j, k) = dx * dy * dz;
            end
        end
    end
    int = nansum(nansum(nansum(field .* volume)));
end