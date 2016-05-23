
I = imread('/media/sf_Shared_Folder/vlbenchmark/vlbenchmarks/data/datasets/vggRetrievalDataset/test/all_souls_000091.jpg');
I = rgb2gray(I);
I = single(I);

binSize = 8 ;
magnif = 3 ;
Is = vl_imsmooth(I, sqrt((binSize/magnif)^2 - .25)) ;

f = vl_sift(I) ;
disp(numel(f));

[f, d] = vl_dsift(Is, 'size', binSize,'Step', 12, 'Fast') ;
disp(numel(f));