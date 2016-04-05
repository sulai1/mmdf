
%fmt - possible values are jxr,jp2,jpg
%i,j - these are the min and max Quality values. For jxr it is i=0,j=1. For
%jpg and jp2 it is i=1,j=100
function toCustomSize(inimage,fmt,goalsize,i,j)
    convert(inimage,strcat('out.',fmt),i+abs(i-j)/2,3,0);
    file=dir(strcat('out.',fmt));   
    newsize=file.bytes;
    if strcmp(fmt,'jxr')
        if abs(i-j) <= 0.01
            return;
        end
    elseif abs(i-j) <= 1
        return;
    end    
    if goalsize > newsize
        toCustomSize(inimage,fmt,goalsize,i+abs(i-j)/2,j);
    else
        toCustomSize(inimage,fmt,goalsize,i,i+abs(i-j)/2);
    end
end
    
        
    
    