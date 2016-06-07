dataDir = 'vlbenchmark\vlbenchmarks\data\datasets\vggRetrievalDataset';
srcname = 't20';

ratio = 0.5;

formats = {'jp2'};
avgSize = 9e+12;
size = inf;

fid = fopen('sizes.txt', 'at');
fprintf(fid, '\n//%s %s\n', srcname, datestr(datetime('now')));
for n=1:length(formats)
    while avgSize<size
        name = sprintf('%s_%f',formats{n}, ratio);
        dstDir= fullfile(dataDir,name);
        size = avgSize;
        avgSize = Converter.convertDB(fullfile(dataDir,srcname),dstDir, 'jpg', formats{n}, ratio);

        fprintf(fid, '%s %f\n', name, avgSize);
        gtDir = [dstDir,'_gt'];
        mkdir(gtDir);
        copyfile(fullfile(dataDir,[srcname,'_gt/*']), gtDir);
        ratio = ratio/2;
    end
end
fclose(fid); 