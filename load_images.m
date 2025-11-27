function [imgs, filenames] = load_images(folder)
    % Get list of .jpg and .JPG files
    files = dir(fullfile(folder, '*.JPG'));
    
    if isempty(files)
        error('No JPG files found in %s', folder);
    end

    imgs = [];
    for i = 1:length(files)
        img = imread(fullfile(folder, files(i).name));

        if isempty(imgs)
            % Preallocate with color channel included
            imgs = zeros([size(img), length(files)]);
        end

        imgs(:,:,:,i) = img;
    end

    filenames = {files.name};
end