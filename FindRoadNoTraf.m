% Clear Workspace
close all;
clear all;
clc;

% % clear image
% set(handles.axes1, 'XtickLabel',[], 'YtickLabel',[]);
% set(handles.axes2, 'XtickLabel',[], 'YtickLabel',[]);

%Load Labelled Road Map
LFile = uigetfile('*.png');
limg = imread(LFile);
wlimg = imread(['W' LFile]);

%Plot Labelled & Unlabelled Road Map
figure, imshow(limg);
title('Labelled Road Map');
figure, imshow(wlimg);
title('Unlabelled Road Map');

%Convert Unlabelled Road Map into Grayscale
% wlimg = rgb2gray(wlimg);
% BW = edge(wlimg,'canny');
BW = (wlimg >= 251);
BW = bwareaopen(BW, 500);

figure, imshow(BW);
title('Black & White Road Map');

%Initialize Empty Traffic Map
[M, N] = size(BW);
traf(1: M, 1: N) = 0;

%Initialize and Plot Source & Destination
Org = [1192, 62];
Tag = [116, 1037];

figure, imshow(limg);
title('Labelled Road Map with Source (red) and Destination (green)');
hold on;
plot(Org(1, 1), Org(1, 2), 'Marker', 'v', 'MarkerFaceColor', 'red', 'MarkerEdgeColor', 'red');
plot(Tag(1, 1), Tag(1, 2), 'Marker', 'v', 'MarkerFaceColor', 'green', 'MarkerEdgeColor', 'green');
hold off;

figure, imshow(BW);
title('Black & White Road Map with Source (red) and Destination (green)');
hold on;
plot(Org(1, 1), Org(1, 2), 'Marker', 'v', 'MarkerFaceColor', 'red', 'MarkerEdgeColor', 'red');
plot(Tag(1, 1), Tag(1, 2), 'Marker', 'v', 'MarkerFaceColor', 'green', 'MarkerEdgeColor', 'green');
hold off;

%Converting Map to Graph
Map = uint8(BW);
Map = Map * 255;
walls = Map < 128;

O = sub2ind([M N], Org(1,2), Org(1,1));
T = sub2ind([M N], Tag(1,2),  Tag(1,1));

CMatrix = double(walls)*M*N+1;
CMatrix = CMatrix + traf;

MxN = M*N;
conn = 8;
CostVec = reshape(CMatrix, MxN, 1);
if ( conn == 4 )
    graph = spdiags(repmat(CostVec,1,4), [-M -1 1 M], MxN, MxN);
elseif( conn == 8 )
    graph = spdiags(repmat(CostVec,1,8), [-M-1, -M, -M+1, -1, 1, M-1, M, M+1], MxN, MxN);
    graph(sub2ind([MxN, MxN], (2:N-1)*M+1, (2:N-1)*M - M)) = inf;
    graph(sub2ind([MxN, MxN], (1:N)*M, (1:N)*M - M + 1)) = inf;    
    graph(sub2ind([MxN, MxN], (0:N-1)*M+1, (0:N-1)*M + M)) = inf;
    graph(sub2ind([MxN, MxN], (1:N-2)*M, (1:N-2)*M + M + 1)) = inf;
end
graph(sub2ind([MxN, MxN], (1:N-1)*M+1, (1:N-1)*M)) = inf;
graph(sub2ind([MxN, MxN], (1:N-1)*M,   (1:N-1)*M + 1)) = inf;

%Finding Optimal Route
[dist, path, pred] = graphshortestpath(graph, O, T);%Default uses Dijkstra

[y, x] = ind2sub([M N], path);
Route(:,1) = x;
Route(:,2) = y;

%Displaying Optimal Route
figure, imshow(limg);
title('Labelled Road Map with Source (red), Destination (green) and Route (cyan)');
hold on;
plot(Route(:, 1), Route(:, 2), 'c.');
plot(Org(1, 1), Org(1, 2), 'Marker', 'v', 'MarkerFaceColor', 'red', 'MarkerEdgeColor', 'red');
plot(Tag(1, 1), Tag(1, 2), 'Marker', 'v', 'MarkerFaceColor', 'green', 'MarkerEdgeColor', 'green');
hold off;

figure, imshow(BW);
title('Black & White Road Map with Source (red), Destination (green) and Route (cyan)');
hold on;
plot(Route(:, 1), Route(:, 2), 'c.');
plot(Org(1, 1), Org(1, 2), 'Marker', 'v', 'MarkerFaceColor', 'red', 'MarkerEdgeColor', 'red');
plot(Tag(1, 1), Tag(1, 2), 'Marker', 'v', 'MarkerFaceColor', 'green', 'MarkerEdgeColor', 'green');
hold off;