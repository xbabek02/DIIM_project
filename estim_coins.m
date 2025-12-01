function [e2, e1, c50, c20, c10, c5] = estim_coins(measurement, bias, dark, flat)
%ESTIM_COINS Estimate the number of Euro coins and cents in an image.
%
%   [E2, E1, C50, C20, C10, C5] = ESTIM_COINS(MEASUREMENT, BIAS, DARK, FLAT)
%   detects and classifies Euro coins in the input MEASUREMENT image.
%
%   INPUTS:
%       MEASUREMENT - The raw camera image containing coins.
%       BIAS        - Bias frame used for sensor correction.
%       DARK        - Dark frame used for sensor correction.
%       FLAT        - Flat-field image used for illumination correction.
%
%   The function performs the following steps:
%       1. Geometry calibration to convert mm to pixel scale.
%       2. Bias/dark subtraction
%       3. Background-based normalization of intensity.
%       4. Coin segmentation using extract_coins().
%       5. Coin separation using watershed.
%       6. Circle detection (find_circles) to estimate diameters.
%       7. Classification of each circle into known coin types:
%           - €2, €1, 50c, 20c, 10c, 5c
%
%   OUTPUTS:
%       E2   - Number of €2 coins detected.
%       E1   - Number of €1 coins detected.
%       C50  - Number of 50 cent coins detected.
%       C20  - Number of 20 cent coins detected.
%       C10  - Number of 10 cent coins detected.
%       C5   - Number of 5 cent coins detected.
%
%   EXAMPLE:
%       [e2,e1,c50,c20,c10,c5] = estim_coins(meas, bias, dark, flat);
%
%   NOTE: function was tested only using the master frames that were
%       computed in the project.m file. See also project.m and
%       intensity_calibration.m to understand the implementation.
%
    [x_sc,y_sc] = geometry_calibration(measurement);
    
    corrected = measurement - bias - dark;

    pad = 80;
    sz = 200;
    
    r1 = pad + 1; r2 = pad + sz;
    c1 = pad + 1; c2 = pad + sz;
    
    bg_meas = corrected(r1:r2, c1:c2, :);
    bg_flat = flat(r1:r2, c1:c2, :);

    avg_meas = mean(bg_meas, [1 2]);
    avg_flat = mean(bg_flat, [1 2]);

    scale = avg_flat ./ avg_meas;
    corrected_norm = corrected .* scale;
    
    % DEMO/DEBUG PICTURES
    % figure;
    % imshow(flat);
    % figure;
    % imshow(corrected_norm);

    e2_d = 25.75; %mm -> max
    e1_d = 23.25;
    c50_d = 24.25;
    c20_d = 22.25;
    c10_d = 19.75; % -> min
    c5_d = 21.25;

    sc = (x_sc + y_sc) / 2;

    e2_p = e2_d * sc; %in pixels
    e1_p = e1_d * sc;
    c50_p = c50_d * sc;
    c20_p = c20_d * sc;
    c10_p = c10_d * sc;
    c5_p = c5_d * sc;
    
    mask = extract_coins(flat, corrected_norm);
    % Measure coins
    mask_separated = separate_coins_watershed(mask);
    [centers, diameters] = find_circles(mask_separated, c10_p-50, e2_p+50);

    if isempty(centers)
        fprintf("No coins found");
    end

    radii = diameters /2;
    

    % % DEBUG FOR REPORT
    % figure;
    % imshow(mask_separated);
    figure;
    imshow(measurement);
    hold on;

    % Draw each circle
    viscircles(centers, radii, 'Color', 'r', 'LineWidth', 1.5);

    hold off;
    
    coinNames = {'e2','e1','c50','c20','c10','c5'};
    coinDiameters = [e2_p, e1_p, c50_p, c20_p, c10_p, c5_p];
    
    % Allocate result counts
    counts = zeros(size(coinNames));
    
    % Classify each detected coin
    for i = 1:length(diameters)
        d = diameters(i);
        
        % Compute absolute error to each reference diameter
        [~, idx] = min(abs(coinDiameters - d));
        
        % Increment the detected coin type
        counts(idx) = counts(idx) + 1;
    end
    
    e2  = counts(1);
    e1  = counts(2);
    c50 = counts(3);
    c20 = counts(4);
    c10 = counts(5);
    c5  = counts(6);
end
