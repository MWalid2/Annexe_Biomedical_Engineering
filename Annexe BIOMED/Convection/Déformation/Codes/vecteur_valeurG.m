function Y = vecteur_valeurG(M, N, P0, P1)
    Y = zeros(3*M*N, 1);  % Initialize the output vector
    be = @(i, j, N) j + (i-1)*N; % Bijection formula
    inverse_be = @(K, N) [floor((K-1)/N) + 1, mod(K-1, N) + 1];
    for k = 1:M*N
        x = inverse_be(k,N);
        i = x(1);
        j = x(2);
        if i == 1 
            Y(j+2*M*N,1) = P0;
        end
        if i == M 
            Y(j+(M-1)*N+2*M*N,1) = P1;
        end

    end        
end
