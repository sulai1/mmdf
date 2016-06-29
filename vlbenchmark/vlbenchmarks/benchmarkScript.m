clc;

import localFeatures.*    

    addpath('/home/sulai/Desktop/mexopencv-2.4');

    featExtractors{1} = SURFDetector('HessianThreshold', 100, 'NOctaves', 8, ...
        'NOctaveLayers', 4);
    featExtractors{2} = VlFeatSift();
    featExtractors{3} = ORBDetector('NFeatures', 8000, 'ScaleFactor', 1.1, 'NLevels', 16);
    featExtractors{4} = PHOWDetector('Sizes',16,'Step',16);
    
    folder = 'data/datasets/vggRetrievalDataset';
    
    Format = 'jxr'; % format or name of the set(s)
    
    all = dir(fullfile(folder, [Format,'*']));
    
    numDet = numel(featExtractors); 
    names = cell(1,length(all)/2);
    numSets = numel(names);
    
    sizes = zeros(numSets);
    
    for i=1:numSets
        names{i} = all(i*2-1).name;
        nr = names{i}(5:end);
        sizes(i) = str2double(nr);
    end
    
    [B, I] = sort(sizes);
    sorted = cell(1,length(all)/2);
    
    for  i=1:numSets
        sorted(i) = names(I(i));
    end
    
    mAP = zeros(numSets, numDet);
    labels = zeros(1,numSets);
    detNames = cell(1,numDet);
    prcs = cell(numDet,numSets);
    steps = 20;
    queriesAp = cell(1,numSets);
    for i=1:numSets
       labels(i) = round(str2double(sorted{i}(5:end)),2);
       [map, avgDesc, queriesAp{i}, prc]= retrievalBenchmark(sorted{i}, featExtractors, steps); 
       mAP(i,:) = map;
       for d=1:numDet
            prcs{d,i} = prc{d};
            detNames{d} = featExtractors{d}.Name;
       end
    end
    plotRes;
