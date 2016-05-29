clear all

import localfeatures.*
addpath('vlbenchmarks/vlbenchmark/data')

det1 = localFeatures.CVDetector('MaxFeatures',3400);
[f1,d1] = det1.extractFeatures('vlbenchmark/vlbenchmarks/test.jpg');

det2 = localFeatures.VlFeatSift();
[f2,d2] = det2.extractFeatures('vlbenchmark/vlbenchmarks/test.jpg');