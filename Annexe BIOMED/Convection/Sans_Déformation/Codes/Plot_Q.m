function Plot_Q(M, N, L, D, a, P0, P1)
    [Ux, Uy, P] = vecteur_G(M, N, L, D, a, P0, P1);
    C = sqrt(Ux.^2 + Uy.^2);
    C = reshape(C, N, M);
    
    for i = 1:M
        QQ(i, 1) = (mean(C(:, i))) * D;
        Q(i, 1) = (P0 - P1) / ((12 * a * L) / D^3);
        X(i, 1) = (i - 1) * (L / (M - 1));
    end
    mean_QQ = mean(QQ);
    mean_Q = mean(Q);
    Inc = (mean_Q-mean_QQ)/mean_QQ;
    fprintf('Débit Numérique = %.4f, Débit Théorique = %.4f,Incertitude = %.4f\n', mean_QQ, mean_Q, Inc);
    plot(X, QQ, 'DisplayName', 'Numérique');
    hold on;
    plot(X, Q, 'DisplayName', 'Théorique');
    hold off;
    
    xlabel('Position X');
    ylabel('Débit Q');
    legend('show');
    title('Comparaison des courbes analytique et théorique du débit');
end
