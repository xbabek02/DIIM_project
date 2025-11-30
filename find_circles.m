function [centers, diameters] = find_circles(bwMask, minDiam, maxDiam)
    % Ensure logical input
    bwMask = logical(bwMask);

    % Connected components
    stats = regionprops(bwMask, 'Centroid', 'EquivDiameter');

    % Extract all diameters
    allDiam = [stats.EquivDiameter]';

    % Filter by diameter limits
    validIdx = allDiam >= minDiam & allDiam <= maxDiam;

    % Keep only valid stats
    stats = stats(validIdx);
    diameters = allDiam(validIdx);

    % Extract centers
    numCoins = numel(stats);
    centers = zeros(numCoins, 2);

    for i = 1:numCoins
        centers(i, :) = stats(i).Centroid;
    end
end
