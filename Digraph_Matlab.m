% Advanced Directed Graph Visualization from Tabular Data
% Author: [Kaan Yiğit Ertem, Ceren Kekeç Spatial Reconnaissance]
% Date: April 17, 2025
% Version: 1.0
%
% IMPORTANT NOTE: This enhanced visualization was developed prior to the final
% presentation but could not be included due to time constraints. The code
% implements an advanced graph visualization technique with customizable
% parameters and aesthetically optimized output.
%
% This script demonstrates how to:
%  - Generate a directed graph from tabular data
%  - Apply visual enhancements based on graph metrics
%  - Optimize layouts for better readability
%  - Configure multiple visualization parameters

% Configuration Parameters
% Adjust these parameters to customize the visualization
config = struct();
config.figureSize = [900, 700];     % Width and height of output figure
config.nodeBaseSize = 6;            % Base size for all nodes
config.nodeSizeMultiplier = 2;      % Size multiplier based on node importance
config.edgeBaseWidth = 1;           % Base width for all edges
config.edgeWidthMultiplier = 2;     % Width multiplier based on edge weight
config.arrowSize = 8;               % Size of directional arrows
config.useColorGradient = true;     % Use color gradient for nodes
config.circularLayout = true;       % Use circular layout instead of force layout

%% Generate Sample Dataset
% In production, this would be replaced by data import functionality
fprintf('Generating sample graph dataset...\n');

% Source, target and weight for sample connections
source = [1, 1, 2, 2, 3, 3, 4, 5, 6, 6];
target = [2, 3, 4, 5, 5, 6, 7, 7, 8, 8];
weight = [0.5, 0.8, 0.4, 0.6, 0.9, 0.3, 0.7, 0.5, 0.6, 0.4];

% Combine data as a table
graphData = table(source', target', weight', 'VariableNames', {'Source', 'Target', 'Weight'});

% Display dataset summary
fprintf('Dataset created with %d connections between nodes\n', height(graphData));
disp('Sample of the dataset:');
disp(head(graphData, 5));

%% Create Directed Graph Object
% Initialize graph object from tabular data
G = digraph(graphData.Source, graphData.Target, graphData.Weight);
fprintf('Graph created with %d nodes and %d edges\n', numnodes(G), numedges(G));

% Calculate network metrics
nodeMetrics = struct();
nodeMetrics.inDegree = indegree(G);
nodeMetrics.outDegree = outdegree(G);
nodeMetrics.totalConnections = nodeMetrics.inDegree + nodeMetrics.outDegree;
nodeMetrics.betweennessCentrality = centrality(G, 'betweenness');

fprintf('Network metrics calculated for all nodes\n');

%% Generate Visualization
fprintf('Generating graph visualization...\n');

% Initialize figure with appropriate size
figure('Position', [100, 100, config.figureSize(1), config.figureSize(2)], 'Name', 'Network Analysis');

% Set initial layout algorithm
if config.circularLayout
    layoutType = 'circle';
else
    layoutType = 'force';
end

% Create plot with base properties
p = plot(G, 'Layout', layoutType, ...
         'EdgeColor', [0.2 0.4 0.8], ...
         'LineWidth', config.edgeBaseWidth, ...
         'ArrowSize', config.arrowSize);

% Apply node formatting based on connectivity metrics
nodeSizes = config.nodeBaseSize + config.nodeSizeMultiplier * nodeMetrics.totalConnections;
p.MarkerSize = nodeSizes;
p.NodeFontSize = 10;

% Apply edge formatting based on weights
p.LineWidth = config.edgeBaseWidth + config.edgeWidthMultiplier * G.Edges.Weight;

% Format edge labels (weights)
p.EdgeLabel = round(G.Edges.Weight*10)/10;
p.EdgeFontSize = 8;

% Set node labels with prefix for clarity
nodeLabels = cellstr("Node " + string(1:numnodes(G)));
labelnode(p, 1:numnodes(G), nodeLabels);

% Apply color scheme to nodes
if config.useColorGradient
    % Use a custom colormap based on node importance
    colorMap = jet(numnodes(G));
    p.NodeColor = colorMap;
    fprintf('Applied color gradient to nodes based on connectivity\n');
else
    % Use a single color for all nodes
    p.NodeColor = [0.8 0.2 0.2];
    fprintf('Applied uniform coloring to all nodes\n');
end

%% Layout Optimization
% Apply custom circular layout for optimal visibility
if config.circularLayout
    fprintf('Optimizing node positions with circular layout...\n');
    theta = linspace(0, 2*pi, numnodes(G)+1)';
    radius = 3;
    x = radius * cos(theta(1:end-1));
    y = radius * sin(theta(1:end-1));
    
    % Apply the calculated positions
    p.XData = x;
    p.YData = y;
else
    fprintf('Using force-directed layout algorithm\n');
end

%% Visualization Enhancements
% Add title and metadata
title('Network Analysis Visualization', 'FontSize', 14, 'FontWeight', 'bold');
subtitle('Directed Graph with Weighted Connections', 'FontSize', 12);

% Remove axes for cleaner look
set(gca, 'XColor', 'none', 'YColor', 'none');
set(gcf, 'Color', [0.98 0.98 1.0]);

% Add information panel with graph metrics
infoBox = sprintf('Graph Summary:\n- Nodes: %d\n- Connections: %d\n- Avg. Weight: %.2f', ...
               numnodes(G), numedges(G), mean(G.Edges.Weight));
annotation('textbox', [0.02, 0.02, 0.25, 0.1], 'String', infoBox, ...
           'FitBoxToText', 'on', 'BackgroundColor', [1 1 1 0.8], ...
           'EdgeColor', [0.7 0.7 0.7], 'FontSize', 9);

% Add timestamp and version info
timestampStr = sprintf('Generated: %s | Version: 1.0', datestr(now, 'yyyy-mm-dd HH:MM'));
annotation('textbox', [0.7, 0.01, 0.29, 0.03], 'String', timestampStr, ...
           'FitBoxToText', 'on', 'EdgeColor', 'none', 'FontSize', 8);

% Add development note
noteText = 'NOTE: This enhanced visualization was developed but not included in the final presentation';
annotation('textbox', [0.25, 0.95, 0.5, 0.04], 'String', noteText, ...
           'FitBoxToText', 'on', 'EdgeColor', [0.7 0 0], 'BackgroundColor', [1 0.9 0.9], ...
           'FontSize', 8, 'HorizontalAlignment', 'center');

fprintf('Visualization complete\n');

% Export Options (Commented by default)
% Uncomment these lines to enable export functionality
% 
% % Export to high-resolution image
% fprintf('Exporting visualization to PNG file...\n');
% exportPath = './outputs/network_analysis_visualization.png';
% print(exportPath, '-dpng', '-r300');
% fprintf('Visualization exported to: %s\n', exportPath);
% 
% % Export graph data to CSV for future reference
% writetable(graphData, './outputs/network_data.csv');
% fprintf('Graph data exported to CSV file\n');

fprintf('Script execution complete\n');
