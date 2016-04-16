classdef Extractor < handle
    %EXTRACTOR Summary of this class goes here
    %   The extractor interface is used to extract controllpoints from the
    %   image and therefor has to implement the extract function.
    %   it should also provide a description what kind of controllpoints it
    %   generates.
    
    properties
    end
    
    methods (Abstract)
        %implement function to extract the control points from the image
        CPS = extract(Extractor, Image);
        
        plot(Extractor, Controllpoints);
        
    end
        
end

