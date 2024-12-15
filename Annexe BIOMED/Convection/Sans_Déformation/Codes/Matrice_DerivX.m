function A = Matrice_DerivX(M, N, L)

    % Paramètres de discrétisation
    delta_x = L / (M - 1);
    be = @(i, j, N) j + (i-1)*N; % Bijection formula
    inverse_be = @(K, N) [floor((K-1)/N) + 1, mod(K-1, N) + 1];
    % Coefficients a, b, c
    
    b = 1/(delta_x);
    % Initialiser la matrice A de taille (M*N) x (M*N)
    totalSize = M * N;
    A = zeros(totalSize, totalSize);

    for k = 1:M*N
        x = inverse_be(k,N);
        i = x(1);
        j = x(2);
        if i ~= 1 && i ~= M && j ~= 1 && j ~= N
                A(k, be(i+1, j, N)) =b/2;
                A(k, be(i-1, j, N)) = -b/2;
        end
    end
end