%% Read CSV of the result

% Read the CSV file into a table object
data_dir = 'E:\Projects\brainslice\data\OLD\deepslice\';
clickpoint_filename = [data_dir, 'clicked_points.csv'];
deepslice_filename = [data_dir, 'MyResults.csv'];


%% Read click points csv, and join
click_point_table = readtable(clickpoint_filename);
data_table = readtable(deepslice_filename);

joined_data_table = join(click_point_table, data_table, 'Keys', 'Filenames');
joined_data_table 


%% iterate over all the probes, trasform the coordinates to allenCCF coordinates
probe_num = max(joined_data_table.probe_id);
probePoints = {};
for probe_id = 1:probe_num
    all_pixel_coord = [];
    df_probe = joined_data_table(joined_data_table.probe_id == probe_id, :);
    for column = 1 : size(df_probe, 1)
        coordinates = table2array(df_probe(column, {'ox', 'oy', 'oz', 'ux', 'uy', 'uz', 'vx', 'vy', 'vz'}));
        coordinates
        pixel_coord = transform_coords(coordinates, df_probe.x(column), df_probe.y(column));
        all_pixel_coord = [all_pixel_coord; pixel_coord];
    end
    probePoints{end+1} = all_pixel_coord;
end

% Save the variable to a MAT file
save([data_dir, 'probePoints.mat'], 'probePoints');