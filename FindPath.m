function Route = FindPath ( Org, Trg, Map, Traf )

walls = Map < 128;

[M, N] = size(Map);

Org = sub2ind([M N], Org(1,2), Org(1,1));
Trg = sub2ind([M N], Trg(1,2),  Trg(1,1));

CMatrix = double(walls)*M*N+1;

CMatrix = CMatrix + Traf;

D = Img2Graph(CMatrix, 8);

[dist, path, pred] = graphshortestpath(D, Org, Trg);%Default uses Dijkstra

[y, x] = ind2sub([M N], path);

Route(:,1) = x;
Route(:,2) = y;

end