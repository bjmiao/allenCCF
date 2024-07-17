%% Read CSV of the result

% Read the CSV file into a table object
data_table = readtable('E:\Projects\brainslice\DeepSlice\DeepSlice\examples\AP_AMY_slide1\test.csv');

%% Read click points csv, and join

click_point_table = readtable('click_points.csv');
for image_id = 1:size(click_point_table, 1)
    [filepath, filename, ext] = fileparts(char(click_point_table.Filenames(image_id)));
    filename = [filename, ext];
    click_point_table(image_id, 1) = {filename};
end

joined_data_table = join(data_table, click_point_table, 'Keys', 'Filenames');
joined_data_table 

%% Transform the coordinates to AllenCCF coordinates
all_pixel_coord = [];
for column = 1 : size(data_table, 1)
    coordinates = table2array(data_table(column, 2:10));
    pixel_coord = transform_coords(coordinates, joined_data_table.x(column), joined_data_table.y(column));
    all_pixel_coord = [all_pixel_coord; pixel_coord];
end
all_pixel_coord