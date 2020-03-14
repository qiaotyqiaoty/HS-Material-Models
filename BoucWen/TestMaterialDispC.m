% =========================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% Material Testing Template V2 %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% =========================================================================

%% Testing template for BoucWen material

% clean start
clear all; close all; clc;

% forcing function
Time = 0:0.01:15;
V = 3*sin(Time);

% Material property
Element = 'BoucWen';
MatData = zeros(1,50);

% User input material properties
MatData(1,1) = 1;         % unique material tag
MatData(1,2) = 0.0001;      % alpha - hardening ratio
MatData(1,3) = 260;        % ko - initial stiffness
MatData(1,4) = 1.7;       % n
MatData(1,5) = 0.5;        % gamma
MatData(1,6) = 0.5;           % beta
MatData(1,7) = 1.75;           % Ao
MatData(1,8) = 0.00008;          % tolerance
MatData(1,9) = 10;          % maxNumIter


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
