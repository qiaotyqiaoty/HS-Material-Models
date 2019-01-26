% =========================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% Material Testing Template V2 %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% =========================================================================

% Check material

% clean start
clear all; close all; clc;

% forcing function
Amp = [0.003 0.005 0.007 0.009 0.01 0.012 0.014 0.018 0.02];
Increment = 0.02;
nCycles = 2;
Time = zeros([length(Amp)*floor(6.28/Increment) 1]);
for i=1:length(Amp)
    for j=2:floor(6.28/Increment)
        Time(i*floor(6.28/Increment)+j-1) = Time(i*floor(6.28/Increment)+j-2) + Increment;
        V(i*floor(6.28/Increment)+j-1) = Amp(i)*sin(Time(i*floor(6.28/Increment)+j-1));
    end
end

% material property
% Element = 'Elastic';
% Element = 'BLElastic';
% Element = 'BLHysteretic';
% Element = 'ElasticNoTension';
Element = 'Concrete01';

MatData = zeros(1,50);
MatData(1,1) = 1;      % unique material tag
MatData(1,2) = 45;          % fpc: concrete maximum compressive strength (negative)
MatData(1,3) = 0.0035;      % epsc:
MatData(1,4) = 14;          % fpcu:
MatData(1,5) = 0.014;       % epscu:
MatData(1,6) = 0.925;
MatData(1,7) = 0;
MatData(1,8) = 0;
MatData(1,9) = 1;
MatData(1,10) = 0.07;
MatData(1,11) = 1;
MatData(1,12) = 0;
MatData(1,13) = 0;
MatData(1,14) = 0;

% initialize the material
[MatData,~] = feval(Element,'initialize',MatData);
[MatData,E] = feval(Element,'getInitialStiffness',MatData);
[MatData,Fs] = feval(Element,'getInitialFlexibility',MatData);
 
% loop through the force vector
P = zeros(length(V),1);
for nn = 1:length(P)
    [MatData,~] = feval(Element,'setTrialStrain',MatData,V(nn));
    [MatData,P(nn)] = feval(Element,'getStress',MatData);
    [MatData,~] = feval(Element,'commitState',MatData);
end
 
figure;
plot(V,P)
xlabel('Strain')
ylabel('Stress')
grid
