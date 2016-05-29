


det1 = localFeatures.ORBDetector('NFeatures', 3000);
[f1,d1] = det1.extractFeatures('test.jpg');

det2 = localFeatures.VlFeatSift();
[f2,d2] = det2.extractFeatures('test.jpg');


det3 = localFeatures.SURFDetector('HessianThreshold', 500);
[f3,d3] = det3.extractFeatures('test.jpg');

import cv.*

[d4,f4] = FREAK(uint8(rgb2gray(imread('test.jpg'))));