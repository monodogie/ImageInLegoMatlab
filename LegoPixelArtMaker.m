%% Description
% This code is made by Kfir Assor, and is designed to take a picture and
% create a pixilized matrix made out from only pre-defined lego plate 1X1
% colors.

%% Code
close all
% First we load the picture we want to pixelized.
Picture = importdata('Pizza.jpg');

% We now define the available bricks we want to use to build the picture.
% The ID is again from the loaded 'colors.mat'. We use the colores given in
% a given in the text inside AliExpress_files. First we use the known
% available colors
color_matrix = [247,54,53;152,38,38;234,192,213;225,155,77;...
    169,143,95;170,202,96;254,196,63;209,185,137;105,87,147;215,168,84;...
    26,164,52;17,72,3;34,212,226;145,144,96;111,113,115;18,50,103;...
    0,176,225;178,212,249;0,99,242;187,188,192;255,252,249;124,86,73;...
    0,0,0;255,186,119];

% Here is an optional mask if we want to buy only specific colors
mask = true(length(color_matrix),1);
% mask = suggested_mask;
non_zero_idx = find(mask);
color_matrix(~mask,:)=[];

% Now we define some helpful constants and array 
bricks_in_x = 50; % desired x-resolution
bricks_in_y = 50; % desired y-resolution
x_length_leftover = mod(size(Picture,1),bricks_in_x);
y_length_leftover = mod(size(Picture,2),bricks_in_y);
Adjusted_Picture = Picture(1:end-x_length_leftover,...
                      1:end-y_length_leftover,:); %cut is used to simplify

Avg_picture = zeros(bricks_in_x,bricks_in_y,3);
color_id_picture = zeros(bricks_in_x,bricks_in_y);
range_x = size(Adjusted_Picture,1)/bricks_in_x;
range_y = size(Adjusted_Picture,2)/bricks_in_y;

for i = 1:bricks_in_x
    for j = 1:bricks_in_y
        curr_seq_x = (i-1)*range_x+1:i*range_x;
        curr_seq_y = (j-1)*range_y+1:j*range_y;
        curr_part = Adjusted_Picture(curr_seq_x,curr_seq_y,:);
        avg_pix = mean(mean(curr_part));
        idx = knnsearch(color_matrix, [avg_pix(1),avg_pix(2),avg_pix(3)]);
        color_id_picture(i,j)=non_zero_idx(idx);
        Avg_picture(i,j,:) = (color_matrix(idx,:));
    end
end

%% Results
Avg_picture = uint8(Avg_picture);
figure(1)
imshow(Picture)
figure(2)
imshow(Avg_picture)
figure
h = histogram(color_id_picture,1:length(color_matrix)+1);

minimal_in_sack = 20; %minimal parts in a bag
suggested_mask = (h.Values >= minimal_in_sack);
