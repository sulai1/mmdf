addpath('/home/sulai/Desktop/mexopencv-2.4');
addpath('/media/sf_Shared_Folder/vlbenchmark/vlbenchmarks/data/software/vlfeat/vlfeat-0.9.16')
addpath('vlbenchmark/vlbenchmarks/');
import cv.*;
import localFeatures.*;

imagePath = fullfile('vlbenchmark','vlbenchmarks','data','datasets',...
    'vggRetrievalDataset','oxbuild','all_souls_000001.jpg');
img = imread(imagePath);

det = ORBDetector('nfeatures', 300000,'edge_threshold', 15, 'patchsize', 15 );

[frames2, descriptors2] = det.extractFeatures(imagePath);
[frames4, descriptors4] = vl_sift(single(rgb2gray(img)));