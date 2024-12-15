function A = Matrice_P(M, N)

    % Initialiser la matrice A de taille (M*N) x (M*N)
    totalSize = M * N;
    A = zeros(totalSize, totalSize);
    be = @(i, j, N) j + (i-1)*N; % Bijection formula
    inverse_be = @(K, N) [floor((K-1)/N) + 1, mod(K-1, N) + 1];
    for k = 1:M*N
        x = inverse_be(k,N);
        i = x(1);
        j = x(2);

        if i == 2 && j~=N
            A(k, be(i-1, j, N)) =1;
            A(k, be(i+1, j, N)) = 1;
            A(k,k) =-2;
        end
        if i == 1 || i == M
            A(k,k)=1;
        end
        if j== N
            if i ~= 1 && i ~= M 
                A(k, be(i, j-2, N)) =1;
                A(k, be(i, j-1, N)) = -2;
                A(k,k) = 1;
            end
        end
     end
end