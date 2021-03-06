% =========================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% Material Testing Template V2 %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% =========================================================================

%% Testing template for ElasticNoTension material

% clean start
clear all; close all; clc;

% forcing function
Time = 0:0.005:16;
V = 0.1*sin(Time);

% Material property
Element = 'SelfCentering';
MatData = zeros(1,50);

% User input material properties
MatData(1,1) = 1;      % unique material tag
MatData(1,2) = 2000;      % k1
MatData(1,3) = 400;      % k2
MatData(1,4) = 60;    % ActF
MatData(1,5) = 0.6;    % beta
MatData(1,6) = 0;   % SlipDef
MatData(1,7) = 0;   % BearDef
MatData(1,8) = 0;   % rBear


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
plot(V,P,'-k','LineWidth',2.5)
xlabel('Displacement')
ylabel('Force')
grid
