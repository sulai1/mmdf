classdef Tester
    %TESTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ReferenceImage;
        ReferenceCP;
    end
    
    methods
        function T = Tester(RefImage)
            T.ReferenceImage = RefImage;
            T.ReferenceCP = T.calculateKeyPoints(RefImage);
        end
        
        function Rate = test(T,Image)
            cp = T.calculateKeyPoints(Image);
            Rate = T.match(T.ReferenceCP,cp);
        end
        
        function CP = calculateKeyPoints(T, Image)
           CP = vl_sift(Image.grayscale());
        end
        
        %% simply look if it found as much matches as in the initial image
        function M = match(T, cp1, cp2)
            [matches,scores] = vl_ubcmatch(cp1,cp2);
            M = length(matches)/length(T.ReferenceCP);
            %M = M*mean(scores)/max(scores);
        end
    end
    
end

