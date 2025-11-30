function [bias, dark, flat] = intensity_calibration(bias_dir, dark_dir, flat_dir)
    % Load image stacks
    [bias_imgs, ~] = load_images(bias_dir);
    [dark_imgs, ~] = load_images(dark_dir);
    [flat_imgs, ~] = load_images(flat_dir);

    % Convert to double
    bias_imgs = double(bias_imgs);
    dark_imgs = double(dark_imgs);
    flat_imgs = double(flat_imgs);

    % ----- MASTER BIAS -----
    bias = mean(bias_imgs, 4);

    % ----- MASTER DARK -----
    dark = mean(dark_imgs - bias, 4);

    % ----- MASTER FLAT -----
    % remove bias + dark from flats
    flat = mean(flat_imgs - dark - bias, 4);
end