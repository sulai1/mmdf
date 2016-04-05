#include "mex.h"
#include "matrix.h"
#include "stdio.h"

int getFormat(char* string, size_t length);
/* The gateway function */
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
    /*/break if to few args*/
    if(nrhs<2)
        mexErrMsgIdAndTxt("MMDF:test:prhs","Specify an input and output name.");
 
    /* variable declarations here */   
    double quality = 0.0;
    int overlap = 1;
    int chrom = 1;
    char *out, *in;
    int lengthIn = mxGetN(prhs[0]);
    int lengthOut = mxGetN(prhs[1]);
    
    /* get mandatory arguments */
    in = mxArrayToString(prhs[0]);
    if(in == NULL)
        mexErrMsgIdAndTxt("MMDF:test:prhs","Specify an input image name as first argument.");
    out = mxArrayToString(prhs[1]);
    if(out == NULL)
        mexErrMsgIdAndTxt("MMDF:test:prhs","Specify an output image name as second argument.");   
    
    /* optional arguments */
    
    /*/ get the quality level [0-1] to use or the quantisation[1-255]*/
    if(nrhs >= 3){ 
        quality = mxGetScalar(prhs[2]);
    }
    /*/ get the chrominance sub sampling value 0 for grayscale only 1 for max chrominance*/
    if(nrhs >= 4){ 
        chrom = (int)mxGetScalar(prhs[3]);
    }
    /*/ get the overlap 0 = no overlap, 1 for overlap on 4x4 blocks , 2 for overlap on 16x16 blocks*/
    if(nrhs >= 5){   
         overlap = (int)mxGetScalar(prhs[4]);
    }
    char buffer[256];
    /* if one of the formats is jxr the jxrjib needs to be used */
    if(getFormat(out,mxGetN(prhs[1]))==3){
       /* We should handle this in an higher level function  */
       /* snprintf(buffer, 256,"convert %s tmp.bmp", in);
        system(buffer); */
           
        snprintf(buffer, 256,"JxrEncApp -i tmp.bmp -o %s -q %f -c 0 -d %d -l %d",out,quality,chrom,overlap);
    }
    /* http://www.imagemagick.org/Usage/formats/#jpg */
    else if(getFormat(out,mxGetN(prhs[1]))==2){
        snprintf(buffer, 256,"convert %s -compress jpeg2000 -quality %f %s", in,quality, out);
    }
    else
        snprintf(buffer, 256,"convert %s -quality %f %s", in,quality, out);
    printf("%d : %f,%d,%d\n",nrhs , quality, chrom, overlap);
    printf("%s\n",buffer);
    system(buffer);
    mxFree(in);
    mxFree(out);
}

int getFormat(char* string, size_t length){
    if(length<3)
        return-1;
    if(string[length-3]=='j'){
        if(string[length-2]=='p'){
            if(string[length-1]=='g')
                return 1;
            else if(string[length-1]=='2')
                return 2;   
        }else if(string[length-2]=='x'&&string[length-1]=='r')       
            return 3;
    }else if(string[length-3]=='b'&&string[length-2]=='m'&&string[length-1]=='p')      
        return 0;
    return -1;
}
