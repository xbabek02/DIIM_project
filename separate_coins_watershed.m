function bwSeparated = separate_coins_watershed(bwMask)

    % Distance transform (inside white blobs)
    D = -bwdist(~bwMask);

    % Smooth the distance map
    D = imhmin(D, 3);  % suppress shallow minima

    % Watershed
    L = watershed(D);

    % Remove watershed lines
    bwSeparated = bwMask;
    bwSeparated(L == 0) = 0;

end
