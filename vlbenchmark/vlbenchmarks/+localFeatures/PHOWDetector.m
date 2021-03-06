classdef PHOWDetector < localFeatures.CVDetector
    %ORBDETECTOR Summary of this class goes here
    %   Detailed explanation goes here
    % Step 1 : Extracts a SIFT descriptor each STEP pixels. 
    % Size 3 : A spatial bin covers SIZE pixels. 
    
    properties
        Opts = struct(...
            'Sizes', 8, ...
            'Step',16, ...
            'Color', 'rgb' ...
        );
    end
    
    methods
        
        function obj = PHOWDetector(varargin)
            obj = obj@localFeatures.CVDetector('PHOW',varargin);
            obj.Name = ['PHOW-',obj.Opts.Color];
        end
        % extract the descriptors and convert them
        function [frames, descriptors] = extractDescriptors(obj, imagePath, f)
            [frames, descriptors] = obj.extract(imagePath);
        end
        
        function [features, descriptors] = extract(obj, imagePath)
            if strfind(imagePath, '.jxr')
                img = convert.Converter.readJXR(imagePath);
            else
                img = imread(imagePath);
            end
            if strcmp(obj.Opts.Color,'gray')
                img = single(rgb2gray(img));
            else
                img = single(img);
            end
            [features, descriptors] = vl_phow(img,... 
            'Sizes', obj.Opts.Sizes, ...
            'Step',obj.Opts.Step, ...
            'Color', obj.Opts.Color ...
            );
        end
    end
end

