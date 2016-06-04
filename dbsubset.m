function [ queries good ok junk] = dbsubset( nQueries , newName)
%DBSUBSET Gernerates a rnd subset of the oxbuild DATASET
%   Select random subsets from the queries and optionaly random subset of
%   images per querry and create a folder with only the number of images
%   that the queries will use
nGood = 10;
nOk = 10;
nJunk = 10;
seed = 1;
path = fullfile('vlbenchmark','vlbenchmarks','data','datasets','vggRetrievalDataset');
gtPath = fullfile(path,'oxbuild_gt');
imgPath = fullfile(path,'oxbuild');
%% load all queries
queries = dir(fullfile(gtPath, '*query.txt'));
good = dir(fullfile(gtPath, '*good.txt'));
ok = dir(fullfile(gtPath, '*ok.txt'));
junk = dir(fullfile(gtPath, '*junk.txt'));

%% fill new dtDir with random queries
newGTPath = fullfile(path,[newName,'_gt']);
if(~exist(newGTPath,'dir'))
    mkdir(newGTPath );
end
rng(seed);
nq = length(queries);
l = 1;
alllines = cell(2);
%% function to select random number od lines from a file and write it to a new one
    function cpSubset(in,out,nLines)
        % open files
        fin = fopen(in , 'r');
        fout = fopen(out,'w');
        
        %read all lines
        line = fgets(fin);
        k = 1;
        while ischar(line)
            lines{k} = line;
            alllines{l} = line;
            l = l+1;
            k=k+1;
            
            line = fgets(fin);
        end
        % select the images to retain from the query and write to new file
        indices = randi(length(lines),1,nLines);
        for j=1:nLines
            fwrite(fout,lines{indices(j)});
        end
        
        % close files
        fclose(fout);
        fclose(fin);
    end
%% select the query images to use
for i=1:nQueries
    % select the query
    index = randi(nq);
    
    % copy rnd subsets of lines from the file
    goodName = good(index).name;
    cpSubset(fullfile(gtPath,goodName),fullfile(newGTPath,goodName),nGood);
    goodName = ok(index).name;
    cpSubset(fullfile(gtPath,goodName),fullfile(newGTPath,goodName),nOk);
    goodName = junk(index).name;
    cpSubset(fullfile(gtPath,goodName),fullfile(newGTPath,goodName),nJunk);
    
    % copy the query
    copyfile(fullfile(gtPath,queries(index).name), fullfile(newGTPath,queries(index).name));
end

%% copy all images used by the query
allimages = unique(alllines);
nImages = length(allimages);
newImgPath = fullfile(path,newName);
mkdir(fullfile(newImgPath));
for i=1:nImages
    name = [allimages{i}(1:end-1),'.jpg'];
    copyfile(fullfile(imgPath,name),newImgPath);
end

end