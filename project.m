bias_dir = 'Images/Bias';
dark_dir = 'Images/Dark';
flat_dir = 'Images/Flat';
meas_dir = 'Images/Measurements';
gt_file  = 'Images/gt.csv';

[bias, dark, flat] = intensity_calibration(bias_dir, dark_dir, flat_dir);

gt_T = readtable('gt.csv');
[imgs, filenames] = load_images(meas_dir);

numImgs = numel(filenames);

all_gt   = [];
all_pred = [];

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

    all_gt   = [all_gt; gt];
    all_pred = [all_pred; pred];
    
end

correct = all_gt == all_pred;
per_coin_accuracy = 100 * mean(correct, 1);
disp('Accuracy per coin type (%):');
disp(per_coin_accuracy);

overall_accuracy = 100 * mean(all(correct, 2));
fprintf('Overall exact-match accuracy: %.2f%%\n\n', overall_accuracy);

mae = mean(abs(all_gt - all_pred), 1);
disp('Mean absolute error per coin type:');
disp(mae);

gt_total   = sum(all_gt,   2);   
pred_total = sum(all_pred, 2); 

total_exact_accuracy = 100 * mean(gt_total == pred_total);
fprintf('Total coin exact-match accuracy: %.2f%%\n', total_exact_accuracy);

total_mae = mean(abs(gt_total - pred_total));
fprintf('Total coin MAE: %.2f coins\n', total_mae);

percentage_error_total = 100 * mean(abs(gt_total - pred_total) ./ max(gt_total, 1));
percentage_accuracy_total = 100 - percentage_error_total;
fprintf('Total coin percentage accuracy: %.2f%%\n', percentage_accuracy_total);
