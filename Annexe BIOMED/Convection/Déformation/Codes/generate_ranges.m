function ranges = generate_ranges(stepx,stepy)
    % Initialize the result
    ranges = [];
    
    % Define the groups and their starting and ending points
    groups = [
        6, 24;
        26, 44;
        46, 64 
    ];
    
    initial_offset = 3;
    
    % Loop through each group
    for g = 1:size(groups, 1)
        start_val = groups(g, 1);
        end_val = groups(g, 2);
        
        % Reset the offset for each group
        offset = initial_offset;
        
        % Generate the ranges for the current group
        for i = start_val:stepx:end_val
            ranges = [ranges; i, i + stepx, offset];
            offset = offset + stepy; % Increment the offset
        end
    end
end
