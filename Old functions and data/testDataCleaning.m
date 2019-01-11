% ORN's response decays after reaching peak, which make the Hill equation
% model does not at high concentration region, also cause the estimation of
% the parameters in the Hill equaiton has bias. 
% To test how much these 'bad' data points contribute to the fitting of the
% model, here, I will remove these data and fit the parameters again to see
% how much these parameters change.
% The creteria to tell bad data from good data: < peak * 0.9 after the
% peak.

% run after the scirpt 'ModelComparison.m' and 'FitSingleORNData.m', which 
% saved some data needed

%%
close all; clear; clc;
warning('off','all');
diary(fullfile('.', 'AnalysisResults', 'testdatacleaning.txt')); 
diary on;

%% 
ratio = 0.85;
addpath(fullfile('.', 'tools'));

%%
fName1 = fullfile('AnalysisResults', 'modelComparisonResults.mat');
load(fName1);

fName2 = fullfile('AnalysisResults', 'fitSingleORNdataResults.mat');
load(fName2);
%%
hillEq = @(a, b, c, x)  a./(1+ exp(-b*(x-c)));

ft1 = fittype( 'a/(1+ exp(-b*(x-c)))', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Robust = 'Bisquare';
opts.Lower = [-1 -1 -11]; % setup the range and initial value of the variable
opts.Upper = [10 15 -3];
opts.StartPoint = [5 5 -9];

ft2 = fittype( 'a/(1+ exp(-b*(x-c)))', 'independent', 'x', 'dependent', 'y' );
opts2 = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts2.Display = 'Off';
opts2.Robust = 'Bisquare';
opts2.Lower = [0 0 -2]; % setup the range and initial value of the variable
opts2.Upper = [2 10 3];
opts2.StartPoint = [1 5 0];

%%
% disp('----------FIT CURVE ENSEMBLE POOLED FROM CLEANED DATA:----------');
% fprintf('%5s\t%-20s\t%-5s\t%-5s\t\n', 'ORN', 'Odor', 'Slop', 'R^2');
% 
% [numORN, numOdor] = size(input.odors);
% 
% for i = 1 : numORN
%     for j = 1 : numOdor
%         xShare = log10(input.concList{i, j});   yBlock = input.dff{i, j}; 
%         trialNum = size(yBlock, 1);
%         xCell = cell(trialNum, 1);  yCell=cell(trialNum, 1);
%         
%         for k = 1 : trialNum
%             y = yBlock(k, :);   [a, ia] = max(y);
%             % check if any vlaue after the peak lower than a threshold.
%             threshold = a*ratio;
%             temp = min(find(y(ia: end) < threshold));
%             if ~isempty(temp)
%                 ir = ia -2 + temp;
%             else
%                 ir = ia;
%             end
%             xCell{k} = xShare(1:ir); yCell{k}=y(1:ir);
%         end
%         
%         coeff = results.fitCoeffIdv{i,j};
%         slop0 = median(coeff(:, 2)); ampVec0 = coeff(:, 1);	kdVec0  = coeff(:, 3);
%         [slop, ampVec, kdVec, rSquare] = EnsembleMiniSearch4Cell(xCell, yCell, hillEq, slop0, ampVec0, kdVec0);
%         fprintf('%5s\t%-20s\t%.2f\t%.2f\t\n', ...
%             input.ORNs{i}, input.odors{i, j}, slop, rSquare);
%     end
% end

%% clean the data and fit each individual curve using cleaned data

[numORN, numOdor] = size(input.odors);
coeff = cell(numORN, numOdor); r2 = cell(numORN, numOdor); 
coeffEn=coeff;  r2En = r2;

disp('----------FIT INDIVIDUAL CLEANED CURVE:----------');
fprintf('%5s\t%-20s\t%-5s\t%-5s\t%-5s\t%-5s\t%-5s\t\n', 'ORN', 'Odor', 'ExpID', 'Amp', 'Slop', 'EC_50', 'R^2');

for i = 1 : numORN
    for j = 1 : numOdor
        xShare = log10(input.concList{i, j});   yBlock = input.dff{i, j}; 
        trialNum = size(yBlock, 1);
        
        xxVec = []; yyVec = [];
        for k = 1 : trialNum
            y = yBlock(k, :);   [a, ia] = max(y);
            % check if any vlaue after the peak lower than a threshold.
            threshold = a*ratio;
            temp = min(find(y(ia: end) < threshold));
            if ~isempty(temp)
                ir = ia -2 + temp;
            else
                ir = ia;
            end
            xx = xShare(1:ir); yy =y(1:ir);

            [fitresult, gof] = fit(xx', yy', ft1, opts);
            coeff{i, j}(k,:) = coeffvalues(fitresult);    
            r2{i, j}(k) = gof.rsquare; 
            fprintf('%5s\t%-20s\t%5s\t%.2f\t%.2f\t%.2f\t%.2f\n', ...
                input.ORNs{i}, input.odors{i, j}, input.expID{i, j}{k}, ...
                coeff{i, j}(k,1), coeff{i, j}(k,2), coeff{i, j}(k,3), r2{i, j}(k));
            
            xxVec = [xxVec, xx-coeff{i, j}(k,3)]; 
            yyVec = [yyVec, yy/coeff{i, j}(k,1)]; 
        end
        
        % fit the shifted and normalized data
        [fitresult, gof] = fit(xxVec', yyVec', ft2, opts2);
        coeffEn{i, j} = coeffvalues(fitresult);    
        r2En{i, j} = gof.rsquare; 
        fprintf('%5s\t%-20s\t%5s\t%.2f\t%.2f\t%.2f\t%.2f\n', ...
            input.ORNs{i}, input.odors{i, j}, 'All', ...
            coeffEn{i, j}(1), coeffEn{i, j}(2), coeffEn{i, j}(3), r2En{i, j});

    end
end

diary off;