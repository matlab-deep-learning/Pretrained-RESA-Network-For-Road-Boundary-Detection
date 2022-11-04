function params = createDetectionParameters()
% createDetectionParameters creates parameters required for detection.

% Copyright 2022 The MathWorks, Inc.

% Specify these parameters for detection -
% * Set the threshold as 0.5. Detections with confidence score less than
% threshold are ignored.
% * Set the networkInputSize as [288,800]. 
% * Set the cut height. Only the rows of the image after the specified
% cutH will be considered for detection. 
params.threshold = 0.5;
params.networkInputSize = [288,800];
params.cutH = 300;

end
