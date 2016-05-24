
detector = localFeatures.VlFeatSift();
[f,d] = detector.extractFeatures('test.jpg');

detector = localFeatures.SURFDetector();
[f2,d2] = detector.extractFeatures('test.jpg');