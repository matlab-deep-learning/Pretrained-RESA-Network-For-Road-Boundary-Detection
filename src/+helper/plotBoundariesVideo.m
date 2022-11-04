function plotBoundariesVideo(video, detections, startTime)
% The function plotBoundariesVideo plots the boundary coordinates on the video
% frames and saves the ouput video. The maximum number of boundaries that can be
% marked is 2.

% Copyright 2022 The MathWorks, Inc.

% Reset the current time to start time.
video.CurrentTime = startTime;

frameIdx = 1;
[~,videoName,~] = fileparts(video.Name);
filename = strcat(videoName,"_detected");
savepath = fullfile(pwd, filename);

% Initialize boundary colours.
colors = ["red", "green"];

% Create output video object.
outVideo = VideoWriter(savepath);
outVideo.FrameRate = video.FrameRate;
open(outVideo);

while video.hasFrame
    frame = readFrame(video);
    for i=1:size(detections,2)
        if ~isempty(detections{frameIdx,i})
            frame = insertMarker(frame, detections{frameIdx,i}(:,1:2),'o','Color',colors(i),'Size',3);
        end
    end
    writeVideo(outVideo,frame);
    frameIdx = frameIdx+1;
end
close(outVideo);
end
