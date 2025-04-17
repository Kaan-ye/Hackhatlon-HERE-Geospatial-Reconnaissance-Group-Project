% Statistical Approach of Eligible Data 
% detailed_stats_2019.m
% Detailed statistical analysis for 2019dataa.csv
% Exploration Data Analysis of Available Data 

clc; clear; close all;

% Read the data
data = readtable('2019dataa.csv');
vars = data.Properties.VariableNames;

fprintf('Total Observations: %d, Variables: %d\n\n', height(data), width(data));

% Identify numerical columns
numericVars = varfun(@isnumeric, data, 'OutputFormat', 'uniform');
numData = data(:, numericVars);
numNames = data.Properties.VariableNames(numericVars);

% Descriptive Statistics
disp('--- Descriptive Statistics ---');
for i = 1:numel(numNames)
    col = numData.(numNames{i});
    fprintf('\n▶ %s\n', numNames{i});
    fprintf('  Mean         : %.3f\n', mean(col, 'omitnan'));
    fprintf('  Median       : %.3f\n', median(col, 'omitnan'));
    fprintf('  Standard Deviation : %.3f\n', std(col, 'omitnan'));
    fprintf('  Min - Max    : %.3f - %.3f\n', min(col), max(col));
    fprintf('  Skewness     : %.3f\n', skewness(col, 'omitnan'));
    fprintf('  Kurtosis     : %.3f\n', kurtosis(col, 'omitnan'));
end

% Normality Test (Kolmogorov-Smirnov)
disp('--- Normality Test (kstest) ---');
for i = 1:numel(numNames)
    col = numData.(numNames{i});
    col = col(~isnan(col));
    if length(col) > 20
        % Normalizing the Data 
        [h, p] = kstest((col - mean(col)) / std(col)); 
        fprintf('%s: %s (p = %.4f)\n', numNames{i}, ternary(h==1,'Not Normal','Normal'), p);
    else
        fprintf('%s: Insufficient data (n < 20)\n', numNames{i});
    end
end

% Correlation and Visual Analysis
if width(numData) >= 2
    figure;
    corrMatrix = corr(table2array(numData), 'rows', 'pairwise');
    heatmap(numNames, numNames, corrMatrix, ...
        'Colormap', parula, 'ColorbarVisible','on');
    title('Correlation Matrix');
end

% Histogram + Boxplot (Visual Analysis)
for i = 1:numel(numNames)
    col = numData.(numNames{i});
    figure;
    subplot(1,2,1);
    histogram(col, 30);
    title(['Histogram: ', numNames{i}]);
    xlabel(numNames{i});
    ylabel('Frequency');
    grid on;

    subplot(1,2,2);
    boxplot(col);
    title(['Boxplot: ', numNames{i}]);
    ylabel(numNames{i});
end
