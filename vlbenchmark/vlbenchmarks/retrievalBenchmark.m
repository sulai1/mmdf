function [mAP, avgDescsNum, queriesAp,prc] = retrievalBenchmark( name, featExtractors, nSteps)
    %function [mAP queriesAp] = retrievalDemo(resultsPath)
    % RETRIEVALDEMO Demonstrates how to run the retrieval benchmark
    %   RETRIEVALDEMO() Runs the repeatability demo.
    %
    %   RETRIEVALDEMO(RESULTS_PATH) Run the demo and save the results to
    %   path RESULTS_PATH.

    % Authors: Karel Lenc and Andrea Vedaldi


    % --------------------------------------------------------------------
    % PART 1: Run the retrieval test
    % --------------------------------------------------------------------

    import localFeatures.*;
    import datasets.*;
    import benchmarks.*;
    import helpers.*

    % Define the features extractors which will be tested with the retrieval
    % benchmark.

    nExtractors =length(featExtractors); 
    detNames = cell(1,nExtractors);
    
    for i=1:nExtractors
       detNames{i} = featExtractors{i}.Name;
    end
    
    % Define the benchmark class. This implements simple retrieval system which
    % uses extracted features in a K-Nearest Neighbour search in order to
    % retrieve queried images. Ranked set of retrieved images is then evaluated
    % measuring the mean average precision of all queries.
    % Parameter 'MaxNumImagesPerSearch' sets in how big chunks the dataset
    % should be divided for the KNN search.
    retBenchmark = RetrievalBenchmark('MaxNumImagesPerSearch',50);

    % Define the dataset which will be used for the benchmark. In this case we
    % will use 'oxbuild' dataset (Philbin, CVPR07) which originally consists
    % from 5k images. In order to compute the results in a reasonable time, we
    % will select only subset of the images. Wrapper of this data/home/sulaiset uniformly
    dataset = VggRetrievalDataset('Category',name,...
                                  'GoodImagesNum',30,...
                                  'OkImagesNum',30,...
                                  'JunkImagesNum',30,...
                                  'BadImagesNum',50);
                              
                              
    % Run the test for all defined feature extractors
    % Run the test for all defined feature extractors
    for d=1:numel(featExtractors)
        t1 = cputime;
      [mAP(d) info(d)] =...
        retBenchmark.testFeatureExtractor(featExtractors{d}, dataset);
        e = cputime - t1;
        fprintf('retrieval benchmark : %s \nfeature extractor : %s\n finished after %d sec.\n',name,featExtractors{d}.Name,e);
    end


    %%

    % Calc average number of descriptors per dataset image
    numDescriptors = cat(1,info(:).numDescriptors);
    numQueryDescriptors = cat(1,info(:).numQueryDescriptors);
    avgDescsNum(1,:) = mean(numDescriptors,2);
    avgDescsNum(2,:) = mean(numQueryDescriptors,2); 
    queriesAp = cat(1,info(:).queriesAp); % Values from struct to single array

    % --------------------------------------------------------------------
    %% PART 3: Interpolated Precision recall curves
    % --------------------------------------------------------------------

    % More detailed results can be seen from the precision/recall curves which
    % retain the retrieval system performance. The precision/recall curves
    % are interpolated to get a nice overview of all queries

    prec = cell(numel(featExtractors), dataset.NumQueries);
    rec = cell(numel(featExtractors), dataset.NumQueries);
    steps = 0:0.1:1;
    for i=1:dataset.NumQueries
        query = dataset.getQuery(i);

        for d=1:numel(featExtractors)
          rankedList = info(d).rankedList(:,d);
          [ap, recall, precision] = ...
            retBenchmark.rankedListAp(query, rankedList);
            prec{d,i} = precision;
            rec{d,i} = recall;
        end
    end
    nEl = numel(featExtractors);
    for d=1:nEl-1
        p = (prec(d,:));
        r = (rec(d,:));
        prc{d} = prcinterp(p, r,steps);
        plot(steps,prc{d});
        hold on
    end
    p = (prec(nEl,:));
    r = (rec(nEl,:));
    prc{nEl} = prcinterp(p, r,steps);
end


