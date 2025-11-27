function [e2, e1, c50, c20, c10, c5] = estim_coins(measurement, bias, dark, flat)
    [x_sc,y_sc] = geometry_calibration(measurement);
    corrected = measurement - bias - dark;
    
    % DEMO/DEBUG PICTURES
    % figure;
    % imshow(flat);
    % figure;
    % imshow(corrected);

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
    
    mask = extract_coins(flat, corrected);
    % Measure coins
    [centers, diameters] = find_circles(mask);  %,c10_p-100, e2_p+100);
    
    if isempty(centers)
        fprintf("No coins found");
    end

    figure;
    imshow(measurement);
    hold on;

    radii = diameters /2;
    
    % Draw each circle
    viscircles(centers, radii, 'Color', 'r', 'LineWidth', 1.5);
    
    hold off;
    
    % output placeholders
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
    
    % Export counts
    e2  = counts(1);
    e1  = counts(2);
    c50 = counts(3);
    c20 = counts(4);
    c10 = counts(5);
    c5  = counts(6);
end

% function [e2, e1, c50, c20, c10, c5] = estim_coins(measurement, bias, dark, flat)
% 
%     %[x_sc,y_sc] = geometry_calibration(measurement);
% 
%     % Compute absolute difference
%     % ------ LIGHTING NORMALIZATION ------
%     % Compute global brightness ratio
%     scale = mean(flat(:)) / mean(measurement(:));
% 
%     % Apply scale factor
%     M_adj = measurement * scale;
% 
%     % Now subtract normalized images
%     diffImg = abs(M_adj - flat);
% 
%     % Convert to grayscale difference
%     diffGray = rgb2gray(diffImg);
% 
%     % Threshold
%     bw = imbinarize(diffGray, 'adaptive');
% 
%     % Morphology
%     bw = bwareaopen(bw, 50);
%     bw = imclose(bw, strel('disk', 5));
% 
%     figure;
%     imshow(bw);
%     title('Detected Coins');
% 
%     % outputs
%     e2 = 0; e1 = 0; c50 = 0; c20 = 0; c10 = 0; c5 = 0;
% end