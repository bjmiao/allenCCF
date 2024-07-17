%% Read all the images in the folder, in the format of xxxxx_s0XX
% Set the directory path where the images are located
image_dir = 'E:\Projects\brainslice\DeepSlice\DeepSlice\examples\AP_AMY_slide1\';

% Get a list of all files in the directory
all_files = dir(image_dir);

% Initialize a cell array to store the image filenames
image_files = {};

% Loop through the files and find the ones with .jpg or .png extension
for i = 1:length(all_files)
    if ~all_files(i).isdir && (endsWith(all_files(i).name, '.jpg') || endsWith(all_files(i).name, '.png'))
        image_files{end+1} = all_files(i).name;
    end
end

% Display the list of image files
disp(image_files);

%% Read the result of csv file
csv_file = [image_dir, '\MyResults.csv'];

% Read the CSV file into a MATLAB table
data_table = readtable(csv_file);


%% Then, display each image, and ask the user to click on the floursecne point

% load all the images
for file_idx = 1:length(data_table.Filenames)
    % Load the image
    image_file = [image_dir, char(data_table.Filenames(file_idx))];
    image_data = imread(image_file);
    [height, width, ~] = size(image_data);
    % Create the figure and axes with callbacks
    clicked_points = [];
    global probe_labeler
    probe_labeler = struct( ...
        'filename', image_file, ...
        'now_labeling_probe', '1', ...
        'save_result_path', ['.\click_points.csv'], ...
        'clicked_probe_points', struct(), ...
        'height', height, ...
        'width', width ...
    );
    fig = figure('WindowKeyPressFcn', @(src,event) figure_presskey_handler(src, event), 'Position', [0 0 1000 1000]);
    handle = imshow(image_data,  'InitialMagnification', 'fit');
    set(handle, "ButtonDownFcn", @(src,event) figure_click_handler(src, event))
    changetitle = @(channel) title(["Now labeling probe", channel, "Press 1-9 to select probe","Press c to clean all","Press f to finish and go to the next"]);
    changetitle('1');
    nowlabelprobe = '1';
    
    % Wait until the user closes the first figure
    waitfor(fig);
    disp("Ready for next figure");
end

function clean_and_draw_all_annotations()
    global probe_labeler
    % delete all annotations
    all_text = findall(gcf, 'Type', 'text');
    delete(all_text);
    % title(["Now labeling probe", probe_labeler.now_labeling_probe, "Press 1-9 to select probe","Press c to clean all","Press f to finish and go to the next"]);
   
    fields = fieldnames(probe_labeler.clicked_probe_points);
    for i = 1:length(fields)
        field = char(fields(i));
        coords = probe_labeler.clicked_probe_points.(field);
        x = coords(1);
        y = coords(2);
        text(x, y, field(end), 'Color', 'red', 'FontSize', 12, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    end
end

% Function to record the click coordinates and add an annotation
function figure_click_handler(src, event)
    global probe_labeler
    point_coords = get(gca, 'CurrentPoint');
    x = point_coords(1,1);
    y = point_coords(1,2);
    disp(['Clicked point: (', num2str(x), ', ', num2str(y), ')']);

    probe_labeler.clicked_probe_points.(['probe_', probe_labeler.now_labeling_probe]) = [x y];
    clean_and_draw_all_annotations()
end

function figure_presskey_handler(src, event, probe_labeler)
    global probe_labeler
    if ismember(event.Character, ['1', '2', '3', '4', '5', '6', '7', '8', '9'])
        title(["Now labeling probe", event.Character, "Press 1-9 to select probe","Press c to clean all","Press f to finish and go to the next"]);
        probe_labeler.now_labeling_probe = event.Character;
    elseif event.Character == 'c'
        probe_labeler.clicked_probe_points = struct();
        clean_and_draw_all_annotations();
    elseif event.Character == 'f'
        % save the file
        csv_file = probe_labeler.save_result_path;

        if ~exist(csv_file, 'file')
            fid = fopen(csv_file, 'w');
            disp("creat new file");
            fprintf(fid, "Filenames,probe_id,x,y\n"); % header
            fclose(fid);
        end
        fields = fieldnames(probe_labeler.clicked_probe_points);
        fid = fopen(csv_file, 'a');
        for i = 1:length(fields)
            field = char(fields(i))
            coords = probe_labeler.clicked_probe_points.(field);
            x = coords(1) / probe_labeler.width;
            y = coords(2) / probe_labeler.height;
            probe_labeler.filename
            fprintf(fid, "%s,%s,%f,%f\n",probe_labeler.filename, field(end), x, y);
        end
        fclose(fid);
        close(gcf)
    end

end


%% Transform the coordinates, so that we can have the key points of the probe


%% Save it to a CSV file