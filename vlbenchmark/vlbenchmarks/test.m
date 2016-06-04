
import localFeatures.*

featExtractors = cell(1,1);
featExtractors{1} = VlFeatSift();

featExtractors{2} = SURFDetector('HessianThreshold', 100, 'NOctaves', 8, ...
'NOctaveLayers', 4);

featExtractors{3} = ORBDetector('NFeatures', 8000, 'ScaleFactor', 1.1, 'NLevels', 16);

featExtractors{4} = PHOWDetector('Sizes',16,'Step',16);
featExtractors{5} = PHOWDetector('Color','gray','Sizes',16,'Step',16);

folder = '/media/sf_Shared_Folder/vlbenchmark/vlbenchmarks/data/datasets/vggRetrievalDataset';

disp(retrievalBenchmark('jpg_2.225000e-01', featExtractors, fullfile(folder,'res')))