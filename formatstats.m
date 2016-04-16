classdef formatstats
    %CONVERTERTOOL Summary of this class goes here
    %   Detailed explanation goes here
    
    methods (Static)
        function init()
            %convert to different formats and create a bmp
            for i=1:100
                 string = sprintf('res/jxr/test%03i.jxr',i);
                 convert(file,string ,i/100);

                 string2 = sprintf('res/jxr/test%03i.bmp',i);
                 convert(string ,string2);

                 string = sprintf('res/jp2/test%03i.jp2',i);
                 convert(file,string ,i);

                 string2 = sprintf('res/jp2/test%03i.bmp',i);
                 convert(string ,string2);

                 string = sprintf('res/jpg/test%03i.jpg',i);
                 convert(file,string ,i);

                 string2 = sprintf('res/jpg/test%03i.bmp',i);
                 convert(string ,string2);
            end
        end
        function plot()
            jxrInfo = dir('res/jxr/test*.jxr');
            jp2Info = dir('res/jp2/test*.jp2');
            jpgInfo = dir('res/jpg/test*.jpg');

            res = 1:length(jpgInfo);
            res1 = 1:length(jpgInfo);
            res2 = 1:length(jpgInfo);

            for i=1:length(jpgInfo)
                res(i) = log(jpgInfo(i).bytes);
                res1(i) = log(jp2Info(i).bytes);
                res2(i) = log(jxrInfo(i).bytes);
            end

            plot(res)
            hold on
            plot(res1)
            hold on
            plot(res2)
            hold on
            info = dir('tmp.bmp');
            plot(log(zeros(length(jpgInfo))+info(1).bytes));

            legend('jxr', 'jp2','jpg','bmp');
        end
    end
    
end

