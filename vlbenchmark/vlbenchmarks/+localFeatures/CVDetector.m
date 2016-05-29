classdef CVDetector < helpers.GenericInstaller ...
    & localFeatures.GenericLocalFeatureExtractor
    % wrapper for opencv feature2d feature detectors
    % implement abstract methods and properties and the constructor to add
    % the functionality.
    
  properties (Constant)
        CVPATH = '/home/sulai/Desktop/mexopencv-2.4';
  end
  
  properties (Abstract)
    % Opts have to be a struct. it will be used to parse the arguments and
    % should be used by the abstract extract methods to pass the arguments
    % to the cv function
      Opts;
  end
  
  methods (Abstract)
      % call the feature2d extractor to generate the descriptors.
      % further processing like transposing and frame conversion will be 
      % done will be done subsequently
      
      % features : has to be a list of oriented circles for now.
      % descriptors : should be uint8 matrixes
    [features, descripors] = extract(obj,imagePath)
  end
  
  methods 
    function obj = CVDetector(name,varargin)
      addpath(obj.CVPATH);  
      % Implement a constructor to parse any option passed to the
      % feature extractor and store them in the obj.Opts structure.

      % Information that this detector is able to extract descriptors
      obj.ExtractsDescriptors = true;
      % Name of the features extractor
      obj.Name = name;
      % Configure the logger. The parameters accepted by logger are
      % consumend and the rest is passed back to varargin.
      varargin = obj.configureLogger(name,varargin{1});
      % Parse the class options. See the properties of this class where the
      % options are defined.
      obj.Opts = obj.argparse(varargin);
    end
    function [frames descriptors] = extractFeatures(obj, imagePath)
      import helpers.*;

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
      % If you want use cache, in the first step, try to load features from
      % the cache. The third argument of loadFeatures tells whether to load
      % descriptors as well.
      [frames descriptors] = obj.loadFeatures(imagePath,nargout > 1);
      % If features loaded, we are done
      %if numel(frames) > 0; return; end;
      % Get the size of the image
      
      
     [frames descriptors] = extractDescriptors(obj, imagePath, []);

      timeElapsed = toc(startTime);
      obj.debug(sprintf('Features from image %s computed in %gs',...
        getFileName(imagePath),timeElapsed));
      % Store the generated frames and descriptors to the cache.
      obj.storeFeatures(imagePath, frames, descriptors);
    end
    
    % parse the varargin for detector parameter name value pairs and
    % actualize the opts struct.
    function opts = argparse(obj, varargin)
       opts = obj.Opts;
       names = fieldnames(opts);
       for i=1:2:nargin
           name = varargin{1}{i};
           for j=1:length(names)
               if strcmp(name,names{j})
                 opts = setfield(opts, name,varargin{1}{i+1}); 
               end
           end
       end
    end
    
    % convert frames and descriptors from opencv frame structs to a double
    % matrix like it is used from vlfeat.
    function [frames descriptors] = cv2vlFrames(obj,f, d)
      nframes = length(f);
      frames = zeros(4,nframes);
      for i=1:nframes
         frames(1,i) = f(i).pt(1); 
         frames(2,i) = f(i).pt(2); 
         frames(3,i) = f(i).size/2; 
         frames(4,i) = f(i).angle; 
      end
      descriptors = transpose(d);
    end
    
    % extract the descriptors and convert them
    function [frames descriptors] = extractDescriptors(obj, imagePath, frames)
      [f, d] = obj.extract(imagePath);
      [frames descriptors] = obj.cv2vlFrames(f,d);
      
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

