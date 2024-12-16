function segmentedRegion = regionGrowingSegmentation(image, seed_x, seed_y, intensity_threshold)
    % Default intensity threshold if not provided
    if nargin < 4, intensity_threshold = 0.2; end

    % Initialize the segmented region and region properties
    segmentedRegion = zeros(size(image));
    image_size = size(image);
    region_mean_intensity = image(seed_x, seed_y);
    region_pixel_count = 1;

    % Initialize the neighbor list
    neighbor_capacity = 10000;
    neighbor_count = 0;
    neighbor_list = zeros(neighbor_capacity, 3);

    % Define the 4-connectivity neighborhood
    neighbors = [-1 0; 1 0; 0 -1; 0 1];

    % Start the region growing process
    pixel_distance = 0;
    while pixel_distance < intensity_threshold && region_pixel_count < numel(image)
        % Add neighboring pixels
        for i = 1:4
            xn = seed_x + neighbors(i, 1);
            yn = seed_y + neighbors(i, 2);
            inside_bounds = (xn >= 1) && (yn >= 1) && (xn <= image_size(1)) && (yn <= image_size(2));

            if inside_bounds && segmentedRegion(xn, yn) == 0
                neighbor_count = neighbor_count + 1;
                neighbor_list(neighbor_count, :) = [xn, yn, image(xn, yn)];
                segmentedRegion(xn, yn) = 1;
            end
        end

        % Expand the neighbor list if necessary
        if neighbor_count + 10 > neighbor_capacity
            neighbor_capacity = neighbor_capacity + 10000;
            neighbor_list((neighbor_count + 1):neighbor_capacity, :) = 0;
        end

        % Find the neighbor pixel with the smallest intensity difference
        differences = abs(neighbor_list(1:neighbor_count, 3) - region_mean_intensity);
        [pixel_distance, index] = min(differences);

        % Add the selected pixel to the region
        segmentedRegion(seed_x, seed_y) = 2;
        region_pixel_count = region_pixel_count + 1;

        % Update the region's mean intensity
        region_mean_intensity = (region_mean_intensity * region_pixel_count + neighbor_list(index, 3)) / (region_pixel_count + 1);

        % Update the seed point
        seed_x = neighbor_list(index, 1);
        seed_y = neighbor_list(index, 2);

        % Remove the pixel from the neighbor list
        neighbor_list(index, :) = neighbor_list(neighbor_count, :);
        neighbor_count = neighbor_count - 1;
    end

    % Return the segmented region as a logical matrix
    segmentedRegion = segmentedRegion > 1;
end
