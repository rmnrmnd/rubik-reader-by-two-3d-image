close all
clear all
clc


for i = 1:6
    readCube(['Test\' num2str(i) '1.jpg'],['Test\' num2str(i) '2.jpg']);
end
