classdef Image < handle
    %IMAGE Summary of this class goes here
    %   Detailed explanation goes here
   
    properties
        Format; %the compression format
        Data; %the pixel matrix        
        Width;
        Height;
        Quality=0;
    end
    
    methods
        
        function setFormat(I,Format)
           I.Format =  Format;
        end
        
        function setData(I,Data)
           I.Data = Data;
           I.Width = length(Data);
           I.Height = length(Data(:,1));
        end
        
        function setQuality(I,Q)
            I.Quality = Q;
        end
        
        function show(I)
           image(I.Data); 
        end
        
        function Gray = grayscale(I)
            Gray = single(rgb2gray(I.Data));
        end
    end
    
    methods (Static)
        function I = read(Path)
           I = Image();    
           I.setFormat(Path(end-3:end));
           I.setData(imread(Path));
        end
    end
    
end

