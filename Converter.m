classdef Converter
    
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)
        TOLERANCE = 0.1;%tolerance of 10%
        BMP = '.bmp';
        JPG =  '.jpg';
        J2P =  '.jp2';
        JXR =  '.jxr';
    end
    
    methods (Static)
        
        %%convert the given input image to out. filending used to detect
        %format
        function convert(in,out,quality)
            Converter.parconvert(in,out,0,quality);
        end
        
        %% parallel conversion depends on unique id
        function parconvert(in,out,id,quality)
           	tmpid = sprintf('tmp_%d.bmp',id);
            
            %% check input file type
            intype = in(end-3:end);
            outtype = out(end-3:end);
            if(outtype==Converter.JXR)
                if(in(end-3:end)==Converter.BMP)
                    Converter.convertJXR(in,out,quality);
                else % workaround for ~bmp -> jxr
                    Converter.convertMagick(in,tmpid,quality);
                    Converter.convertJXR(tmpid,out,quality);
                    delete(tmpid);
                end
            elseif(intype==Converter.JXR)
                %% check output file type
                if strcmp(outtype,Converter.BMP)
                    Converter.convertJXR(in,out,quality);
                else % workaround for jxr -> ~bmp
                    Converter.convertJXR(in,tmpid,quality);
                    Converter.convertMagick(tmpid,out,quality);
                    delete(tmpid);
                end
            else 
                Converter.convertMagick(in,out,quality);
            end
        end
        
        %%conversion using ImageMagick
        function convertMagick(in,out,quality)
            if strcmp(out(end-3:end), Converter.JPG);
                system(sprintf('convert %s -quality %u,%u  -define jpeg:dct-method=float -define jpeg:optimize-coding=off %s',in, round(quality*100), round(quality*100), out));
            else
                 system(sprintf('convert %s -quality %u %s',in, round(quality*100), out));
            end
        end
        
        %%conversion using jxrlib's JXREncApp and JXRDecApp
        function convertJXR(in,out,quality)
            if(out(end-3:end)==Converter.JXR)  %handle gray
                system(sprintf('JxrEncApp -i %s -q %f1.2 -q %u -o %s',in, quality,round((1-quality)*100), out));
             else
                  system(sprintf('JxrDecApp -i %s -o %s',in, out));
            end
        end
        
        %%convert the image so that it not exceeds the extent if possible
        function convert2size(in,out,extent)
            Converter.parConvert2size(in,out,0, extent);
        end
        
        function parConvert2size(in,out,id,extent)
            max = 0.5;
            min = 0;
            if extent < 500
               extent = 500;
            end
            while(abs(max-min)>0.01)%there are only 100 quality levels
                if(max>1)
                    disp('err')
                end
                Converter.parconvert(in, out,id, max);
                %% convert and check size
                d = dir(out);
                size = d(1).bytes;
                %% calculate new quality
                if(extent<size)%to big
                    max = max-(max-min)/2;
                elseif(extent>size)%to small
                    tmp = max;
                    max= max +(max-min)/2;
                    min = tmp;
                else
                    min=max;
                end
            end
        end
        
        %Convert the database contained in the imgDir and gtDir the given
        %directory.Therefore it compresses to the specified format so that
        %it does not extend the given size. If the destination format is
        %not jpg the file is compressed back to lossless jpg so the
        %retrieval demo can handle it.
        function avgSize = convertDB(srcDir,dstDir,srcFormat,dstFormat,sratio)
            if exist(dstDir,'dir')
                avgSize = -1;
              return;
            end
            mkdir(dstDir);
            names = dir(fullfile(srcDir, ['*.',srcFormat])) ;
            imagenames = {names.name};
            nrimg = numel(names);
            sizes = zeros(nrimg);
            parfor i=1: nrimg
               src = fullfile(srcDir,imagenames{i});
               dst = fullfile(dstDir,[imagenames{i}(1:end-3),dstFormat]);
               asjpg = [dst(1:end-3),'jpg'];
               extent = names(i).bytes*sratio;
               Converter.parConvert2size(src,dst,i,extent);
               listing = dir(dst);
               fprintf('converting: %d/%d. %s -> %d bytes\n', ...
                    i, nrimg, dst, listing(1).bytes);
               sizes(i)=listing(1).bytes;
               %if we are not compressing to jpg we have to compress it
               %back lossless for compatibility with the retrieval demo
               if ~strcmp(dstFormat,'jpg')
                   Converter.parconvert(dst,asjpg,i,1.0);
                   delete(dst);
               end
            end
            fid = fopen(fullfile(dstDir,'sizes.txt'),'w');
            for i=1: nrimg
                fprintf(fid,'%f\n',sizes(i));
            end
            fclose(fid); 
            sum = 0;
            count = 0;
            for i=1:nrimg
                if sizes(i)~=0
                    count = count +1;
                end
                sum = sum + sizes(i);
            end
            avgSize = sum/count;
        end
    end
end

