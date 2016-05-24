classdef SURFDetector < helpers.GenericInstaller ...
    & localFeatures.GenericLocalFeatureExtractor
% localFeatures.ExampleLocalFeatureExtractor Example image feature extractor
%   To use your own feature extractor (detector and/or descriptor)
%   modify this class in the following manner.
%
%   1. Rename the class and the constructor.
%   2. Implement the constructor to set a default value for the
%      parameters of your feature.
%   3. Implement the EXTRACTFEATURES() method, eventually 
%      EXTRACTDESCRIPTORS method if your detector supports to detect
%      descriptors of given feature frames.
%
%   Frames are generated as a grid over the whole image with a selected
%   scales.
%
%   Descriptor of the frames is calculated as mean/variance/median of the
%   circular region defined by the frame scale.
%
%   This example detector need image processing toolbox.

% Authors: Karel Lenc

% AUTORIGHTS

  properties (SetAccess=private, GetAccess=public)
    % Set the default values of the detector options
    Opts = struct(...
        'HessianThreshold',100,...
        'NOctaves',4,...
        'NOctaveLayers',2,...
        'Extended',1,...
        'UpRight',0 ...
      );   
  end

  methods
    function obj = SURFDetector(varargin)
      addpath('/home/sulai/Desktop/mexopencv-2.4');
        
        import helpers.*
      obj.Opts = argparse(obj.Opts,varargin);
      % Implement a constructor to parse any option passed to the
      % feature extractor and store them in the obj.Opts structure.

      % Information that this detector is able to extract descriptors
      obj.ExtractsDescriptors = true;
      % Name of the features extractor
      obj.Name = 'SURF detector';
    end

    function [frames descriptors] = extractFeatures(obj, imagePath)
      import helpers.*;
      import cv.*;
      import localFeatures.opencv2vlfeat
      
      startTime = tic;
      % Because this class inherits from helpers.Logger, we can use its
      % methods for giving information to the user. Advantage of the 
      % logger is that the user can set the class verbosity. See the
      % helpers.Logger documentation.
      if nargout == 1
        obj.info('Computing frames of image %s.',getFileName(imagePath));
      else
        obj.info('Computing frames and descriptors of image %s.',...
          getFileName(imagePath));
      end
      
      %% calculate frames
      img = imread(imagePath);
      [f, d] = SURF(img,...
        'HessianThreshold',obj.Opts.HessianThreshold,...
        'NOctaves',obj.Opts.NOctaves,...
        'NOctaveLayers',obj.Opts.NOctaveLayers,...
        'Extended',obj.Opts.Extended,...
        'UpRight',obj.Opts.UpRight ...
        );
      
      [frames, descriptors] = opencv2vlfeat(f,d);
      
      timeElapsed = toc(startTime);
      obj.debug(sprintf('Features from image %s computed in %gs',...
        getFileName(imagePath),timeElapsed));
    end

    function [frames descriptors] = extractDescriptors(obj, imagePath, frames)
      % EXTRACTDESCRIPTORS Compute mean, variance and median of the integer
      %   disk frame.
      %
      %   This is mean as an example how to work with the detected frames.
      %   The computed descriptor bears too few data to be distinctive.
      import localFeatures.helpers.*;
      import cv.*;

      obj.info('Computing descriptors.');
      startTime = tic;
      %% calculate frames
      img = imread(imagePath);
      [frames, descriptors] = SURF(img);
      %%
      elapsedTime = toc(startTime);
      obj.debug('Descriptors computed in %gs',elapsedTime);      
      % This method does not cache the computed values as it is complicated
      % to compute a signature of the input frames.
    end

    function signature = getSignature(obj)
      % This method is called from loadFeatures and  storeFeatures methods
      % to ge uniqie string for the detector properties. Because this is
      % influenced both by the detector settings and its implementation,
      % the string signature of both of them.
      % fileSignature returns a string which contain information about the
      % file including the last modification date.
       
      signature = [helpers.struct2str(obj.Opts),';',...
        helpers.fileSignature(mfilename('fullpath'))];
    end
  end

  methods(Static)
    %  Because this class is is subclass of GenericInstaller it can benefit
    %  from its support. When GenericInstaller.install() method is called,
    %  the following operations are performed when it was detected that the
    %  class is not installed:
    %
    %    1. Install dependencies
    %    2. Download and unpack tarballs
    %    3. Run compilation
    %    4. Compile mex files
    %    5. Setup the class
    %
    %  These steps are defined by the following static methods
    %  implementations:
    %
    %   deps = getDependencies()
    %     Define the dependencies, i.e. instances of GenericInstaller which
    %     are installed when method install() is called.
    %
    %   [urls dstPaths] = getTarballsList()
    %     Returns urls = {archive_1_url, archive_2_url,...} and 
    %     dstPaths = {archive_1_dst_path,...} and defines which files
    %     should be downloaded when install() is called.
    %
    %   compile()
    %     User defined method which is called after installing all tarballs
    %     and when isCompiled returns false.
    %
    %   res = isCompiled()
    %     User defined method to test whether compile() method should be
    %     called to complete the class isntallation.
    %
    %   [srclist flags]  = getMexSources()
    %     Returns srclist = {path_to_mex_files} and their flags which are
    %     compiled using mex command. See helpers.Installer for an example.
    %
  end
end
