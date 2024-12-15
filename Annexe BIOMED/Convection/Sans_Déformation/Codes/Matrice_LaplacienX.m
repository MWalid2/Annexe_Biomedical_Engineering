function A = Matrice_LaplacienX(M, N, L, D)

    % Paramètres de discrétisation
    delta_x = L / (M - 1);
    delta_y = D / (N - 1);
    be = @(i, j, N) j + (i-1)*N; % Bijection formula
    inverse_be = @(K, N) [floor((K-1)/N) + 1, mod(K-1, N) + 1];
    % Coefficients a, b, c
    b = 1/delta_x;
    c = 1/delta_y;
    B = b^2;
    C = c^2;
    a = -2 * (B+ C);
    % Initialiser la matrice A de taille (M*N) x (M*N)
    totalSize = M * N;
    A = zeros(totalSize, totalSize);

    for k = 1:M*N
        x = inverse_be(k,N);
        i = x(1);
        j = x(2);
        if i ~= 1 && i ~= M && j ~= 1 && j ~= N
            A(k, be(i+1, j, N)) = B;
            A(k, be(i-1, j, N)) = B;
            A(k, be(i, j+1, N)) = C;
            A(k, be(i, j-1, N)) = C;
            A(k, k) = a;
        end
        if j == 1 || j == N
            A(k,k) = 1;
        end
        if i == 1
            if j ~= 1 && j ~= N
                A(k,k)=1;
                A(k,k+M)=-1;
            end
        end
        if i==M
            if j ~= 1 && j ~= N
                A(k,be(M,j,N)) = 1;
                A(k,be(M-1,j,N)) = -1;
                A(k,be(2,j,N)) =-1;
                A(k,be(1,j,N)) = 1;
            end
        end
    end
end