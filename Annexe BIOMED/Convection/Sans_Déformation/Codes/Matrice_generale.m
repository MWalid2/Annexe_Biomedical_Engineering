function G = Matrice_generale(M,N,L,D)

    G = zeros(3*M*N,3*M*N);
    A = Matrice_LaplacienX(M,N,L,D);
    A_1= Matrice_LaplacienY(M,N,L,D);
    B = Matrice_DerivX_P(M,N,L);
    B_1 = Matrice_DerivY_P(M,N,D);
    C = Matrice_DerivX(M,N,L);
    C_1 = Matrice_DerivY(M,N,D);
    P = Matrice_P(M,N);
    
    G(1:M*N,1:M*N) = A;
    G(1:M*N,2*M*N +1:3*M*N) =-B;
    G(M*N +1:2*M*N,M*N +1:2*M*N) = A_1;
    G(M*N +1:2*M*N,2*M*N +1:3*M*N) =-B_1;
    G(2*M*N +1:3*M*N,1:M*N) = C;
    G(2*M*N +1:3*M*N,M*N+1:2*M*N) = C_1;
    G(2*M*N +1:3*M*N,2*M*N +1:3*M*N) = P;
end
