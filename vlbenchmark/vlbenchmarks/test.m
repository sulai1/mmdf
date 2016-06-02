
import localFeatures.*
    featExtractors{1} = VlFeatSift();

    featExtractors{2} = SURFDetector('HessianThreshold', 100, 'NOctaves', 8, ...
        'NOctaveLayers', 4);

    featExtractors{3} = ORBDetector('NFeatures', 3500, 'ScaleFactor', 1.4, 'NLevels', 16);

    featExtractors{4} = PHOWDetector();

    featExtractors{5} = PHOWDetector('Color','gray');
    
    folder = '/media/sf_Shared_Folder/vlbenchmark/vlbenchmarks/data/datasets/vggRetrievalDataset';
    
    all = dir(fullfile(folder, 'jpg*'));
    
    names = cell(1,length(all)/2);
    
    for i=1:length(names)
        names{i} = all(i*2-1).name;
    end
    
    disp(names)
    
    for i=1:length(names)
       retrievalBenchmark(names{i}, featExtractors, fullfile(folder,'res')); 
    end