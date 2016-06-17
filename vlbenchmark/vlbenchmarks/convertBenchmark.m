x = cputime;
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
disp(sprintf('jpg max : %fsec', cputime-x));
x = cputime;