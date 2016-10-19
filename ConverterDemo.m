dataDir = 'vlbenchmark\vlbenchmarks\data\datasets\vggRetrievalDataset';
srcname = 't';

ratio = 0.5;

formats = {'jxr'};
avgSize = 4e+05;
size = inf;

index = 1;
for n=1:length(formats)
    while size>avgSize
        name = sprintf('%s_%f',formats{n}, ratio);
        dstDir= fullfile(dataDir,name);
        size = avgSize;
        d = cputime;
        avgSize = Converter.convertDB(fullfile(dataDir,srcname),dstDir, 'jpg', formats{n}, ratio);
        Name{index} = name;
        Duration(index) = cputime-d;
        AvgSize(index) = avgSize;
        gtDir = [dstDir,'_gt'];
        ratio = ratio/2;
        index = index+1;
    end
end
