    classdef Eddy <handle
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
    
    