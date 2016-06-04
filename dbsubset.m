function dbsubset( nQueries , newName)
%DBSUBSET Gernerates a rnd subset of the oxbuild DATASET
%   Select random subsets from the queries and optionaly random subset of
%   images per querry and create a folder with only the number of images
%   that the queries will use
nGood = inf;
nOk = inf;
nJunk = inf;
nBad = 200;
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
        fclose(fin);
        % select the images to retain from the query and write to new file
        if nLines ~= inf
            fout = fopen(out,'w');
            indices = randi(length(lines),1,nLines);
            for j=1:nLines
                fwrite(fout,lines{indices(j)});
            end
            fclose(fout);
        else
            copyfile(in,out);
        end
        % close files
    end
%% select the query images to use
for i=1:nQueries
    % select the query
    index = randi(nq);
    
    % copy rnd subsets of lines from the file
    cpSubset(fullfile(gtPath,good(index).name),fullfile(newGTPath,good(index).name),nGood);
    cpSubset(fullfile(gtPath,ok(index).name),fullfile(newGTPath,ok(index).name),nOk);
    cpSubset(fullfile(gtPath,junk(index).name),fullfile(newGTPath,junk(index).name),nJunk);
    
    % copy the query
    copyfile(fullfile(gtPath,queries(index).name), fullfile(newGTPath,queries(index).name));
    fid = fopen(fullfile(gtPath,queries(index).name),'r');

    %parse the image name of the query and 
    s = fgets(fid);
    x = strfind(s,' ');
    alllines{l} = [s(6:x(1)-1),' '];
    l = l+1;
end

%% select bad images
listing = dir(fullfile(imgPath,'*.jpg'));
names = {listing(:).name};
for i=1:nBad
    name = names{randi([1,numel(names)])}(1:end-3);
    alllines{l} = name;
    l = l+1;
end

allimages = unique(alllines);

%% copy all images used by the query
nImages = length(allimages);
newImgPath = fullfile(path,newName);
if ~exist(fullfile(newImgPath),'dir')
    mkdir(fullfile(newImgPath));
end
for i=1:nImages
    name = [allimages{i}(1:end-1),'.jpg'];
    if ~exist(fullfile(newImgPath,name),'file')
        copyfile(fullfile(imgPath,name),newImgPath);
    end
end

end