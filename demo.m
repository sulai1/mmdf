dataDir = 'vlbenchmark\vlbenchmarks\data\datasets\vggRetrievalDataset';
name = 'jpg_0.06';

steps = 5;
min = 0.03;
max = 0.8;
ratios = linspace(min,max,steps);

formats = {'jpg', 'jp2', 'jxr'};

for n=1:length(formats)
    for i=1:steps
        name = sprintf('%s_%d',formats{n}, ratios(i));
        dstDir= fullfile(dataDir,name);
        avgSize = Converter.convertDB(fullfile(dataDir,'oxbuild'),dstDir, 'jpg', formats{n}, ratios(i));

        fid = fopen('sizes.txt', 'at');
        fprintf(fid, '%s %f\n', name, avgSize);
        fclose(fid); 

        gtDir = [dstDir,'_gt'];
        mkdir(gtDir);
        copyfile(fullfile(dataDir,'oxbuild_gt/*'), gtDir);
    end
end