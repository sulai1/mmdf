dataDir = 'vlbenchmark\vlbenchmarks\data\datasets\vggRetrievalDataset';
name = 'jp2_0.3';

dstDir= fullfile(dataDir,name);
avgSize = Converter.convertDB(fullfile(dataDir,'oxbuild'),dstDir, 'jpg', 'jp2', 0.3);

fid = fopen('sizes.txt', 'at');
fprintf(fid, '%s %f', name, avgSize);
fclose('sizes.txt'); 

gtDir = [dstDir,'_gt'];
mkdir(gtDir);
copyfile(fullfile(dataDir,'oxbuild_gt/*'), gtDir);
