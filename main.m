clear all
clc
mex convert.c
addpath 'src' 

I = Image.read('src/buildings1.bmp')