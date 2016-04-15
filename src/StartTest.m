% I = imread('buildings1.bmp');
% image(I);
% I = single(rgb2gray(I)) ;
% 
% [f,d] = vl_sift(I,'PeakThresh',10) ;
% 
% h1 = vl_plotframe(f) ;
% h2 = vl_plotframe(f) ;
% set(h1,'color','k','linewidth',3) ;
% set(h2,'color','y','linewidth',2) ;
run('E:\matlab tools\vlfeat-0.9.20-bin\vlfeat-0.9.20\toolbox\vl_setup')
addpath extraction
i = Image.read('tmp.bmp');
e = SIFTExtractor();
cps = e.extract(i);
e.plot(cps,i);
