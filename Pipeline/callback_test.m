function figureCallback(src,event)
line = findobj(src,"Type","Line");
if event.Character == "+"
    line.LineWidth = line.LineWidth+1;
elseif event.Character == "-"
    line.LineWidth = max(line.LineWidth-1,0.5);
end
end

f = figure(WindowKeyPressFcn=@figureCallback);
plot(1:10)

%% 
function displayCoordinates(src,~,ax)
src.MarkerEdgeColor = rand(1,3);
disp(ax.CurrentPoint(1,1:2))
end

ax = axes;
x = randn(100,1);
y = randn(100,1);
scatter(x,y,"ButtonDownFcn",@(src,event)displayCoordinates(src,event,ax))

%%
% Create a sample struct
my_struct = struct('name', 'John Doe', 'age', 35, 'email', 'john.doe@example.com');

% Add a new field using struct()
a = 'a1';
my_struct.(a) = '123';
%my_struct = struct(my_struct, 'phone', '123-456-7890');

% Display the updated struct
disp(my_struct);


%%
% Define the data (mix of numbers and strings)
data = [1, 'John Doe', 2, 'Jane Smith'];
% 3, 'Bob Johnson', 4, 'Alice Williams'];

% Write the data to a CSV file
writematrix(data, 'example_data.csv');
