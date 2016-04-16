clear all
clc

addpath db;
addpath extraction;

DB = DataBase('res',5);
DB.add(Image.read('buildings1.bmp'));

