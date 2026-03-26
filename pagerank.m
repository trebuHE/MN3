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

    for i = 1:i_max
        R_prev = R;

        R = M * R;
        R = R / norm(R, 1);
        
        if norm(R - R_prev) < tol
            break;
        end
    end

    lambda_val = (R' * M * R) / (R' * R);
    fprintf("Convergence after %i iterations\n", i);
    fprintf("Lambda value: %f \n", lambda_val);

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
end

