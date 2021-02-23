%% description 
%bayesian brain hypothesis - inference 
%premise here is that if you have a
%high contrast bar that moves at a certain velcoity, it will be percieved
%to move faster than a low contrast bar
%i.e. low contrast appears to move slower 
%   Other m-files required: none
%   MAT-files required: none
%

%   Author: Taranjit Sehmbi
%   Date: 15/02/2021 
%% initialise 
clear all;
clc;
%% variables
% normal distribution 
samples = -20:0.01:20;

%mean = u
%standard deviation = sigma
%normpdf(samples,u,sigma);

%standard deviation 
StdPrior = 2;
StdLikelihood = 1;

%likelihood
likelihood = normpdf(samples,2,StdLikelihood);
%prior 
prior = normpdf(samples,0,StdPrior);

%% plot  
PriorPlot = plot(samples,prior);

hold on
LikelihoodPlot = plot(samples,likelihood);

hold on
%every element of prior multiplied with corresponding element of likelihood
posterior = prior.*likelihood;
%does likelihood incorporate 1?
sum(likelihood)*0.01;
%does prior incorporate 1?
sum(prior)*0.01;
%does posterior incorporate 1? no
sum(posterior)*0.01;
%fix sum to 100 - normalisation 
posterior = posterior/sum(posterior)/0.01;
PosteriorPlot = plot(samples,posterior);
hold on;
xlabel('v');
ylabel('probability');
legend([PriorPlot, LikelihoodPlot, PosteriorPlot],'prior', 'likelihood', 'posterior');
xlim([0 8]);

%% maximum points
max(prior);
max(likelihood);
max(posterior);

%in the vector samples,which element that is equal to prior
meanPrior = samples(find(max(prior)==prior));
%will be the same as samples*likelihood'*.0.01
%also same as sum(samples.*likelihood)*.0.01

%for likelihood
meanLikelihood = samples(find(max(likelihood)==likelihood));
%for posterior
meanPosterior = samples(find(max(posterior)==posterior));

StdPosterior = std(posterior);

%% table 
Mean = [ meanPrior, meanLikelihood, meanPosterior]';
Distribution = {'Prior'; 'Likelihood'; 'Posterior'};
StandardD = [StdPrior, StdLikelihood, StdPosterior]' ;
table(Distribution, Mean, StandardD)