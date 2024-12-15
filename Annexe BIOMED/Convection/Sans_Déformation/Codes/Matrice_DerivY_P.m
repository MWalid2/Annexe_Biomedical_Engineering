function A = Matrice_DerivY_P(M, N, D)

    % Paramètres de discrétisation
    delta_y = D / (N - 1);

    % Coefficients a, b, c
    be = @(i, j, N) j + (i-1)*N; % Bijection formula
    inverse_be = @(K, N) [floor((K-1)/N) + 1, mod(K-1, N) + 1];
    b = 1/(delta_y);
    % Initialiser la matrice A de taille (M*N) x (M*N)
    totalSize = M * N;
    A = zeros(totalSize, totalSize);

    for k = 1:M*N
        x = inverse_be(k,N);
        i = x(1);
        j = x(2);
        if i ~= 1 && i ~= M && j ~= 1 && j ~= N
            A(k, be(i, j, N)) = b;
            A(k, be(i, j-1, N)) = -b;
        end
    end
end

