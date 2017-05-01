function [mAP queriesAp] = retrievalDemo(resultsPath)
% RETRIEVALDEMO Demonstrates how to run the retrieval benchmark
%   RETRIEVALDEMO() Runs the repeatability demo.
%
%   RETRIEVALDEMO(RESULTS_PATH) Run the demo and save the results to
%   path RESULTS_PATH.

% Authors: Karel Lenc and Andrea Vedaldi

% AUTORIGHTS

if nargin < 1, resultsPath = ''; end;

% --------------------------------------------------------------------
% PART 1: Run the retrieval test
% --------------------------------------------------------------------
import localFeatures.*;
import datasets.*;
import benchmarks.*;
import helpers.*

% Define the features extractors which will be tested with the retrieval
% benchmark.

brisk = BRISKDetector();
surf = SURFDetector();
sift = VlFeatSift();
% Define the benchmark class. This implements simple retrieval system which
% uses extracted features in a K-Nearest Neighbour search in order to
% retrieve queried images. Ranked set of retrieved images is then evaluated
% measuring the mean average precision of all queries.
% Parameter 'MaxNumImagesPerSearch' sets in how big chunks the dataset
% should be divided for the KNN search.
retBenchmarkH = CustomRetrievalBenchmark('MaxNumImagesPerSearch',100, 'distMetric','H');
retBenchmarkL2 = CustomRetrievalBenchmark('MaxNumImagesPerSearch',100, 'distMetric','L2');
retBenchmarkH.disableCaching();
retBenchmarkL2.disableCaching();

% Define the dataset which will be used for the benchmark. In this case we
% will use 'oxbuild' dataset (Philbin, CVPR07) which originally consists
% from 5k images. In order to compute the results in a reasonable time, we
% will select only subset of the images. Wrapper of this data/home/sulaiset uniformly
% samples the subsetsxr
name = 'oxbuild';
respath = 'res';
t = datetime('now');
signature = [name,datestr(t,'mm.dd.yy.HH.MM.SS')];

mkdir(fullfile(respath, name));
    %initialize a dataset
dataset = CustomRetrievalDataset('GoodImagesNum',10 ,...
                                  'OkImagesNum',10,...
                                  'JunkImagesNum',0,...
                                  'BadImagesNum',30,...
                                  'cacheDatabase',true);
dataset.init('G:\mmdf\vlbenchmark\vlbenchmarks\data\datasets\vggRetrievalDataset\t5',...
    'G:\mmdf\vlbenchmark\vlbenchmarks\data\datasets\vggRetrievalDataset\t5_gt');

% % Run the test for all defined feature extractors
% [map1, info1] = retBenchmarkH.testFeatureExtractor(brisk, dataset);
% [map2,info2] = retBenchmarkL2.testFeatureExtractor(surf, dataset);
[map3,info3] = retBenchmarkL2.testFeatureExtractor(sift, dataset);
% 
% disp('BRISK');
% disp(map1);
% disp(sum( info1.numDescriptors)/size(info1.numDescriptors,1));
% save('res/brisk.mat','map1','info1');
% 
% disp('SURF')
% disp(map2);
% disp(sum( info2.numDescriptors)/size(info2.numDescriptors,1));
% save('res/surf.mat','map2','info2');

disp('SIFT')
disp(map3);
disp(sum( info3.numDescriptors)/size(info3.numDescriptors,1));
save('res/sift.mat','map3','info3');



