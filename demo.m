dataDir = 'vlbenchmark\vlbenchmarks\data\datasets\vggRetrievalDataset';
name = 'jpg_0.06';

dstDir= fullfile(dataDir,name);
avgSize = Converter.convertDB(fullfile(dataDir,'oxbuild'),dstDir, 'jpg', 'jpg', 0.06);

fid = fopen('sizes.txt', 'at');
fprintf(fid, '%s %f\n', name, avgSize);
fclose(fid); 

gtDir = [dstDir,'_gt'];
mkdir(gtDir);
copyfile(fullfile(dataDir,'oxbuild_gt/*'), gtDir);
