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
Element = 'ElasticNoTension';
MatData = zeros(1,50);

% User input material properties
MatData(1,1) = 1;         % unique material tag
MatData(1,2) = 200000;    % E: initial elastic modulus (compression)

% state variables
MatData(1,3) = 0;  
MatData(1,4) = 0;
MatData(1,5) = 0.0;
MatData(1,6) = 1.0;

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
xlabel('Displacement')
ylabel('Force')
grid
