
import localFeatures.*

featExtractors = cell(1,1);
featExtractors{1} = PHOWDetector('Sizes',16,'Step',16);
featExtractors{2} = PHOWDetector('Color','gray','Sizes',16,'Step',16);
    
folder = '/media/sf_Shared_Folder/vlbenchmark/vlbenchmarks/data/datasets/vggRetrievalDataset';

disp(retrievalBenchmark('test', featExtractors, fullfile(folder,'res')))