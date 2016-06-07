dataDir = 'vlbenchmark\vlbenchmarks\data\datasets\vggRetrievalDataset';

steps = 8;
ratios = logspace(1,2.5,steps+2);
max = ratios(end);
ratios = ratios(2:end-1)/max;
srcname = 't20';
formats = {'jxr'};

for n=1:length(formats)
    for i=1:steps
        name = sprintf('%s_%d',formats{n}, ratios(i));
        dstDir= fullfile(dataDir,name);
        avgSize = Converter.convertDB(fullfile(dataDir,'t20'),dstDir, 'jpg', formats{n}, ratios(i));

        fid = fopen('sizes.txt', 'at');
        fprintf(fid, '%s %f\n', name, avgSize);
        fclose(fid); 

        gtDir = [dstDir,'_gt'];
        mkdir(gtDir);
        copyfile(fullfile(dataDir,[srcname,'_gt/*']), gtDir);
    end
end