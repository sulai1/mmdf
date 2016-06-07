imgDir = fullfile('vlbenchmark','vlbenchmarks', 'data','datasets','vggRetrievalDataset','oxbuild');
listing = dir(fullfile(imgDir,'*.jpg'));
nImg = numel(listing);
avgSize = sum([listing.bytes])/nImg;
ppi = 0;
for i=1:nImg
    info = imfinfo(fullfile(imgDir, listing(i).name));
    ppi = ppi + info.Width*info.Height;
end
ppi = ppi/nImg;