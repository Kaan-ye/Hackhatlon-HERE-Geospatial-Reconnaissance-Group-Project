% Statistical Approach of Eligible Data 
% data_analysis_2019.m
% General data analysis for 2019dataa.csv

clc; clear; close all;

% Reading Data
data = readtable('2019dataa.csv');

% Check the first few rows
disp('--- First 5 Rows ---');
disp(head(data, 5));

fprintf('\nTotal Rows: %d, Columns: %d\n', height(data), width(data)); % Size information 
disp('--- Columns ---');% Column names
disp(data.Properties.VariableNames');

% Missing Data Analysis
disp('--- Missing Data Status ---');
missingCounts = sum(ismissing(data));
T_missing = table(data.Properties.VariableNames', missingCounts', ...
    'VariableNames', {'Column', 'MissingCount'});
disp(T_missing);

% Statistical Summary for Numeric Features
disp('--- Numeric Features (mean, std, min, max) ---');
numericVars = varfun(@isnumeric, data, 'OutputFormat', 'uniform');
summaryStats = varfun(@(x)[mean(x,'omitnan'), std(x,'omitnan'), min(x), max(x)], ...
    data(:,numericVars));

% Organizing Column Name ReNaming
statNames = {'Mean', 'StdDev', 'Min', 'Max'};
statTable = array2table(cell2mat(summaryStats{:}), ...
    'VariableNames', statNames, ...
    'RowNames', data.Properties.VariableNames(numericVars));
disp(statTable);

% Correlation Matrix
numericData = data{:, numericVars};
if size(numericData,2) >= 2
    corrMatrix = corr(numericData, 'rows', 'pairwise');
    figure;
    heatmap(data.Properties.VariableNames(numericVars), ...
            data.Properties.VariableNames(numericVars), ...
            corrMatrix, 'Colormap', parula, 'ColorbarVisible','on');
    title('Correlation Matrix');
else
    disp('Insufficient numeric data for correlation.');
end

% Example: If Latitude & Longitude exist, display on map
if all(ismember({'latitude', 'longitude'}, lower(data.Properties.VariableNames)))
    lat = data.latitude;
    lon = data.longitude;
    figure;
    geoplot(lat, lon, 'o')
    title('Location Data (latitude-longitude)')
end
