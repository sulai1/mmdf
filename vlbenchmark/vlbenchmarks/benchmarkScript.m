
import localFeatures.*
    featExtractors{1} = SURFDetector('HessianThreshold', 100, 'NOctaves', 8, ...
        'NOctaveLayers', 4);

    featExtractors{2} = VlFeatSift();
    featExtractors{3} = ORBDetector('NFeatures', 8000, 'ScaleFactor', 1.1, 'NLevels', 16);

    featExtractors{4} = PHOWDetector('Sizes',16,'Step',16);
    featExtractors{5} = PHOWDetector('Color','gray','Sizes',16,'Step',16);
    
    folder = '/media/sf_Shared_Folder/vlbenchmark/vlbenchmarks/data/datasets/vggRetrievalDataset';
    
    all = dir(fullfile(folder, 'oxbuild*'));
    
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
    for i=1:numSets
       labels(i) = round(str2double(sorted{i}(5:end)),2);
       [map, avgDesc, queriesAp]= retrievalBenchmark(sorted{i}, featExtractors, fullfile(folder,'res')); 
       mAP(i,:) = map;
    end
    
    %%print mAP
    figure(1); clf;
    for i=1:numDet-1
        plot(mAP(:,i));
        hold on
    end
    
    disp('mAP');
    disp(mAP);
    disp('avgDesc');
    disp(avgDesc);
    disp('queriesAp');
    disp(queriesAp)