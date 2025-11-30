function bwCoins = extract_coins(bg, img)
    
    % % DEMO/DEBUG PICTURES
    % figure;
    % imshow(img);
    % figure;
    % imshow(bg);
    % 
    % img = imadjust(img, stretchlim(img, 0.02), []);   % increase contrast
    % figure;
    % imshow(img);

    % Compute absolute per-pixel difference
    diffImg = abs(img - bg);

    % Convert to grayscale difference (max per channel)
    diffGray = max(diffImg, [], 3);

    % Threshold
    bwCoins = diffGray > 0.15;

    % Morphological cleaning
    bwCoins = imclose(bwCoins, strel('disk', 5));   % close gaps
    bwCoins = imfill(bwCoins, 'holes');

    % Remove tiny noise
    bwCoins = bwareaopen(bwCoins, 50);
    
    % Smooth edges using morphological opening/closing
    bwCoins = imopen(bwCoins, strel('disk', 3));
    bwCoins = imclose(bwCoins, strel('disk', 3));

    % % DEBUG - Show result
    % figure;
    % imshow(bwCoins);
    % title("Detected Coins");
end
