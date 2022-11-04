function plotBoundaries(f, image, detections)
% The function plotBoundaries plots the boundary coordinates as lines on the
% image. The maximum number of boundaries that can be marked is 2.

% Copyright 2022 The MathWorks, Inc.

figure(f);
clf;

% Show the image.
imshow(image);

% Initialize boundary colours.
colors = ["red", "green"];
% Add boundary coordinates to the image.
hold on;
for i=1:size(detections,2)
    if ~isempty(detections{1,i})
        plot(detections{1,i}(:,1),detections{1,i}(:,2),'LineWidth',2,'Color',colors(i));
    end
end
hold off;
end
