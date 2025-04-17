% Advanced Directed Graph Visualization from Tabular Data
% Author: [Kaan Yiğit Ertem, Ceren Kekeç, Kamal Jokar Spatial Reconnaissance]
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



% Simple Directed Graph Visualization
% Created: April 17, 2025
% Note: This visualization was developed but not included in the final presentation.

% Create Sample Data
% Create example data for our graph
source = [1, 1, 2, 2, 3, 3, 4, 5, 6, 6];
target = [2, 3, 4, 5, 5, 6, 7, 7, 8, 8];
weight = [0.5, 0.8, 0.4, 0.6, 0.9, 0.3, 0.7, 0.5, 0.6, 0.4];

% Create a table with the data
data = table(source', target', weight', 'VariableNames', {'Source', 'Target', 'Weight'});

% Show sample of the data
disp('Graph data:');
disp(data);

% Create and Plot Graph
% Create the digraph from our data
G = digraph(data.Source, data.Target, data.Weight);

% Create a new figure
figure('Position', [100, 100, 800, 600]);

% Plot the graph
p = plot(G, 'Layout', 'force', 'EdgeColor', [0.2 0.4 0.8], 'LineWidth', 1.5);

% Customize nodes
p.NodeColor = [0.8 0.2 0.2];  % Red nodes
p.MarkerSize = 8;             % Base size
p.NodeFontSize = 10;

% Make nodes bigger based on number of connections
node_connections = indegree(G) + outdegree(G);
p.MarkerSize = 6 + 1.5*node_connections;

% Add node labels
labelnode(p, 1:numnodes(G), cellstr("N" + string(1:numnodes(G))));

% Add edge weights as labels
p.EdgeLabel = round(G.Edges.Weight*10)/10;
p.EdgeFontSize = 8;

% Make edge thickness reflect weights
p.LineWidth = 1 + G.Edges.Weight;

% Use different colors for nodes
node_colors = jet(numnodes(G));
p.NodeColor = node_colors;

% Finalize Visualization
% Add title
title('Directed Graph Visualization', 'FontSize', 14);

% Hide axes
set(gca, 'XColor', 'none', 'YColor', 'none');
set(gcf, 'Color', [0.95 0.95 1.0]);

% Add info text
info_text = {'Nodes: ' + string(numnodes(G)), 'Edges: ' + string(numedges(G))};
annotation('textbox', [0.02, 0.02, 0.2, 0.08], 'String', info_text, 'FitBoxToText', 'on', 'BackgroundColor', [1 1 1 0.8], 'EdgeColor', [0.7 0.7 0.7]);

% Add note about presentation
note = 'Note: This visualization was not included in the final presentation';
annotation('textbox', [0.25, 0.95, 0.5, 0.04], 'String', note,'FitBoxToText', 'on', 'EdgeColor', [0.7 0 0],'BackgroundColor', [1 0.9 0.9], 'FontSize', 8);

% Arrange in circular layout for better visibility
theta = linspace(0, 2*pi, numnodes(G)+1)';
x = 3 * cos(theta(1:end-1));
y = 3 * sin(theta(1:end-1));

% Apply the layout
p.XData = x;
p.YData = y;
