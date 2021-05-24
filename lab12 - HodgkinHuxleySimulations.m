%% initalise 
close all 
clear all 
clc
%% Hodgkin–Huxley model

% simulation time - obseve changes in voltage & conductances over time 
t = 0:0.01:100; %milliseconds 

% external current 
changeTimes = [0]; %miliseconds
currentLevels = [0.1]; % change to see effect of different currents on voltage 

% change current at time steps - current applied across time 
I(1:500) = currentLevels;
I(501:2000) = 0;
I(2001:numel(t)) = currentLevels; 

%I(1:numel(t)) = currentLevels;  %constant current

%==========================================================================

%constant parameters from the paper: table 3 - page 520
% depolarisation will be a positive event so the sign of each of the
% equilibrium variables is switched (i.e. + becomes - and - becomes +) 
C = 1; %capacitance = membrane of the neuron 
V_Na = 115; %sodium voltage 
V_K = -12; % potassium voltage
V_L = 10.6; %leakage 
G_Na = 120; %sodium conductance
G_K = 36; % posattium conductance
G_L = 0.3; %leakage conductance

%==========================================================================
% inital states 
V=0; %baseline voltage   
alpha_n = 0.01* ((10-V)/(exp((10-V)/10)-1)); %equation 12
beta_n = 0.125*exp(-V/80); %equation 13
alpha_m = 0.1*((25-V)/(exp((25-V)/10)-1)); %equation 20
beta_m = 4*exp(-V/18); %equation 21
alpha_h = 0.07*exp(-V/20); %equation 23
beta_h = 1/(exp((30-V)/10)+1); %equation 24 

n(1) = alpha_n/(alpha_n+beta_n); %equation 9 
m(1) = alpha_m/(alpha_m+beta_m); %equation 18
h(1) = alpha_h/(alpha_h/beta_h); % equation 18 
%==========================================================================

for i=1:numel(t)-1 %coefficients, currents and derivatives at each time 
    %coefficients at each step - same equations as inital states 
    alpha_n(i) = 0.01* ((10-V(i))/(exp((10-V(i))/10)-1));
    beta_n(i) = 0.125*exp(-V(i)/80);
    alpha_m(i) = 0.1*((25-V(i))/(exp((25-V(i))/10)-1));
    beta_m(i) = 4*exp(-V(i)/18);
    alpha_h(i) = 0.07*exp(-V(i)/20);
    beta_h(i) = 1/(exp((30-V(i))/10)+1); 
    
    % currents 
    I_Na = (m(i)^3) * G_Na * h(i) * (V(i)-V_Na); % equations 3 & 14
    I_K = (n(i)^4) * G_K * (V(i)-V_K); % equations 4 & 6 
    I_L = G_L * (V(i)-V_L); % equation5 
    I_ion = I(i) - I_K - I_Na - I_L;
    
    % derivative using Euler first order approx.
    V(i+1) = V(i) + 0.01*I_ion/C; 
    n(i+1) = n(i) + 0.01*(alpha_n(i) * (1-n(i)) - beta_n(i) * n(i)); % equation 7
    m(i+1) = m(i) + 0.01*(alpha_m(i) * (1-m(i)) - beta_m(i) * m(i));  % equations 15
    h(i+1) = h(i) + 0.01*(alpha_h(i) * (1-h(i)) - beta_h(i) * h(i));  % equation 16
end 

V = V-70; %resting state potential is -70mV 

%% plot
% plot voltage 
figure
subplot(2,1,1)
plot(t,V, 'LineWidth', 2); hold on 
legend({'Voltage'})
ylabel('Voltage(mV)')
xlabel('Time(ms)')
title("Volatge over time in simulated neuron when extenal current is " + currentLevels)

% plot conductance 
subplot(2,1,2)
p1 = plot(t, G_K*n.^4, 'LineWidth', 1.5); hold on 
p2 = plot(t, G_Na*(m.^3).*h, 'r', 'LineWidth', 1.5);
legend([p1, p2], 'Conductance for Potassium', 'Conductance for Sodium')
ylabel('Conductance')
xlabel('time(ms)')
title("Conductance for Potassium and Sodium Ions in Simulated Neuron when extenal current is " + currentLevels)