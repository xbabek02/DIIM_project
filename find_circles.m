function [centers, diameters] = find_circles(bwMask)
    % Ensure logical mask
    bwMask = logical(bwMask);

    % Get connected components (each coin = one blob)
    stats = regionprops(bwMask, 'Centroid', 'Area', 'EquivDiameter');

    % Preallocate
    numCoins = numel(stats);
    centers = zeros(numCoins, 2);
    radii   = zeros(numCoins, 1);

    % Extract center and radius
    for i = 1:numCoins
        centers(i, :) = stats(i).Centroid;
        radii(i) = stats(i).EquivDiameter / 2;
    end
    diameters = radii * 2;
end
