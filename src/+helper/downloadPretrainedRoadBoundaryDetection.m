function model = downloadPretrainedRoadBoundaryDetection()
% The downloadRoadBoundaryDetector function loads a pretrained
% road boundary detection network.
%
% Copyright 2022 The MathWorks, Inc.

dataPath = 'model';
modelName = 'roadBoundaryDetection';
netFileFullPath = fullfile(dataPath, modelName);

% Add the extensions to filename.
netMatFileFull = [netFileFullPath,'.mat'];
netZipFileFull = [netFileFullPath,'.zip'];

if ~exist(netZipFileFull,'file')
    fprintf(['Downloading pretrained ', modelName ,' network.\n']);
    fprintf('This can take several minutes to download...\n');
    url = 'https://ssd.mathworks.com/supportfiles/vision/deeplearning/models/resa/roadBoundaryDetection.zip';
    websave (netFileFullPath,url);
    unzip(netZipFileFull, dataPath);
    path = fullfile(netMatFileFull);
    model = load(path);
else
    if ~exist(netMatFileFull,'file')
        fprintf('Pretrained roadBoundaryDetection network already exists.\n\n');
        unzip(netZipFileFull, dataPath);
    end
    path = fullfile(netMatFileFull);
    model = load(path);
end
end
