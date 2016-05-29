classdef SURFDetector < localFeatures.CVDetector
    %ORBDETECTOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Opts = struct(...
                'HessianThreshold', 100, ...            
                'NOctaves', 4, ...
                'NOctaveLayers', 2 ...
        );
    end
    
    methods
        
        function obj = SURFDetector(varargin)
            obj = obj@localFeatures.CVDetector('SURF',varargin);
        end
        
        function [features, descriptors] = extract(obj, imagePath)
            import cv.*
            [features, descriptors] = SURF(rgb2gray(imread(imagePath)),... 
                'HessianThreshold',  obj.Opts.HessianThreshold, ...            
                'NOctaves', obj.Opts.NOctaves, ...
                'NOctaveLayers', obj.Opts.NOctaveLayers ...
            );
        end
    end
end

