% =========================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% Material Testing Template V2 %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% =========================================================================

%% Testing template for ElasticNoTension material

% clean start
clear all; close all; clc;

% forcing function
Time = 0:0.01:10;
V = 0.05*sin(Time);

% Material property
% Element = 'Elastic';
% Element = 'BLElastic';
% Element = 'BLHysteretic';
Element = 'Elastic02';
MatData = zeros(1,50);

% User input material properties
MatData(1,1) = 1;         % unique material tag
MatData(1,2) = 100000;           % Epos: initial elastic modulus (tensile)
MatData(1,3) = 200000;       % Eneg: initial elastic modulus (compressive)

% state variables
MatData(1,4) = 0;
MatData(1,5) = 0.0;

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
plot(V,P,'LineWidth',2.0)
xlabel('Displacement')
ylabel('Force')
grid
