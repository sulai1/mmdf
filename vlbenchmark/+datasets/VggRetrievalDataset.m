classdef VggRetrievalDataset < datasets.GenericDataset & helpers.Logger ...
    & helpers.GenericInstaller
% datasets.VggRetrievalDataset Wrapper of VGG image retrieval datasets
%   datasets.VggRetrievalDataset('OptionName',OptionValue) constructs
%   new VGG Retrieval dataset object. This class handles VGG image
%   retrieval datasets [1] [2] of images which are accompanied with
%   groundtruth queries. In these datasets each query q specify
%   following data:
%
%     q.name - Name of the query
%     q.imageName - Name of the image which contain the query region
%     q.imageId - Unique identifier of the query image.
%     q.box [xmin ymin xmax ymax] - Box of the query region
%
%   And three sets of image ids [1]:
%     q.good -  A nice, clear picture of the object/building
%     q.ok - More than 25% of the object is clearly visible.
%     q.junk - Less than 25% of the object is visible, or there are 
%       very high levels of occlusion or distortion.
%
%   Images which are not present in these three sets are considered to
%   be in a 'bad' set, i.e. object is not present.
%
%   The dataset object can be also created only with a subset of images by
%   definition of '<category name>ImagesNum'. When all of these values are
%   set to inf, whole original dataset is used.
%
%   Note that when a subset is used, the image indexes changes.
%
%   Downloaded data are parsed and a database of the images and
%   queries is created and on default is cached. However the validity
%   of cached data is checked only based on the class options and not
%   on the files. Therefore if you want to change the contents of the
%   database, make sure that caching is disabled (option
%   'CacheDatabase').
%
%   For the databases rights, see the websites of the datasets.
%
% Options:
%   Category :: 'oxbuild'
%     Dataset category. Available are 'oxbuild'.
%
%   GoodImagesNum :: inf
%     Number of 'Good' images preserved in the database. When inf, all
%     images preserved.
%
%   OkImagesNum :: inf
%     Number of 'ok' images preserved in the databse. When inf, all
%     images preserved.
%
%   JunkImagesNum :: inf
%     Number of 'junk' images preserved in the databse. When inf, all
%     images preserved.
%
%   BadImagesNum :: 100
%     Number of 'junk' images preserved in the databse. When inf, all
%     images preserved.
%
%   SamplingSeed :: 1
%     Seed of the random number generator used for sampling the image
%     dataset.
%
%   CacheDatabase :: true
%     Cache parsed images and queries database.
%
%   See also: benchmarks.RetrievalBenchmark
%
%   REFERENCES
%   [1] J. Philbin, O. Chum, M. Isard, J. Sivic and A. Zisserman.
%       Object retrieval with large vocabularies and fast spatial 
%       matching CVPR, 2007

% Authors: Karel Lenc, Andrea Vedaldi

% AUTORIGHTS
  properties (SetAccess=protected, GetAccess=public)
    % Dataset options
    Opts = struct(...
      'category','oxbuild',...
      'goodImagesNum',inf,...
      'okImagesNum',inf,...
      'junkImagesNum',inf,...
      'badImagesNum',100,...
      'samplingSeed',1,...
      'cacheDatabase',true);
    ImagesDir;  % Directory with current category images
    GtDir;      % Directory with current category ground truth data
    Images;     % Array of structs defining the dataset images
    Queries;    % Array of structs with the dataset queries
    NumQueries; % Number of queries
  end

  properties(Constant)
    AllCategories = {'oxbuild','paris'}; % Available categories
  end

  properties (Constant, Hidden)
    % Data location
    RootInstallDir = fullfile('data','datasets','vggRetrievalDataset','');
    % Images URLs (same order as categories)
    ImagesUrls = {...
      {'http://www.robots.ox.ac.uk/~vgg/data/oxbuildings/oxbuild_images.tgz'},...
      {'http://www.robots.ox.ac.uk/~vgg/data/parisbuildings/paris_1.tgz',...
      'http://www.robots.ox.ac.uk/~vgg/data/parisbuildings/paris_2.tgz'}};
    % Ground truth data URLs (same order as categories)
    GtDataUrls = {...
      'http://www.robots.ox.ac.uk/~vgg/data/oxbuildings/gt_files_170407.tgz',...
      'http://www.robots.ox.ac.uk/~vgg/data/parisbuildings/paris_120310.tgz'};
  end

  methods
    function obj = VggRetrievalDataset(varargin)
      import datasets.*;
      import helpers.*;
      obj.DatasetName = 'VggRetrievalDataset';
      varargin = obj.configureLogger(obj.DatasetName, varargin);
      [obj.Opts varargin] = helpers.vl_argparse(obj.Opts,varargin);
      obj.checkInstall(varargin);
      assert(ismember(obj.Opts.category,obj.AllCategories),...
             sprintf('Invalid category for vgg retreival dataset: %s\n',...
             obj.Opts.category));
      obj.ImagesDir = fullfile(obj.RootInstallDir,obj.Opts.category,'');
      obj.GtDir = fullfile(obj.RootInstallDir,...
        [obj.Opts.category '_gt'],'');
      % Load the object only in case when installed
      if ~obj.isInstalled()
        obj.warn('Not installed. Initialised empty dataset.');
        return;
      end
      if obj.Opts.cacheDatabase
        dataKey = [obj.DatasetName ';' struct2str(obj.Opts)];
        data = DataCache.getData(dataKey);
        if ~isempty(data)
          obj.debug('Database loaded from cache.');
          [obj.Images obj.Queries] = data{:};
        else
          [obj.Images obj.Queries] = obj.buildImageDatabase();
          DataCache.storeData({obj.Images obj.Queries},dataKey);
        end
      else
        [obj.Images obj.Queries] = obj.buildImageDatabase();
      end
      obj.NumImages = numel(obj.Images.id);
      obj.NumQueries = numel(obj.Queries);
    end

    function imgPath = getImagePath(obj,imageNo)
      % getImagePath Get a path of an image from the database.
      %   IMG_PATH = obj.getImagePath(IMG_NO) Get path IMG_PATH of an
      %   image defined by its number 0 < IMG_NO <= obj.NumImages.
      if imageNo >= 1 && imageNo <= obj.NumImages
        imgPath = fullfile(obj.ImagesDir,obj.Images.names{imageNo});
      else
        obj.error('Out of bounds image number.\n');
      end
    end

    function query = getQuery(obj,queryIdx)
      % getQuery Get a dataset query
      %  QUERY = obj.getQuery(QUERYID) Returns struct QUERY defined by
      %  0 < QUERYID <= obj.NumQueries. For query definition see class
      %  documentation.
      %
      %  See also: datasets.VggRetrievalDataset
      if queryIdx >= 1 && queryIdx <= obj.NumQueries
        query = obj.Queries(queryIdx);
      else
        obj.error('Out of bounds idx');
      end
    end

    function signature = getQueriesSignature(obj)
      % GETQUERIESSIGNATURE Get signature of all dataset queries
      %   SIGNATURE = GETQUERIESSIGNATURE() Get a unique signature of all
      %   queries in the dataset.
      import helpers.*;
      querySignatures = '';
      for queryIdx = 1:obj.NumQueries
        querySignatures = strcat(querySignatures, ...
          obj.getQuerySignature(queryIdx));
      end
      signature = ['queries_' obj.DatasetName CalcMD5.CalcMD5(querySignatures)];
    end

    function querySignature = getQuerySignature(obj, queryIdx)
      % GETQUERYSIGNATURE Get a signature of a query
      %  QUERY_SIGNATURE = GETQUERYSIGNATURE(QUERY_IDX) Get an unique 
      %  string signatures QUERY_SIGNATURE of a query QUERY_IDX.
      import helpers.*;
      query = obj.getQuery(queryIdx);
      imagePath = obj.getImagePath(query.imageId);
      imageSign = fileSignature(imagePath);
      querySignature = strcat(imageSign,mat2str(query.good),...
        mat2str(query.ok),mat2str(query.junk));
    end

    function samples = sampleArray(obj, data, num)
      % sampleArray Generate reproducible samples from an array      
      %   SAMPLES = obj.sampleArray(DATA, NUM) Get NUM of uniformly
      %   disturbed samples from DATA based on the seed
      %   obj.Opts.samplingRngSeed. If isinf(NUM), SAMPLES = DATA.
      if isinf(num)
        samples = data;
        return;
      end
      samplingStream = RandStream('mt19937ar','Seed',...
        obj.Opts.samplingSeed);
      samples = sort(randsample(samplingStream,data,num));
    end
  end

  methods(Access = protected)
    function [images queries] = buildImageDatabase(obj)
      import datasets.*;
      obj.info('Loading dataset %s.',obj.DatasetName);
      names = dir(fullfile(obj.ImagesDir, '*.jpg')) ;
      numImages = numel(names);
      images.id = 1:numImages ;
      images.names = {names.name} ;

      postfixless = cell(numImages,1);
      for i = 1:numImages
        [ans,postfixless{i}] = fileparts(images.names{i}) ;
      end
      function i = toindex(x)
        [ok,i] = ismember(x,postfixless) ;
        i = i(ok) ;
      end
      names = dir(fullfile(obj.GtDir,'*_query.txt'));
      names = {names.name} ;
      if numel(names) == 0
        obj.warn('No queries in %s',obj.GtDir);
      end

      for i = 1:numel(names)
        base = names{i} ;
        [imageName,x0,y0,x1,y1] = textread(fullfile(obj.GtDir, base), ...
          '%s %f %f %f %f') ;
        name = base ;
        name = name(1:end-10) ;
        imageName = cell2mat(imageName) ;
        imageName = imageName(6:end) ;
        queries(i).name = name ;
        queries(i).imageName = imageName ;
        queries(i).imageId = toindex(imageName) ;
        queries(i).box = [x0;y0;x1;y1] ;
        queries(i).good = toindex(textread(fullfile(obj.GtDir, ...
          sprintf('%s_good.txt',name)), '%s'))' ;
        queries(i).ok = toindex(textread(fullfile(obj.GtDir, ...
          sprintf('%s_ok.txt',name)), '%s'))' ;
        queries(i).junk = toindex(textread(fullfile(obj.GtDir, ...
          sprintf('%s_junk.txt',name)), '%s'))' ;
      end

      useSubset = ~isinf(obj.Opts.goodImagesNum) ...
        || ~isinf(obj.Opts.okImagesNum) ...
        || ~isinf(obj.Opts.junkImagesNum) ...
        || ~isinf(obj.Opts.badImagesNum);
      if useSubset
        allGoodImages = [queries(:).good];
        allOkImages = [queries(:).ok];
        allJunkImages = [queries(:).junk];
        allBadImages = setdiff(images.id, ...
          [allGoodImages allOkImages allJunkImages]);
        allQueriesImages = [queries(:).imageId];

        % Pick random samples from the images based on the class settings
        goodImages = ...
          obj.sampleArray(allGoodImages,obj.Opts.goodImagesNum);
        okImages = ...
          obj.sampleArray(allOkImages,obj.Opts.okImagesNum);
        junkImages = ...
          obj.sampleArray(allJunkImages,obj.Opts.junkImagesNum);
        badImages = ...
          obj.sampleArray(allBadImages,obj.Opts.badImagesNum);

        pickedImages = [allQueriesImages, goodImages, okImages, ...
          junkImages, badImages];
        pickedImages = unique(pickedImages);
        obj.debug('Size of the images subset: %d',numel(pickedImages));
        
        % Change the queries for the picked image subset
        map = zeros(1,numImages);
        map(pickedImages) = 1:numel(pickedImages);
        for i=1:numel(queries)
          queries(i).imageId = map([queries(i).imageId]);
          if queries(i).imageId == 0
            error('Query image must be a part of the dataset.')
          end
          queries(i).good = map([queries(i).good]);
          queries(i).good = queries(i).good(queries(i).good~=0);
          queries(i).ok = map([queries(i).ok]);
          queries(i).ok = queries(i).ok(queries(i).ok~=0);
          queries(i).junk = map([queries(i).junk]);
          queries(i).junk = queries(i).junk(queries(i).junk ~= 0);
        end
        images.id = 1:numel(pickedImages);
        images.names = images.names(pickedImages);
      end
    end

    function [urls dstPaths] = getTarballsList(obj)
      import datasets.*;
      installDir = VggRetrievalDataset.RootInstallDir;
      curCategory = obj.Opts.category;
      cIdx = strcmp(curCategory, VggRetrievalDataset.AllCategories);
      imagesUrls = VggRetrievalDataset.ImagesUrls{cIdx};
      imagesPaths = cell(size(imagesUrls));
      imagesPaths(:) = {fullfile(installDir,curCategory)};
      urls = [imagesUrls VggRetrievalDataset.GtDataUrls(cIdx)];
      dstPaths = [imagesPaths {fullfile(installDir,[curCategory '_gt'])}];
    end

    function deps = getDependencies(obj)
      deps = {helpers.Installer};
    end
  end
end
