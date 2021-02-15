%lab1 - Implementation of 2AFC experiment with optimal observer
%   Used in MBM 2020/2021 to demonstrate scripting for workshop 1
%   Will be distributed through Canvas
%   Students will rename the script adding their ID to the name
%
%   Description:
%       lab1 models an optimal observer in a psychophysical experiment.
%       The experiment: At each trial, a standard stimulus and a comparison 
%       stimulus are presented. The comparison stimulus is chosen at random
%       The optimal observer has a representation of the two sensed values,
%       and its algorithm is that his response should be 0 or 1. The values
%       are corrupted by Gaussian noise. The script calculates the average
%       response produced for each comparison stimulus.
%
%   Other m-files required: none
%   MAT-files required: none
%

%   Author: Taranjit Sehmbi
%   Date: 15/02/2021 
%
%% initialization
clear all;
close all;
clc;
%initialise 
rng('shuffle');
%% variables
nTrials=5000;
standardNoNoise=4;
comparisonvalues=1:1:7;
nComparisons=length(comparisonvalues);
standardDeviationNoise=1.5;
%% variable preallocation
data=nan(2,nTrials);
meanResponsesForComparison=nan(1,nComparisons);
%% experiment
for trial=1:nTrials
    %The experiment comprises 5000 trials (nTrials). 
    %At each trial, select one comparison at random
    
    %stimulus presentation
    %with replacement 
    comparisonTrialNoNoise=comparisonvalues(randi(nComparisons));
    
    %without replacement 
    %comparisonTrialNoNoise=comparisonvalues(randperm(nComparisons));
        
    %noise corruption
    comparisonTrial=comparisonTrialNoNoise+randn(1)*standardDeviationNoise;
    standardTrial=standardNoNoise+randn(1)*standardDeviationNoise;
    
    %decision
    if comparisonTrial>standardTrial
        response=1;
    else
        response=0;
    end
    
    %disp([comparisonTrialNoNoise,response])
    %data storage
    data(:,trial)=[comparisonTrialNoNoise response];
end
%% data analysis
for c=1:nComparisons
    %mean response calculated for each of the standard values
    meanResponsesForComparison(c)=mean(data(2,data(1,:)==comparisonvalues(c)));
end

%% plot 
x = comparisonvalues;
y = meanResponsesForComparison;
plot(x,y,'b--o')
%create labels and axis limits 
xlabel('comparison value')
ylabel('mean response for comparison')
title('Plot of the mean response as a function of the value of the comparison ')
%would normally use legend if multiple plots on one figure
lgd = legend('mean response');
lgd.Location = 'northwest';
lgd.TextColor = 'blue';
lgd.Color = [0 1 0.5];
lgd.EdgeColor = 'b';
xlim([0 8]);
ylim([0 1]);
xticks(1:7);

%% PROBIT analysis 

bl = 1/5000;
bu = 1- bl;

BoundedmeanResponses = min(max(meanResponsesForComparison,bl),bu);
%transformed mean responses - response variable 
y1 = norminv(BoundedmeanResponses);
y1 = y1';

%matrix with 2 columns 
%right side with comparison stimulus values 
xa = comparisonvalues;
xa = xa';

%left side with ones 
xb = ones(size(comparisonvalues));
xb = xb';

X = [xb xa];
r = regress(y1,X);

%optimal observer response (oor)
oor = -r(1)/r(2);
varience = 1/r(2);

%gaussian cumulative plot 
plot(r, 'c*')
hold on
xlim([0 8]);
ylim([0 1]);
xticks(1:7);
plot(x,y,'b--o');
hold off 