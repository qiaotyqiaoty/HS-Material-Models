% =========================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%   ACTS Hardware-in-the-loop Simulation Software   %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%   ©2017, ACTS Technologies Inc.   %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%   All Rights Reserved   %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%   DO NOT DISTRIBUTE   %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% =========================================================================

function [MatData,Result] = BLHysteretic(action,MatData,edp)
% BILINEARHYSTERETIC bilinear-elastic material
% varargout = BiLinearHysteretic(action,MatData,stress)
%
% action  : switch with following possible values
%              'initialize'         initialize internal variables
%              'setTrialStress'     set the trial stress
%              'getStress'          get the current stress
%              'getStrain'          get the current strain
%              'getTangent'         get the current tangent flexibility
%              'getInitialTangent'  get the initial tangent flexibility
%              'commitState'        commit state of internal variables
% MatData : data structure with material information
% edp     : trial stress or strain

%#codegen
% extract material properties
tag  = MatData(1,1);      % unique material tag
E    = MatData(1,2);      % initial elastic modulus
Fy   = MatData(1,3);      % yield stress
b    = MatData(1,4);      % hardening ratio
% trial variables
stressT = MatData(1,5);
strainT = MatData(1,6);
% state history variables
stressC = MatData(1,7);
strainC = MatData(1,8);

Result = 0;

F0   = (1-b)*Fy;          % stress at zero strain
ey   = Fy/E;              % yield strain

switch action
   % ======================================================================
   case 'initialize'
       stressT = 0;
       strainT = 0;
       stressC = 0;
       strainC = 0;
       Result = 0;
       
   % ======================================================================
   case 'setTrialStrain'
       strainT = edp;
       Result = 0;
       
   % ======================================================================
   case 'setTrialStress'
       stressT = edp;
       Result = 0;
       
   % ======================================================================
   case 'getStress'
       B0   = stressC-E*strainC;  % constant used to define the initial stiffness line which pass throgh the current stress
       Fy1  = (F0-b*B0)/(1-b);    % Upper bound yield stress limit
       Fy2  = Fy1-2*Fy;           % Lower bound yield stress limit
       ey1  = (F0-B0)/E/(1-b);    % Upper bound yield strain limit
       ey2  = ey1-2*ey;           % Lower bound yield strain limit
       
       % calculate the stress
       if strainT > ey1
           stressT = Fy1+(strainT-ey1)*b*E;
       elseif strainT < ey2
           stressT = Fy2+(strainT-ey2)*b*E;
       else
           stressT = strainT*E+B0;
       end
       
       Result = stressT;
       
   % ======================================================================
   case 'getStrain'
       B0   = stressC-E*strainC;  % constant used to define the initial stiffness line which pass throgh the current stress
       Fy1  = (F0-b*B0)/(1-b);    % Upper bound yield stress limit
       Fy2  = Fy1-2*Fy;           % Lower bound yield stress limit
       ey1  = (F0-B0)/E/(1-b);    % Upper bound yield strain limit
       ey2  = ey1-2*ey;           % Lower bound yield strain limit
       
       % calculate the strain
       if stressT > Fy1
           strainT = ey1+(stressT-Fy1)/b/E;
       elseif stressT < Fy2
           strainT = ey2+(stressT-Fy2)/b/E;
       else
           strainT = (stressT-B0)/E;
       end
       
       Result = strainT;
       
   % ======================================================================
   case 'getStiffness'
       B0   = stressC-E*strainC;  % constant used to define the initial stiffness line which pass throgh the current stress
       ey1  = (F0-B0)/E/(1-b);    % Upper bound yield strain limit
       ey2  = ey1-2*ey;           % Lower bound yield strain limit
       
       if (strainT > ey1) || (strainT < ey2)
           stiffness = b*E;
       else
           stiffness = E;
       end
       Result = stiffness;
       
   % ======================================================================
   case 'getInitialStiffness'
       stiffness = E;
       Result = stiffness;
       
   % ======================================================================
   case 'getFlexibility'
       B0   = stressC-E*strainC;  % constant used to define the initial stiffness line which pass throgh the current stress
       Fy1  = (F0-b*B0)/(1-b);    % Upper bound yield stress limit
       Fy2  = Fy1-2*Fy;           % Lower bound yield stress limit
       
       if (stressT > Fy1) || (stressT < Fy2)
           flexibility = 1/(b*E);
       else
           flexibility = 1/E;
       end
       Result = flexibility;
       
   % ======================================================================
   case 'getInitialFlexibility'
       flexibility = 1/E;
       Result = flexibility;
       
   % ======================================================================
   case 'commitState'
       stressC = stressT;
       strainC = strainT;
       Result = 0;
       
   % ======================================================================
end

% Record
MatData(1,1) = tag;  % unique material tag
MatData(1,2) = E;    % initial elastic modulus
MatData(1,3) = Fy;   % yield stress
MatData(1,4) = b;    % hardening ratio
% trial variables
MatData(1,5) = stressT;
MatData(1,6) = strainT;
% state history variables
MatData(1,7) = stressC;
MatData(1,8) = strainC;
end
