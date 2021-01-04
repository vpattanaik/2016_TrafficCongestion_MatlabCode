%% Clear Workspace
close all;
clear all;
clc;

%% Load Labelled Road Map
LFile = uigetfile('*.png');
limg = imread(LFile);
wlimg = imread(['W' LFile]);

%% Plot Labelled & Unlabelled Road Map
figure, imshow(limg);
title('Labelled Road Map');
figure, imshow(wlimg);
title('Unlabelled Road Map');

%% Convert Unlabelled Road Map into Grayscale
BW = (wlimg >= 251);
BW = bwareaopen(BW, 500);

figure, imshow(BW);
title('Black & White Road Map');

%% Initialize Empty Traffic Map
[M, N] = size(BW);
traf(1: M, 1: N) = 0;

%% Initialize and Plot Source & Destination
% Org = [1192, 62];
% Org = [942 375];
Org = [467 732];
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

%% Adding Random Traffic
count = 0;
tx = 0;
ty = 0;
while count < 2500
    rx = randi([1 M],1,1);
    ry = randi([1 N],1,1);
    
    if BW(rx, ry) == 1
        traf(rx, ry) = traf(rx, ry) + 255;
        tx(count + 1) = rx;
        ty(count + 1) = ry;
        count = count + 1;
    end
end

%% Plot Traffic on Road Map
figure, imshow(limg);
title('Labelled Road Map with Source (red) and Destination (green)');
hold on;
plot(ty, tx, 'bo', 'MarkerSize', 3);
plot(Org(1, 1), Org(1, 2), 'Marker', 'v', 'MarkerFaceColor', 'red', 'MarkerEdgeColor', 'red');
plot(Tag(1, 1), Tag(1, 2), 'Marker', 'v', 'MarkerFaceColor', 'green', 'MarkerEdgeColor', 'green');
hold off;

figure, imshow(BW);
title('Black & White Road Map with Source (red) and Destination (green)');
hold on;
plot(ty, tx, 'bo', 'MarkerSize', 3);
plot(Org(1, 1), Org(1, 2), 'Marker', 'v', 'MarkerFaceColor', 'red', 'MarkerEdgeColor', 'red');
plot(Tag(1, 1), Tag(1, 2), 'Marker', 'v', 'MarkerFaceColor', 'green', 'MarkerEdgeColor', 'green');
hold off;

%% Clustering Traffic
[C, R] = size(traf);
X = 0;
k = 1;
for i = 1 : C
    for j = 1 : R
        if traf(i, j) > 0
            X(k, 1) = i;
            X(k, 2) = j;
            k = k + 1;
        end
    end
end

options = statset('Display','final', 'MaxIter',500); 
[obj,c]  = kmeans(X,100, 'Distance','cityblock','emptyaction','drop');

figure;
scatter(X(:,1),X(:,2),10,'o');
axis([0 C 0 R]);
set(gca,'xtick',[]);
set(gca,'ytick',[]);
camroll(-90);title('Traffic Scatter Plot - K-Means & Convex Hull');
hold on

tempobj = obj;
tempX = X;

while isempty(tempobj) == 0
    i = 1;
    j = 1;
    clust = 0;
    temp = tempobj(1,1);
    
    while i <= size(tempobj,1)
        if temp == tempobj(i,1)
            clust(j,1) = tempX(i,1);
            clust(j,2) = tempX(i,2);
            j = j + 1;
            tempobj(i,:) = [];
            tempX(i,:) = [];
        else
            i = i + 1;
        end
    end
    
    x = clust(:,1);
    y = clust(:,2);
    if size(x,1) > 2
        vi = convhull(x,y);
        fill (x(vi), y(vi), 'r','facealpha', 0.5 );
        for c = 1: C
            for r = 1: R
                [in,on]  = inpolygon(c,r,x(vi),y(vi));
                if in == 1 || on == 1
                    traf(c,r) = 255;
                end
            end
        end
    end
    
end
hold off

%% Converting Map to Graph
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

%% Finding Optimal Route
[dist, path, pred] = graphshortestpath(graph, O, T);%Default uses Dijkstra

[y, x] = ind2sub([M N], path);
Route(:,1) = x;
Route(:,2) = y;

%% Displaying Optimal Route
figure, imshow(limg);
title('Labelled Road Map with Source (red), Destination (green) and Route (cyan)');
hold on;
plot(Route(:, 1), Route(:, 2), 'c.');
plot(ty, tx, 'bo', 'MarkerSize', 3);
plot(Org(1, 1), Org(1, 2), 'Marker', 'v', 'MarkerFaceColor', 'red', 'MarkerEdgeColor', 'red');
plot(Tag(1, 1), Tag(1, 2), 'Marker', 'v', 'MarkerFaceColor', 'green', 'MarkerEdgeColor', 'green');
hold off;

figure, imshow(BW);
title('Black & White Road Map with Source (red), Destination (green) and Route (cyan)');
hold on;
plot(Route(:, 1), Route(:, 2), 'c.');
plot(ty, tx, 'bo', 'MarkerSize', 3);
plot(Org(1, 1), Org(1, 2), 'Marker', 'v', 'MarkerFaceColor', 'red', 'MarkerEdgeColor', 'red');
plot(Tag(1, 1), Tag(1, 2), 'Marker', 'v', 'MarkerFaceColor', 'green', 'MarkerEdgeColor', 'green');
hold off;