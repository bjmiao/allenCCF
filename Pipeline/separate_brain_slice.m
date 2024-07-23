% Read the image
img = imread('E:\Projects\brainslice\data\OLD\Well4_ChannelEGFP,mCherry,Alx647_Seq0003.nd2 (RGB) (1).tif');
path = 'E:\Projects\brainslice\data\OLD\deepslice\';
prefix = "647";
% Create the figure and display the image
base_count = 38 ;
figure;
imshow(img);
title('Select regions of interest');

% Initialize the list of regions
regions = {};
region_count = 1;

% Allow the user to select regions interactively
while true
    % Prompt the user to select a region
    fprintf('Select region %d or press Enter to finish.\n', region_count);
    rect = imrect;
    
    % % If the user presses Enter, exit the loop
    % if isempty(rect.getPosition())
    %     break;
    % end
    
    % Get the selected region
    region = getPosition(rect);
    region
    
    % Crop the image to the selected region
    if region(2) < 1
        region(2) = 1;
    end


    if region(1) < 1
        region(1) = 1;
    end

    region_img = img(round(region(2)):round(region(2)+region(4)), round(region(1)):round(region(1)+region(3)), :);
    
    % Add the region to the list
    regions{end+1} = region_img;
    
    imwrite(regions{region_count}, sprintf('%s\\%s_s%.03d.jpg', path, prefix, region_count+base_count));

    % Display the selected region
    rectangle('Position', region, 'EdgeColor', 'r', 'LineWidth', 2);
    text(region(1)+100, region(2)+100, string(region_count), 'Fontsize', 16);

    % Increment the region count
    region_count = region_count + 1;    
end

fprintf('Selected regions have been saved as separate files.\n');