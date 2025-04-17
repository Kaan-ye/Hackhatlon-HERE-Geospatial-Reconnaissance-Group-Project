% Advanced Directed Graph Visualization from Tabular Data

% Author: Kaan Yiğit Ertem, Ceren Kekeç, Kamal Jokar - Spatial Reconnaissance
% Date: April 17, 2025
%
% IMPORTANT NOTE: This enhanced visualization was developed prior to the final
% presentation but could not be included.
%
% This code description actually describes features that are still under development and not 
% fully implemented in the current code. At the moment there is only code to visualize a simple Delaunay network, 
% but this description hints at advanced features to be added in the future:

% Representation of road networks evolving over time as a directional graph
% Visual enhancements based on characteristics such as road type and year of construction

clc; clear; close all;

% 1. Generate 20 Random Points (Berlin Region Simulation)
rng(42);  % For reproducibility
lon = 13.3 + (13.6 - 13.3) * rand(20,1);  % Longitude (X)
lat = 52.4 + (52.6 - 52.4) * rand(20,1);  % Latitude (Y)
points = [lon lat];  % [X Y] format

% 2. Delaunay Triangulation
DT = delaunayTriangulation(points);
% Extract triangle edges
edgeList = edges(DT);
% Calculate edge weights (Euclidean distances)
weights = vecnorm(points(edgeList(:,1),:) - points(edgeList(:,2),:), 2, 2);

% 3. Construct Undirected Graph
G = graph(edgeList(:,1), edgeList(:,2), weights);

% 4. Visualize Delaunay Network
figure('Color','w','Position',[100 100 800 600]);
p = plot(G, ...
    'XData', points(:,1), ...
    'YData', points(:,2), ...
    'EdgeColor', [0.2 0.6 0.8], ...
    'LineWidth', 2, ...
    'NodeColor', [0.2 0.2 0.2], ...
    'MarkerSize', 6);

% Plot Setting 
title('Example Delaunay Triangulation Network', 'FontSize', 14);
xlabel('Longitude');
ylabel('Latitude');
axis equal;
grid on;
