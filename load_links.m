function B = load_links(filename)
    fid = fopen(filename, "r");
    if fid == -1
        error("Could not open file %s!", filename)
    end

    EDGES = fscanf(fid, "%i -> %i", [2 inf]);
    fclose(fid);
    
    % Find the B matrix size as a highest link index
    N = max(EDGES(:));
    
    B = zeros(N);

    for i = 1:size(EDGES, 2)
        from = EDGES(1, i);
        to = EDGES(2, i);
        B(to, from) = 1;
    end
end