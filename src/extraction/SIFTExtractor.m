classdef SIFTExtractor < Extractor
    %SIFTEXTRACTOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function [f,d] = extract(Extractor, Image)
            [f,d] = vl_sift(Image.grayscale());
        end
        
        function plot(Extractor, Controllpoints, Image)
            image(Image.Data);
            h1 = vl_plotframe(Controllpoints);
            h2 = vl_plotframe(Controllpoints);
            set(h1,'color','k','linewidth',3);
            set(h2,'color','y','linewidth',2);
        end
    end
    
end

