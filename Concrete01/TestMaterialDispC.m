% =========================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% Material Testing Template V2 %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% =========================================================================

%% Testing template for Concrete01 material

% clean start
clear all; close all; clc;

% loading function
Amp = [0.003 0.005 0.007 0.009 0.01 0.012 0.014 0.018 0.02 0.04];
Increment = 0.02;
nCycles = 2;
Time = zeros([length(Amp)*floor(6.28/Increment) 1]);
for i=1:length(Amp)
    for j=2:floor(6.28/Increment)
        Time(i*floor(6.28/Increment)+j-1) = Time(i*floor(6.28/Increment)+j-2) + Increment;
        V(i*floor(6.28/Increment)+j-1) = Amp(i)*sin(Time(i*floor(6.28/Increment)+j-1));
    end
end

% Material property
% Element = 'Elastic';
% Element = 'BLElastic';
% Element = 'BLHysteretic';
% Element = 'ElasticNoTension';
Element = 'Concrete01';   % Material type name

MatData = zeros(1,50);

% User input material properties
MatData(1,1) = 1;         % unique material tag
MatData(1,2) = 75;        % fpc: concrete maximum compressive strength (negative)
MatData(1,3) = 0.008;     % epsc: concrete strain at maximum strength (negative)
MatData(1,4) = 60;        % fpcu: concrete crushing strength (negative)
MatData(1,5) = 0.02;      % epscu: concrete strain at crushing strength (negative)

% trial variables
MatData(1,6) = 0;
MatData(1,7) = 0;
MatData(1,8) = 0;

% state history variables
MatData(1,9) = 1;
MatData(1,10) = 0.07;
MatData(1,11) = 1;
MatData(1,12) = 0;
MatData(1,13) = 0;
MatData(1,14) = 0;

% initialize the material
[MatData,~] = feval(Element,'initialize',MatData,0);
[MatData,E] = feval(Element,'getInitialStiffness',MatData,0);
[MatData,Fs] = feval(Element,'getInitialFlexibility',MatData,0);
 
% loop through the force vector
P = zeros(length(V),1);
for nn = 1:length(P)
    [MatData,~] = feval(Element,'setTrialStrain',MatData,V(nn));
    [MatData,P(nn)] = feval(Element,'getStress',MatData,0);
    [MatData,~] = feval(Element,'commitState',MatData,0);
end
 
figure;
plot(V,P)
xlabel('Strain')
ylabel('Stress')
grid
