% This script generates all of my panoramas
% Input images are read from 
% ../data/inp/examples and resulting panorams are then saved to 
% ../data/out/examples

warning('OFF','images:initSize:adjustingMag');
tic;
numFrames = 3;
inpPathFormat = '../data/inp/mine/aquariumAtNight%d.jpg';
 outPath = '../data/out/mine/rainLateAtNight.jpg';
renderAtFrame = ceil(numFrames/2);
generatePanorama(inpPathFormat,outPath,numFrames,renderAtFrame,true);
toc;
pause(2);
close all;

tic;
numFrames = 3;
inpPathFormat = '../data/inp/mine/robotLab%d.jpg';
outPath = '../data/out/mine/robotLab.jpg';
renderAtFrame = ceil(numFrames/2);
generatePanorama(inpPathFormat,outPath,numFrames,renderAtFrame,true);
toc;
pause(2);
close all;

warning('ON','images:initSize:adjustingMag');
