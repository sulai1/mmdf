dataDir = 'vlbenchmark\vlbenchmarks\data\datasets\vggRetrievalDataset';
resDir = 'vlbenchmark\vlbenchmarks\res';
srcname = 't20';

ratio = 0.5;

<<<<<<< HEAD
formats = {'jxr'};
avgSize = 4e+05;
size = inf;

=======
formats = {'jpg'};
avgSize = 4e+05;
size = inf;

fid = fopen(fullfile(resDir,'sizes.txt'), 'at');
fprintf(fid, '\n//%s %s\n', srcname, datestr(datetime('now')));
>>>>>>> eda4c1669dd4247f3d4545871463de02e6b592fd
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
        mkdir(gtDir);
        copyfile(fullfile(dataDir,[srcname,'_gt/*']), gtDir);
        ratio = ratio/2;
        index = index+1;
    end
end
t = table;
t.Name = Name';
t.Duration = Duration';
t.AvgSize = AvgSize';
writetable(t, fullfile(resDir,'convert.txt'));
<<<<<<< HEAD
=======
fclose(fid); 
>>>>>>> eda4c1669dd4247f3d4545871463de02e6b592fd