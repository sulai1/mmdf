x = cputime;
<<<<<<< HEAD
system('JXREncApp -i test.bmp -o t21.jxr -q 0.0 -q 100 -d 0');
disp(sprintf('jxr min : %fsec', cputime-x));

x = cputime;
system('JXREncApp -i test.bmp -o t22.jxr -q 1.0 -q 0');
disp(sprintf('jxr max : %fsec', cputime-x));

x = cputime;
system('convert  test.bmp  -quality 0,255 t21.jpg');
disp(sprintf('jpg min : %fsec', cputime-x));

x = cputime;
system('convert  test.bmp  -quality 100 t22.jpg');
disp(sprintf('jpg max : %fsec', cputime-x));

x = cputime;
system('convert  test.bmp  -quality 0 t21.jp2');
disp(sprintf('jpg min : %fsec', cputime-x));

x = cputime;
system('convert  test.bmp  -quality 20 t22.jp2');
=======
system('JXREncApp -i test.bmp -o t21.jxr -q 0.0 -q 255 -d 0');
disp(sprintf('jxr min : %fsec', cputime-x));

x = cputime;
system('JXREncApp -i test.bmp -o t22.jxr -q 1.0 -q 0 -d 4');
disp(sprintf('jxr max : %fsec', cputime-x));

x = cputime;
system('convert  t2.jpg  -quality 0,0 -sampling-factor 2x2 -define jpeg:dct-method=float -define jpeg:optimize-coding=off t21.jpg');
disp(sprintf('jpg min : %fsec', cputime-x));

x = cputime;
system('convert  t2.jpg  -quality 100,100 -sampling-factor 1x1 -define jpeg:dct-method=float -define jpeg:optimize-coding=off t22.jpg');
>>>>>>> eda4c1669dd4247f3d4545871463de02e6b592fd
disp(sprintf('jpg max : %fsec', cputime-x));
x = cputime;