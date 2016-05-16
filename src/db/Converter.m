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
            if(out(end-3:end)==Converter.BMP)
                if(in(end-3:end)==Converter.JXR)
                    Converter.convertJXR(in,out,quality,bGrayscale);
                else
                    Converter.convertMagick(in,out,quality,bGrayscale);
                end
            elseif(in(end-3:end)==Converter.BMP)
                %% check output file type
                switch(out(end-3:end))
                    case Converter.JPG
                        Converter.convertMagick(in,out,quality,bGrayscale);
                    case Converter.J2P
                        Converter.convertMagick(in,out,quality,bGrayscale);
                    case Converter.JXR
                        Converter.convertJXR(in,out,quality,bGrayscale);
                end
            else 
                error('not supported conversion %s -> %s',in,out);
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
            d = dir(in);
            size = d(1).bytes;
            while(size>extent&&max-min>0.01)%there are only 100 quality levels
                Converter.convert(in, out, max);
                %% convert and check size
                d = dir(out);
                size = d(1).bytes;
                %% calculate new quality
                if(extent<size)%to big
                    max = max-(max-min)/2;
                else%to small
                    tmp = max;
                    max= max +(max-min)/2;
                    min = tmp;
                end
            end
        end
    end
    
    
end

