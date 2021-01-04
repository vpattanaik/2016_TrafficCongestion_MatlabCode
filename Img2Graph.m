function graph = Img2Graph(img, conn)

[M, N] = size(img);
MxN = M*N;

CostVec = reshape(img, MxN, 1);

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

end
