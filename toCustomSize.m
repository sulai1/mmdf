
function toCustomSize(inimage,goalsize,i,j)
    convert(inimage,'out.jxr',i+abs(i-j)/2,3,0);
    file=dir('out.jxr');   
    newsize=file.bytes;
    if abs(i-j) <= 0.01
        return;
    elseif goalsize > newsize
        toCustomSize(inimage,goalsize,i+abs(i-j)/2,j);
    else
        toCustomSize(inimage,goalsize,i,i+abs(i-j)/2);
    end
end

% function toCustomSize(inimage,goalsize)
% %    quality1=50
%     threshold=5000;   %in bytes
%     quality2=0.5;
%     while true
%         convert(inimage,'out.jxr',quality2,3,0);
% %        convert(inimage,'out.jpg',quality1,0,0);
% %        convert('tmp.bmp','out.jp2',50,0,0);
%         file1=dir('out.jxr');
% %        file2=dir('out.jpg'); file3=dir('out.jp2');
%         compressSize1=file1.bytes;
% %        compressSize2=file2.bytes; compressSize3=file3.bytes;
%         if compressSize1 > goalsize
%             if (checkDeviation(goalsize,compressSize1,threshold)==true)
%                 break;
%             else
%                 quality2=quality2-0.01; %FIXME: we should find a better way for that
%             end
%         elseif compressSize1 < goalsize
%             if (checkDeviation(goalsize,compressSize1,threshold)==false)
%                 quality2=quality2+(1/4 * quality2);
%             else
%                 break;
%             end
%         end 
%     end
% end
    
function x=isInBounds(goalsize,compressSize1,threshold)
    x=false;
    value=abs(goalsize-compressSize1);
    if value < threshold
        x=true;
    end
end
        
    
    