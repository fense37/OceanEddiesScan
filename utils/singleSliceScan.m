function [eddies] = singleSliceScan(ssh, lat, lon)
%SINGLESLICESCAN can scan the eddies in one slice of ssh
%Created by Wang Zhuoyue at 2024/4/12
%OUTPUT:
% eddies: a class of eddy which contains
% center: center lon and lat of the eddy Nx2
% cyc: cyclone type of the eddy Nx1
% r: radius of the eddy Nx1
% u: the speed of the eddy at average of the radius of r Nx1
% ID: eddy identifiy number Nx1
% date: eddy date Nx1
% Seq: eddy life time since in ssh Nx1
%INPUT:
% ssh: ssh(latxlonxtime), if only one slice in the 3rd dimension scan single
% lat: 1D array of the latitudes of ssh grid
% lon: 1D array of the longitudes of ssh grid
    % def class of eddy
    classdef Eddy<handle
        properties  % center, cyc, r, u, ID, date, Seq
            center
            cyc
            r
            u
            ID
            date
            Seq
        end
        methods % Create an Eddy
            function objEddy = Eddy(center, cyc, r, u, ID, date, Seq)
                objEddy.center = center;
                objEddy.cyc    = cyc;
                objEddy.r      = r;
                objEddy.u      = u;
                objEddy.ID     = ID;
                objEddy.date   = date;
                objEddy.Seq    = Seq;
            end
    end
end