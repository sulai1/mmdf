Setup instructions
Install ImageMagick
Download and install ImageMagick from http://www.imagemagick.org/script/binary-releases.php.
I used the <ImageMagick-6.9.3-7-Q16-x64-dll.exe> for windows 10 which provides an installer.
Follow installation instruction.
Install JXRLIB
 Dowlnoad jxrlib from https://jxrlib.codeplex.com/. Next unpack the files. Its a source distribution and you need to compile them yourself. There are to ways to do this. 
1. open the visual studio solution located in the  <jxrencoderdecoder> folder and simply compile it with  visual studio.
2. Compile it with the makefile located  in the root
I used the first method.
Add Path variables
For the jxrlib the executables should be located in the folder or in a subfolder where it was compiled. There should be two executables. One is called “JXREncApp” and one called “JXRDecApp”. Copy them to the installation directory of ImageMagick where the other needed executables like “convert” are located. Now we can set the Path environment variable to the installation directory of image magick and it will find all the programs needed for compression. So simply add the path of the installation directory to the path environment variable.
Use of applications
Now that the programs are known u can test them from the command line and in the following two chapters I will briefly introduce the commands and the parameters we might use, for further details look at the documentation. 
Use of JXRLIB
For encoding or decoding JPEG XR the JXRLIB will be used for all other purposes ImageMagicks convert tool will be used. Note that JXRLIB only supports limited number of input format. In our case we will use the bmp format 24bit bgr.
 I will briefly introduce the commands and the parameters we might use, for further details look at the documentation.
encode a  24bit BGR Bitmap to JPEG XR with default parameters
jxrencapp -i <path\to\file\image.bmp> -o <path\to\newfile\image.jxr>
there are three parameters that influence the filesize/compressionrate
-q quality[0.0-1.0] or quantization[1-255] default 1.0 = lossless, 1 = lossless
-d chroma subsampling [0-3] 0 = intensity only, 1 = YCoCg 4:4:4 (default)
-l overlapping [0-2] 0 = No overlapping, 1 = 1 level overlapping(default) , 2 = 2 level overlapping. 
jxrencapp -i <path\to\file\image.bmp> -o <path\to\newfile\image.jxr> -q <?> -d <?> -l<?>
to decode it simply follow the same syntax but with different additional controll parameters mostly not that important, i will not discuss but rather refer to the documentation.
jxrencapp -i <path\to\file\image.jxr> -o <path\to\newfile\image.bmp>
Use of ImageMagick
Image magick may be used to compress between other needed formats(JPEG, JPEG 200 and BMP).

JPEG conversion
-quality luminance,chrominance JPEG compression level
-define jpeg:extent=value to restrict filesize
convert <path\to\file\image.bmp> <path\to\newfile\image.jpg> -qaulity 90,70 -define jpeg:extent=400KB
JPEG 2000
-define jp2:rate=value define the compression rate
convert <path\to\file\image.bmp> <path\to\newfile\image.jpg> -define jp2:rate=0.9
there are many other detailed options all listed at http://www.imagemagick.org/script/command-line-options.php#define
Use of the tools in side Matlab
Inside Matlab it is possible to call programms through the system(cmd) function.

VLBenchmark
Todo the testing we use the vlbenchmark matlab toolbox. Download and extract the files to <vlbenchmark_path>. Open the <vlbenchmark_path> in Matlab and run the install.m file. Next run the retrievaldemo. The installation will fail because it is not able to download the yael library, so you have to download and extract it yourself. The error message will tell you where to extreact the library and that you should put a empty file into that directory with a specified name, so that it knows that the library is already extracted. If the retrievaldemo is working then we are ready for the benchmarking.
Opencv
Simple way:
	$ sudo apt-get install libopencv-dev 
	$sudo add-apt-repository --yes ppa:xqms/opencv-nonfree
	$ sudo apt-get update
	$ sudo apt-get install libopencv-nonfree-dev


mexopencv
Download a Version of mexopencv that is compatible with the version of opencv. Change to the folder of mexopencv run make and pass it the Matlab directory:
make MATLABDIR=/dir/to/matlab/
