function R = pagerank(B, d)
    N = size(B, 1);

    % When a page does not have any outgoing link it is assumed i links to
    % every other page except itself
    for j = 1:N
        if sum(B(:, j)) == 0
            B(:, j) = 1;
            B(j, j) = 0;
        end
    end

    L = sum(B, 1);
    Lambda = diag(1 ./ L);
    E = ones(N);
    M = d * B * Lambda + ((1 - d) / N) * E;

    R = ones(N, 1) / N;
    tol = 1e-8;
    i_max = 1000;
    R_past = zeros(N, i_max);

    for i = 1:i_max
        R_prev = R;

        R = M * R;
        R = R / norm(R, 1);
        
        R_past(:, i) = R;

        if norm(R - R_prev) < tol
            break;
        end
    end

    R_past = R_past(:, 1:i); % Remove empty iterations

    power_err = zeros(1, i);
    for k = 1:i
        power_err(k) = norm(R - R_past(:, k), 1);
    end

    log_err = log(power_err(1:i-1)); % Skip last, err is 0

    lambda_val = (R' * M * R) / (R' * R);
    fprintf("Zbieżność po %i iteracjach\n", i);
    fprintf("Wartość lambda: %f \n", lambda_val);

    figure;
    bar(R, "FaceColor", [0.2 0.6 0.8]);
    title("Wartość PageRank dla poszczególnych stron");
    xlabel("Indeks strony");
    ylabel("Wartość PageRank");
    grid on;
    xticks(1:length(R));

    for it = 1:length(R)
        text(it, R(it), num2str(R(it), '%0.4f'), ...
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'bottom', ...
            'FontSize', 10, 'FontWeight', 'bold');
    end

    ylim([0, max(R) * 1.1]);

    print("wykres_PageRank.jpeg", "-djpeg", "-r300");

    figure;
    plot(1:(i-1), log_err, "b.-", LineWidth=1.5, MarkerSize=12);
    title("Szybkość zbieżności metody potęgowej");
    xlabel("Numer iteracji");
    ylabel("log(||R - R_{final}||)");
    grid on;
    print("wykres_szybkosci_zbieznosci.jpeg", "-djpeg", "-r300");

    % Linear approx experimental
    poly = polyfit((1:i-1), log_err, 1);
    poly_slope = poly(1);

    % Theoretical values from lambdas
    lambdas = abs(eig(M));
    slope_t = log(lambdas(2) / lambdas(1));

    fprintf("Eksperymentalny współczynnik: %f\n", poly_slope);
    fprintf("Teoretyczny współczynnik: %f\n", slope_t);

end

