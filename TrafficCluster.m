clear all;
close all;
clc;

load ('TRAF.MAT');

[C, R] = size(TRAF);
X = 0;
k = 1;
for i = 1 : C
    for j = 1 : R
        if TRAF(i, j) > 0
            X(k, 1) = i;
            X(k, 2) = j;
            k = k + 1;
        end
    end
end

figure;spy(TRAF,3,'o');
title('Sparsity Plot');

% figure;scatter(X(:,1),X(:,2),10,'o');
% axis([0 C 0 R]);
% camroll(-90);title('Scatter Plot - GMM');
% hold on
% options = statset('Display','final', 'MaxIter',500);
% obj = gmdistribution.fit(X,100,'CovType','diagonal','SharedCov',true,'Options',options);
% h = ezcontour(@(x,y)pdf(obj,[x y]),[0 C],[0 R]);
% plot(obj.mu(:,1),obj.mu(:,2),'kx','LineWidth',2,'MarkerSize',10);
% hold off;


figure;scatter(X(:,1),X(:,2),10,'o');
axis([0 C 0 R]);
camroll(-90);title('Scatter Plot - K-Means');
hold on
options = statset('Display','final', 'MaxIter',500); 
[obj,c]  = kmeans(X,100, 'Distance','cityblock','emptyaction','drop');
plot(c(:,1),c(:,2),'kx','LineWidth',2,'MarkerSize',10);
hold off;


figure;scatter(X(:,1),X(:,2),10,'o');
axis([0 C 0 R]);
camroll(-90);title('Scatter Plot - K-Means');
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
                    TRAF(c,r) = 255;
                end
            end
        end
    end
end
hold off