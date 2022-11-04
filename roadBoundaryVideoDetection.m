%% Prerequisites
% To run this example you need the following prerequisites - 
% * MATLAB (R2022b or later).
% * Deep Learning Toolbox.
% * Computer Vision Toolbox.

%% Add path to the source directory
addpath('src','model','images');

%% Load Pre-trained Network
load('model/resa-road-boundary.mat');

%% Specify Detection Parameters
% Use the function helper.createDetectionParameters to specify the
% parameters required for road boundary detection.
params = helper.createDetectionParameters;

% Specify the mini batch size as 8. Increase this value to speed up
% detection time.
miniBatchSize  = 10;

% Specify the executionEnvironment as either "cpu", "gpu", or "auto".
executionEnvironment = "gpu";

%% Detect in Video
% Read the video.
v = VideoReader('../../resa/resa/videos/20200731_135007_DRVR04_CSMV6598_02_FRONT.mp4');

% Store the video start time.
videoStartTime = v.CurrentTime;

% Detect using the detectRoadBoundaryVideo function provided as helper
% function below.
profile clear;
profile on;
roadBoundaries = detectRoadBoundaryVideo(net, v, params, miniBatchSize, executionEnvironment);
profile off;

% Plot detections in video and save result.
helper.plotBoundariesVideo(v, roadBoundaries, videoStartTime);


%% Helper function to Detect in Video
function roadBoundaries = detectRoadBoundaryVideo(net, v, params, miniBatchSize, executionEnvironment)
% Detect road boundaries in a video by reading frames in batches.
roadBoundaries = {};
numBatches = ceil(v.NumFrames/miniBatchSize);
for batch = 1:numBatches
    firstFrameIdx = miniBatchSize*batch-(miniBatchSize-1);
    if batch ~= numBatches
        lastFrameIdx = miniBatchSize*batch;
    else
        lastFrameIdx = v.NumFrames;
    end
    % Read batch of frames.
    frames = read(v, [firstFrameIdx, lastFrameIdx]);
    
    % Detect boundaries using the function detectRoadBoundaries.
    detections = detectRoadBoundaries(net, frames, params, executionEnvironment);
    
    % Append the detections.
    roadBoundaries = [roadBoundaries; detections];
    
    % Print detection progress.
    fprintf("Detected %d frames out of %d frames.\n",lastFrameIdx,v.NumFrames);
end
end

% Copyright 2022 The MathWorks, Inc.
