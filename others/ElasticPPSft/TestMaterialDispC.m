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
V = 15*sin(Time);

% Material property
Element = 'ElasticPPSft';
MatData = zeros(1,50);

% User input material properties
MatData(1,1) = 1;         % unique material tag
MatData(1,2) = 1040000;     
MatData(1,3) = 1.625;  
MatData(1,4) = -1.625;
MatData(1,5) = 0;
MatData(1,6) = 2005000;
MatData(1,7) = 0;
MatData(1,8) = 0;
MatData(1,9) = 0;
MatData(1,10) = 0;
MatData(1,11) = 0;
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
plot(V,P,'LineWidth',2.0)
xlabel('Displacement')
ylabel('Force')
grid
