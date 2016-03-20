clear all
clc
mex convert.c
convert('res/test.jpg', 'res/test1.jxr',1.0, 3, 1)
convert('res/test.jpg', 'res/test0.jxr',0.0, 3, 1)