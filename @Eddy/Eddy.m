classdef Eddy <handle
%CLASS EDDY def a class call eddy which contains the following properties
%Created by Wang Zhuoyue at 2024/4/12
% amp: amplitude of teh eddy, unit cm
% center: center lon and lat of the eddy Nx2
% cyc: cyclone type of the eddy Nx1
% r: radius of the eddy Nx1
% u: the speed of the eddy at average of the radius of r Nx1
% ID: eddy identifiy number Nx1
% date: eddy date Nx1
% Seq: eddy life time since in ssh Nx1
    properties  % center, cyc, r, u, ID, date, Seq
        amp
        center
        cyc
        date
        r
        u
        ID
        Seq
    end
    methods % Create an Eddy
        function objEddy = Eddy(amp, center, cyc, r)
            objEddy.amp    = amp;
            objEddy.center = center;
            objEddy.cyc    = cyc;
            objEddy.r      = r;
            objEddy.ID     = ID;
            objEddy.date   = date;
            objEddy.Seq    = Seq;
        end
    end
end
    
    