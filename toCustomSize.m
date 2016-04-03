
function toCustomSize(inimage,goalsize)
%    quality1=50
    threshold=5000;   %in bytes
    quality2=0.5;
    while true
        convert(inimage,'out.jxr',quality2,3,0);
%        convert(inimage,'out.jpg',quality1,0,0);
%        convert('tmp.bmp','out.jp2',50,0,0);
        file1=dir('out.jxr');
%        file2=dir('out.jpg');
%        file3=dir('out.jp2');
        compressSize1=file1.bytes;
%        compressSize2=file2.bytes;
%        compressSize3=file3.bytes;
        if compressSize1 > goalsize
            if (checkDeviation(goalsize,compressSize1,threshold)==true)
                break;
            else
                quality2=quality2/2;
            end
        elseif compressSize1 < goalsize
            if (checkDeviation(goalsize,compressSize1,threshold)==false)
                quality2=quality2+(1/4 * quality2);
            else
                break;
            end
        end 
    end
end
    
function x=checkDeviation(goalsize,compressSize1,threshold)
    x=false;
    value=abs(goalsize-compressSize1);
    if value < threshold
        x=true;
    end
end
        
%    if size1 >= size2 & size1 >= size3
%        grSize=size1
%    elseif size2 >= size1 & size2 >= size3
%        grSize=size2
%    else
%        grSize=size3
%    end
    
    