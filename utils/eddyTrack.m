function [eddies] = eddyTrack(oldEddies, newEddies, date)
%EDDYTRACK is a function to update the eddies struct based on the S value
%    ___                  ___________________________
%    |__           ——    |   Δd  2   Δa  2     ΔA  2 
%    ___|(k, k+1)  ——   _|  ————  + ————   +  ————
%                            d0      a0        A0
% Created by Wang Zhuoyue at 2024/4/15
%INPUT:
% oldEddies: eddies struct with amp, center, cyc, r, date, Seq, ID
% newEddies: eddies struct with amp, center, cyc, r
% date: date of new eddies
%OUTPUT:
% eddies: eddies struct with amp, center, cyc, r, ID, Seq

    % basic paramter
    % eigenvalue of distance: 25km
    d0 = 25;
    % eigenvalue of area: 3600pikm2
    a0 = 60 ^ 2 * pi;
    % eigenvalue of amplitude: 2cm
    A0 = 2;
    eddies = oldEddies;
    % Update all eddies in oldEddies
    s = zeros(length(oldEddies), length(newEddies));
    for i = 1:length(oldEddies)
        for j = 1:length(newEddies)
            % calculate amp diff
            dA = oldEddies(i).amp(end) - newEddies(j).amp;
            % calculate area diff
            da = pi * (oldEddies(i).r(end) ^ 2 - newEddies(j).r ^ 2);
            % calculate distance diff
            dd = dLatLon(oldEddies(i).center(end, 1), newEddies(j).center(1), oldEddies(i).center(end, 2), newEddies(j).center(2));
            % if the cyclone is opposite
            dc = oldEddies(i).cyc(end) - newEddies(j).cyc;
            % calculate S valye
            if dc == 0
                s(i, j) = sqrt((dA/A0)^2+(da/a0)^2+(dd/d0)^2);
            else
                s(i, j) = NaN;
            end
        end
    end
    % search the martix, if two old eddies have same smallest S in one new
    % eddy, the one with a bigger S change another
    updateEddyNumber = 0;
    for i = 1:length(oldEddies)
        [minS, nextIndex] = min(s(i,:));
        [minJS, JIndex] = min(s(:, nextIndex));
        if minJS == minS
            updateEddyNumber = updateEddyNumber + 1;
            updateEddies(updateEddyNumber) = nextIndex;
            eddies(i).amp = cat(1, eddies(i).amp, newEddies(nextIndex).amp);
            eddies(i).center = cat(1, eddies(i).center, newEddies(nextIndex).center);
            eddies(i).cyc = cat(1, eddies(i).cyc, newEddies(nextIndex).cyc);
            eddies(i).r = cat(1, eddies(i).r, newEddies(nextIndex).r);
            eddies(i).date = cat(1, eddies(i).date, date);
            eddies(i).Seq = cat(1, eddies(i).Seq, eddies(i).Seq(end) + 1);
            oldcontour = eddies(i).contour;
            newcontour = newEddies(nextIndex).contour;
            oldcontour{end+1} = newcontour{1};
            eddies(i).contour = oldcontour;
        end
    end
    % generating new eddies
    addEddy = setdiff([1:length(newEddies)], updateEddies);
    % Add new eddies
    for i = length(oldEddies) + 1:length(oldEddies) + length(newEddies) - length(updateEddies)
        eddies(i).amp = newEddies(addEddy(i - length(oldEddies))).amp;
        eddies(i).center = newEddies(addEddy(i - length(oldEddies))).center;
        eddies(i).cyc = newEddies(addEddy(i - length(oldEddies))).cyc;
        eddies(i).r = newEddies(addEddy(i - length(oldEddies))).r;
        newcontour = newEddies(addEddy(i - length(oldEddies))).contour;
        eddies(i).contour = {newcontour{1}};
        eddies(i).date = date;
        eddies(i).Seq = 1;
        eddies(i).ID = i;
    end
end