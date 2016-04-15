classdef Controlpoints < handle
    %POINT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        X;
        Y;
    end
    
    methods
        function P = Controlpoints(x,y)
            P.X=x;
            P.Y=y;
        end
        
        function Comp = compare(P1,P2)
           if(P1.X<P2.X)
               Comp = -1;
           elseif(P1.X>P2.X)
               Comp = 1;
           elseif(P1.Y<P2.Y)
               Comp = -1;
           elseif(P1.Y>P2.Y)
               Comp = 1;
           else
               Comp = 0;
           end
        end
    end
    
end

