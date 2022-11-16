function model = downloadPretrainedRoadBoundaryDetection()
% The downloadRoadBoundaryDetector function loads a pretrained
% road boundary detection network.
%
% Copyright 2022 The MathWorks, Inc.

dataPath = './model';

if ~exist(dataPath, 'dir')
    mkdir(dataPath)
end
addpath(genpath(dataPath));

netMatFileFullPath = fullfile(dataPath, 'roadBoundaryDetection.mat');
netZipFileFullPath = fullfile(dataPath, 'resaRoadBoundary.zip');

if ~exist(netMatFileFullPath,'file')
    if ~exist(netZipFileFullPath,'file')
        fprintf('Downloading pretrained RESA network.\n');
        fprintf('This can take several minutes to download...\n');
        url = 'https://ssd.mathworks.com/supportfiles/vision/deeplearning/models/resa/roadBoundaryDetection.zip';
        websave(netZipFileFullPath, url);
        fprintf('Done.\n\n');
        unzip(netZipFileFullPath, dataPath);
    else
        fprintf('Network (zip file) already exists.\n\n');
        unzip(netZipFileFullPath, dataPath);
    end
else
    fprintf('Network (mat file) already exists.\n\n');
end
model = load(netMatFileFullPath);
end

