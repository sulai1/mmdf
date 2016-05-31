#Project description
This projects purpose is to test the influence of compression on image retrieval tasks using Matlab. Therefore it runs a retrievalbenchmark on both the uncompressed and compressed datasets and compares the results. Supported compressions are JPEG, JPEG 2000 and JPEG XR and the used benchmark is a modified retrieval benchmark from the vlbenchmark project that uses different feature detectors. 
##Setup instructions
The project contains of two parts the **converter** and the **benchmark**. They are completely seperate applications so they can run on different systems. In this setup the **converter** is compiled on Windows 10 with Visual Studio 2015 and the **benchmark** is compiled for linux, because it depends on libraries (YAEL) that are not compatible with Windows. So in this case u have to convert the database and copy it to the linux system(or use a virtual box and do everithing with a shared folder) and then run the benchmark with the converted dataset.

###Install ImageMagick
Download and install ImageMagick from http://www.imagemagick.org/script/binary-releases.php.
I used the <ImageMagick-6.9.3-7-Q16-x64-dll.exe> for windows 10 which provides an installer.
Follow installation instruction and add it to the PATH variable so its visible to the application.

###Install JXRLIB

 Dowlnoad jxrlib from https://jxrlib.codeplex.com/. Next unpack the files. Its a source distribution and you need to compile them yourself. There are to ways to do this. 
        
 ```
1. open the visual studio solution located in the  <jxrencoderdecoder> folder and simply compile it with  visual studio.
2. Compile it with the makefile located  in the root
```
       
>Add Path variables
For the jxrlib the executables should be located in the folder or in a subfolder where it was compiled. There should be two executables. One is called “JXREncApp” and one called “JXRDecApp”. Copy them to the installation directory of ImageMagick where the other needed executables like “convert” are located. Now we can set the Path environment variable to the installation directory of image magick and it will find all the programs needed for compression. So simply add the path of the installation directory to the path environment variable.

###Use of applications
Now that the programs are known u can test them from the command line and in the following two chapters I will briefly introduce the commands and the parameters we might use, for further details look at the documentation. 

###Use of JXRLIB
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
###Use of ImageMagick
Image magick may be used to compress between other needed formats(JPEG, JPEG 200 and BMP).

####JPEG conversion
-quality luminance,chrominance JPEG compression level
-define jpeg:extent=value to restrict filesize
convert <path\to\file\image.bmp> <path\to\newfile\image.jpg> -qaulity 90,70 -define jpeg:extent=400KB

####JPEG 2000
-define jp2:rate=value define the compression rate
convert <path\to\file\image.bmp> <path\to\newfile\image.jpg> -define jp2:rate=0.9
there are many other detailed options all listed at http://www.imagemagick.org/script/command-line-options.php#define
Use of the tools in side Matlab
Inside Matlab it is possible to call programms through the system(cmd) function.

###VLBenchmark
Todo the testing we use the vlbenchmark matlab toolbox. Download and extract the files to <vlbenchmark_path>. Open the <vlbenchmark_path> in Matlab and run the install.m file. Next run the retrievaldemo. The installation will fail because it is not able to download the yael library, so you have to download and extract it yourself. The error message will tell you where to extreact the library and that you should put a empty file into that directory with a specified name, so that it knows that the library is already extracted. If the retrievaldemo is working then we are ready for the benchmarking.

###Opencv
Simple way:
	$ sudo apt-get install libopencv-dev 
	$sudo add-apt-repository --yes ppa:xqms/opencv-nonfree
	$ sudo apt-get update
	$ sudo apt-get install libopencv-nonfree-dev


###mexopencv
Download a Version of mexopencv that is compatible with the version of opencv. Change to the folder of mexopencv run make and pass it the Matlab directory:
make MATLABDIR=/dir/to/matlab/

##Usage

###Converter
The converter is a seperate application, that wraps ImageMagick and the JXRLIB to allow simple conversion of images with a given ratio, to and from jpg, jp2 and jxr. It also stores the average filesize in bytes to a file called sizes.txt. To convert a dataset thats simmilar to the vlbenchmark oxbuild dataset you simply give it the image directory and the name of the gt file. An exemple application is the ConverterDemo, which converts the oxbuild dataset to different compression types with different ratios. In a second step the images are compressed back lossless so that the benchmark is able to read the images.

###Benchmark
The vlbenchmark has been modified to accept custom datasets. The datasets need to be similar to the oxbuild dataset. The benchmark now also stores the results to files that are labeled with their name and the date, in a folder thats labeled with the name of the dataset. There are also new FeatureDetectors that are located in the same folder as the vlbenchmark detectors. To implement a new one modify the ExampleLocalFeatureExtractor class or if you want to implement a detector thats using opencv inherit the CVDetector, that provides helpers vor opencv feature detectors, and implement the abstract methods, properties and call the super constructor. For an example look at the ORBDetector.
```
Important files that are modified or created in the vlbenchmark are:
- retrievaldemo
- +datasetsVggRetrievalDataset
- +localfeatures/CVDetector
- +localfeatures/ORBDetector
- +localfeatures/SURFDetector
- +localfeatures/PHOWDetector
```
###Workflow
- use the Converter.convertDB to generate the compressed dataset(look at the ConverterDemo.m script for details). You have to specify a source, target format and the compression ratio. The function generates two folders. One contains the images(called **Format_Ratio**) and the other containes the querries(called **Format_Ratio**_gt), eg. jpg_0.1 and jpg_0.1_gt.
- copy the files(if not allready in the right place) to the folder where vlbenchmark stores its datasets(vlbenchmark/vlbenchmarks/data/datasets/vggRetrievalDataset);
- run the retrievalBenchmark and pass it the name of the dataset. The results will be stored in a subfolder called res.
