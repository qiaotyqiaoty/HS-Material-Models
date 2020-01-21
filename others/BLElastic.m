% =========================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%   ACTS Hardware-in-the-loop Simulation Software   %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%   ©2017, ACTS Technologies Inc.   %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%   All Rights Reserved   %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%   DO NOT DISTRIBUTE   %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% =========================================================================

function [MatData,Result]  = BLElastic(action,MatData,edp)
% BLElastic bilinear-elastic material
% varargout = BiLinearElastic(action,MatData,edp)
%
% action  : switch with following possible values
%              'initialize'         initialize internal variables
%              'setTrialStrain'     set the trial strain
%              'getStrain'          get the current strain
%              'getStress'          get the current stress
%              'getTangent'         get the current tangent modulus
%              'getInitialTangent'  get the initial tangent modulus
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

switch action
    % ======================================================================
    case 'initialize'
        strainT = 0;
        stressT = 0;
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
    case 'getStrain'
        if abs(stressT) > Fy
            strainT = sign(stressT)*(Fy/E+(abs(stressT)-Fy)/(E*b));
        else
            strainT = stressT/E;
        end        
        Result = strainT;
      
    % ======================================================================
    case 'getStress'
        if abs(strainT) > Fy/E
            stressT = sign(strainT)*(Fy+(abs(strainT)-Fy/E)*(E*b));
        else
            stressT = strainT*E;
        end
        Result = stressT;
        
    % ======================================================================
    case 'getFlexibility'
        if abs(strainT) > Fy/E
            flexibility = 1/(b*E);
        else
            flexibility = 1/E;
        end        
        Result = flexibility;
    
    % ======================================================================
    case 'getStiffness'
        if abs(strainT) > Fy/E
            stiffness = b*E;
        else
            stiffness = E;
        end        
        Result = stiffness;
        
    % ======================================================================
    case 'getInitialStiffness'
        Result = E;
    
    % ======================================================================
    case 'getInitialFlexibility'
        Result = 1/E;
        
    % ======================================================================
    case 'commitState'
        stressC = stressT;
        strainC = strainT;
        Result = 0;
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
