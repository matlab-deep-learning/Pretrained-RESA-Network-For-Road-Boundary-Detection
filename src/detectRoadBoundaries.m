function detections = detectRoadBoundaries(net, data, params, executionEnvironment, NameValueArgs)
% detections = detectRoadBoundaries(net, image, params, executionEnvironment)
% runs prediction on a pre-trained network.
%
% Inputs:
% -------
% net                  - Pretrained dlnetwork.
% data                 - Input data must be a single RGB image of size
%                        HxWx3 or an array of RGB images of size HxWx3xB,
%                        where H is the height, W is the width and B is the
%                        number of images.
% params               - Parameters required to run inference on the model
%                        created using
%                        helper.createDetectionParameters.                   
% executionEnvironment - Environment to run predictions on. Specify cpu,
%                        gpu, or auto.
% 
% detections = detectRoadBoundaries(..., Name, Value) specifies the optional
% name-value pair argument as described below.
% 
% 'FitPolyLine'        - Specify the value true or false. If true then
%                        second order polynomials are fit to the detections
%                        to make them smooth else raw detections are
%                        returned.
%
%                        Default: true 
%                        
%                        
% Output:
% -------
% detections           - Returns a cell array of M-by-N, where M is the
%                        number of images in a batch and N is the number of
%                        boundaries detected. Each cell contains a P-by-2 
%                        array of pixel coordinates of the detected road
%                        boundaries, where P is the number of points and 2
%                        colums are X and Y values of their respective
%                        pixel coordinates.

% Copyright 2022 The MathWorks, Inc.

% Parse input arguments.
arguments
    net
    data
    params
    executionEnvironment
    NameValueArgs.FitPolyLine = true;
end
fitPolyLine = NameValueArgs.FitPolyLine;

% Get the input image size.
inputImageSize = size(data);

% convert to BGR.
data = flip(data,3);

% Extract Roi
cutH = params.cutH;
data = data(cutH:end,:,:,:);

% Resize the image to the input size of the network.
resizedImage = imresize(data, params.networkInputSize);

% Rescale the pixels in the range [0,1].
resizedImage = single(resizedImage);

% Normalize.
resizedImage(:,:,1,:) = (resizedImage(:,:,1,:)-103.939)/1;
resizedImage(:,:,2,:) = (resizedImage(:,:,2,:)-116.779)/1;
resizedImage(:,:,3,:) = (resizedImage(:,:,3,:)-123.68)/1;

% % Convert the resized image to dlarray and gpuArray if specified.
if canUseGPU && ~(strcmp(executionEnvironment,"cpu"))
    resizedImage = gpuArray(resizedImage);
end

resizedImage = dlarray(resizedImage,'SSCB');

% Predict the output.
[roadBoundaryMask, confidence] = predict(net, resizedImage);
roadBoundaryMask = dlarray(roadBoundaryMask,'SSCB');
confidence = dlarray(confidence,'SSCB');

% Process the predictions to output probability map and confidence scores.
[roadBoundaryMask, confidence] = helper.processPredictions(roadBoundaryMask, confidence, params.threshold);

% Extract road boundary coordinates from the probability map and confidence
% scores.
detections = helper.generateLines(roadBoundaryMask, confidence, inputImageSize, params, fitPolyLine);

end
