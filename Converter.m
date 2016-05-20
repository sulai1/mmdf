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
        function convert(in,out,varargin)
            %% conversion args
            quality = 1;
            quantization = 255;% TODO use quantization
            bGrayscale = 0;
            
            %%check for additional arguments
            if(nargin>2)
                quality = varargin{1};
                if(quality<0||quality>1)
                   error('quality has to be between zero and one.\n value = %f', quality);
                end
            elseif(nargin>=3)
                quantization = varargin{2};
                if(quantization<1||quantization>255)
                   error('quality has to be between 1 and 255.\n value = %u', quantization);
                end
            elseif(nargin==5)
                bGrayscale = varargin{3};
            end    
            
            %% check input file type
            intype = in(end-3:end);
            outtype = out(end-3:end);
            if(outtype==Converter.JXR)
                if(in(end-3:end)==Converter.BMP)
                    Converter.convertJXR(in,out,quality,bGrayscale);
                else
                    Converter.convertMagick(in,'tmp.bmp',quality,bGrayscale);
                    Converter.convertJXR('tmp.bmp',out,quality,bGrayscale);
                    delete('tmp.bmp');
                end
            elseif(intype==Converter.JXR)
                %% check output file type
                if strcmp(outtype,Converter.BMP)
                    Converter.convertJXR(in,out,quality,bGrayscale);
                else
                    Converter.convertJXR(in,'tmp.bmp',quality,bGrayscale);
                    Converter.convertMagick('tmp.bmp',out,quality,bGrayscale);
                    delete('tmp.bmp');
                end
            else 
                Converter.convertMagick(in,out,quality,bGrayscale);
            end
        end
                    
        function convertMagick(in,out,quality,bGrayscale)
            if(bGrayscale==0)
                system(sprintf('convert %s -quality %u %s',in, round(quality*100), out));
            else
                system(sprintf('convert %s -quality %u -colorspace Gray %s',in, round(quality*100), out));
            end
        end
        function convertJXR(in,out,quality,bGrayscale)
            if(out(end-3:end)==Converter.JXR)
                if(bGrayscale~=0)
                    system(sprintf('JxrEncApp -i %s -q %f1.2 -d 0 -o %s',in, quality, out));
                else
                    system(sprintf('JxrEncApp -i %s -q %f1.2 -o %s',in, quality, out));
                end
            else
                  system(sprintf('JxrDecApp -i %s -o %s',in, out));
            end
        end
        
        function convert2size(in,out,extent)
            max = 1;
            min = 0;
            while(abs(max-min)>0.01)%there are only 100 quality levels
                if(max>1)
                    disp('err')
                end
                Converter.convert(in, out, max);
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
            sum = 0;
            count = 0;
            mkdir(dstDir);
            names = dir(fullfile(srcDir, ['*.',srcFormat])) ;
            imagenames = {names.name};
            nrimg = numel(names);
            for i=1: nrimg
               src = fullfile(srcDir,imagenames{i});
               dst = fullfile(dstDir,[imagenames{i}(1:end-3),dstFormat]);
               asjpg = [dst(1:end-3),'jpg'];
               if (~exist(asjpg,'file')) %skip if allready in folder to resume in case of interrupt
                   count = count+1;
                   extent = names(i).bytes*sratio;
                   Converter.convert2size(src,dst,extent);
                   listing = dir(dst);
                   fprintf('converting: %d/%d. %s -> %d bytes\n', ...
                        i, nrimg, dst, listing(1).bytes);
                   sum = sum + listing(1).bytes;  
                   %if we are not compressing to jpg we have to compress it
                   %back lossles for compatibility with the retrieval demo
                   if ~strcmp(dstFormat,'jpg')
                       Converter.convert(dst,asjpg,1.0);
                       delete(dst);
                   end
               end
               avgSize = sum / count;
            end
        end
    end

end

