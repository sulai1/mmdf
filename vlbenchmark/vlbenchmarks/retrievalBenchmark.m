function mAP = retrievalBenchmark( name, featExtractors, resultsPath )
    %function [mAP queriesAp] = retrievalDemo(resultsPath)
    % RETRIEVALDEMO Demonstrates how to run the retrieval benchmark
    %   RETRIEVALDEMO() Runs the repeatability demo.
    %
    %   RETRIEVALDEMO(RESULTS_PATH) Run the demo and save the results to
    %   path RESULTS_PATH.

    % Authors: Karel Lenc and Andrea Vedaldi

    % AUTORIGHTS
    t0 = cputime;

    if nargin < 1, resultsPath = ''; end;

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
    retBenchmark = RetrievalBenchmark('MaxNumImagesPerSearch',100);

    % Define the dataset which will be used for the benchmark. In this case we
    % will use 'oxbuild' dataset (Philbin, CVPR07) which originally consists
    % from 5k images. In order to compute the results in a reasonable time, we
    % will select only subset of the images. Wrapper of this data/home/sulaiset uniformly
    % samples the subsetsxr
    respath = 'res';
    t = datetime('now');
    signature = [name,datestr(t,'mm.dd.yy.HH.MM.SS')];
    mkdir(fullfile(respath, name));
    dataset = VggRetrievalDataset('Category',name,...
                                  'GoodImagesNum',inf,...
                                  'OkImagesNum',inf,...
                                  'JunkImagesNum',inf,...
                                  'BadImagesNum',30);
                              
    % Run the test for all defined feature extractors
    % Run the test for all defined feature extractors
    for d=1:numel(featExtractors)
        t1 = cputime;
      [mAP(d) info(d)] =...
        retBenchmark.testFeatureExtractor(featExtractors{d}, dataset);
        e = cputime - t1;
        fprintf('retrieval benchmark : %s \nfeature extractor : %s\n finished after %d sec.\n',name,featExtractors{d}.Name,e);
    end
    
    %% PART 2: Average precisions

    figure(1); clf;
    bar(mAP);
    set(gca,'XTickLabels',detNames); 
    xlabel('FeatureDetector'); ylabel('mAP');
    
    
    % For all the tested feature extractors we get single value which asses
    % detector performance on the dataset.

    %%

    % Calc average number of descriptors per dataset image
    numDescriptors = cat(1,info(:).numDescriptors);
    numQueryDescriptors = cat(1,info(:).numQueryDescriptors);
    avgDescsNum(1,:) = mean(numDescriptors,2);
    avgDescsNum(2,:) = mean(numQueryDescriptors,2);
    printScores(detNames, avgDescsNum,{'Avg. #Descs.','Avg. #Query Descs.'});

    %% save text data
    file = fullfile(respath,name,sprintf('%sresults.txt',signature));
    fid = fopen(file, 'at');
    fprintf(fid,'%s :',name);
    fprintf(fid,'\t%s\n', helpers.struct2str(dataset.Opts));
    for i=1:numel(featExtractors)
        opts = featExtractors{i}.Opts;
        fprintf(fid, '\t%s :',featExtractors{i}.Name);
        if isstruct(opts)
            fprintf(fid, '\t%s',helpers.struct2str(opts));
        end
        fprintf(fid,'\n\t\t%d mAP. \n\t\t%d Avg. #Descs. \n\t\t%d Avg. #Query Descs\n',mAP(i),avgDescsNum(1,i), avgDescsNum(2,i));
    end
    fprintf(fid,'\n');
    fclose(fid);

    figure(2); clf;
    queriesAp = cat(1,info(:).queriesAp); % Values from struct to single array
    selectedQAps = queriesAp(:,:); % Pick only first 15 queries
    bar(selectedQAps');
    grid on;
    set(gca,'XTick',1:size(selectedQAps,2)); 
    set(gca,'XLim',[0,size(selectedQAps,2)+1]);
    legend(detNames,'Location','SE'); 
    xlabel('Query #'); ylabel('Average precision');
    helpers.printFigure(resultsPath,'queriesAp',0.6);
    savefig(fullfile(respath, name, [signature,'querries.fig']))

    % --------------------------------------------------------------------
    %% PART 3: Precision recall curves
    % --------------------------------------------------------------------

    % More detailed results can be seen from the precision/recall curves which
    % retain the retrieval system performance.

    queryNum = 1;
    query = dataset.getQuery(queryNum);

    for d=1:numel(featExtractors)
      rankedList = info(d).rankedList(:,queryNum);
      [ap recall(:,d) precision(:,d)] = ...
        retBenchmark.rankedListAp(query, rankedList);
    end
    figure(3); clf;
    plot(recall, precision,'LineWidth',2); 
    xlabel('recall'); ylabel('Precision');
    grid on; legend(detNames,'Location','SW');
    helpers.printFigure(resultsPath,'prc',0.5);
    savefig(fullfile(respath,name, [signature,'prc.fig']))

    % --------------------------------------------------------------------
    %% PART 4: Plot a query results
    % --------------------------------------------------------------------

    function printScores(detectorNames, scores, names)
      maxDetNameLen = 0;
      for k = 1:numel(detectorNames)
        maxDetNameLen = max(maxDetNameLen,length(detectorNames{k}));
      end
      maxNameLen = 0;
      for k = 1:numel(names)
        maxNameLen = max(maxNameLen,length(names{k}));
      end
      fprintf('\n');
      detNameFormat = ['\t%' sprintf('%d',maxDetNameLen) 's'];
      nameFormat = ['%' sprintf('%d',maxNameLen) 's'];
      fprintf(nameFormat,'');
      cellfun(@(a) fprintf(detNameFormat,a),detectorNames);
      fprintf('\n');
      for k=1:numel(names)
        fprintf(nameFormat,names{k});
        arrayfun(@(a) fprintf(detNameFormat,sprintf('%.3f',a)),scores(k,:));
        fprintf('\n');
      end
    end
    e = cputime - t0;
    fprintf('retrieval benchmark : %s \n finished after %d sec.\n',name,e);
   
end


