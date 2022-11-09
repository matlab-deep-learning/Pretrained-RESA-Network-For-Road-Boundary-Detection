%% Prerequisites
% To run this example you need the following prerequisites - 
% * MATLAB &reg; (R2022b or later).
% * Deep Learning Toolbox &trade; . 
% * Computer Vision Toolbox &trade; .

%% Add path to the source directory
addpath('src','model','images');

%% load Pre-trained Network
load('model/resa-road-boundary.mat');

%% Specify Detection Parameters
% Use the function helper.createDetectionParameters to specify the
% parameters required for road boundary detection.
params = helper.createDetectionParameters;

% Specify the executionEnvironment as either "cpu", "gpu", or "auto".
executionEnvironment = "auto";

%% Detect on an Image
% Read the test image.
image = imread("testImage.png");

% Call detectRoadBoundaries to detect the road boundaries.
roadBoundaries = detectRoadBoundaries(net, image, params, executionEnvironment);

% Visualize the detected boundaries.
fig = figure;
helper.plotBoundaries(fig, image, roadBoundaries);

% Copyright 2022 The MathWorks, Inc.
