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

% state variables
MatData(1,9) = 0.0;
MatData(1,10) = 0.0;
MatData(1,11) = 0.0;
MatData(1,12) = 0.0;
MatData(1,13) = 0.0;
MatData(1,14) = 0.0;
MatData(1,15) = 0.0;
MatData(1,16) = 0.0;
MatData(1,17) = 0.0;
MatData(1,18) = 0.0;
MatData(1,19) = 0.0;
MatData(1,20) = 0.0;
MatData(1,21) = 0.0;
MatData(1,22) = 0.0;
MatData(1,23) = 0.0;
MatData(1,24) = 0.0;
MatData(1,25) = 0.0;
MatData(1,26) = 0.0;
MatData(1,27) = 0.0;
MatData(1,28) = 0.0;
MatData(1,29) = 0.0;
MatData(1,30) = 0.0;
MatData(1,31) = 0.0;
MatData(1,32) = 0.0;
MatData(1,33) = 0.0;
MatData(1,34) = 0.0;
MatData(1,35) = 0.0;
MatData(1,36) = 0.0;
MatData(1,37) = 0.0;
MatData(1,38) = 0.0;
MatData(1,39) = 0.0;

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
