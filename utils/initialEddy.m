function [eddies] = initialEddy(oldEddies, date)
%INITIALEDDY is a function to initialize the eddies
% Created by Wang Zhuoyue at 2024/4/15
%INPUT:
% oldEddies: eddies struct with amp, center, cyc, r
%OUTPUT:
% eddies: eddies struct with amp, center, cyc, date, r, ID, Seq
    eddies = oldEddies;
    for i = 1:length(oldEddies)
        eddies(i).date = date;
        eddies(i).ID = i;
        eddies(i).Seq = 1;
    end
end
