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
    flat = mean(flat_imgs, 4);
end



% function [bias, dark, flat] = intensity_calibration(bias_dir, dark_dir, flat_dir)
% 
%     % Load image stacks
%     [bias_imgs, ~] = load_images(bias_dir);
%     [dark_imgs, ~] = load_images(dark_dir);
%     [flat_imgs, ~] = load_images(flat_dir);
% 
%     % Convert to double
%     bias_imgs = double(bias_imgs);
%     dark_imgs = double(dark_imgs);
%     flat_imgs = double(flat_imgs);
% 
%     % ----- MASTER BIAS -----
%     bias = mean(bias_imgs, 4);
% 
%     % ----- MASTER DARK -----
%     dark = mean(dark_imgs - bias, 4);
% 
%     % ----- MASTER FLAT -----
%     flat_raw = mean(flat_imgs, 4);
%     flat = zeros(size(flat_raw));
% 
%     for c = 1:3
%         channel_mean = mean(flat_raw(:,:,c), "all");
%         flat(:,:,c) = flat_raw(:,:,c) ./ channel_mean;
%     end
% end
