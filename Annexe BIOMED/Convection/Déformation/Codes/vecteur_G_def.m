function [Ux,Uy,P] = vecteur_G_def(M,N,L,D,stepx,stepy,a,P0,P1)
    A = Matrice_generale_def(M,N,L,D,stepx,stepy);
    Y = vecteur_valeurG(M,N,P0,P1);
    X = A\Y;
    Ux = X(1:M*N)/a;
    Uy = X(M*N+1:2*M*N)/a;
    P = X(2*M*N+1:3*M*N);
end