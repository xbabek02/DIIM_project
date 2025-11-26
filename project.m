clc; clear; close all;

bias_dir = 'Images/Bias';
dark_dir = 'Images/Dark';
flat_dir = 'Images/Flat';
meas_dir = 'Images/Measurements';
gt_file  = 'Images/gt.csv';

[bias, dark, flat] = intensity_calibration(bias_dir, dark_dir, flat_dir);

gt_T = readtable('gt.csv');
[imgs, filenames] = load_images(meas_dir);

numImgs = numel(filenames);

for k = 1:numImgs
    thisFile = filenames{k};
    idx = strcmp(gt_T.file, thisFile);

    if ~any(idx)
        warning('No GT entry found for image %s', thisFile);
        continue;
    end

    measurement = imgs(:,:,:,k);
    [e2, e1, c50, c20, c10, c5] = estim_coins(measurement, bias, dark, flat);
    
    gt = table2array(gt_T(idx, 2:end));
    pred = [e2, e1, c50, c20, c10, c5];

    fprintf('Image: %s\n', thisFile);
    fprintf('GT:   %s\n', mat2str(gt));
    fprintf('Pred: %s\n\n', mat2str(pred));
end