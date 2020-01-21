% =========================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%   ACTS Hardware-in-the-loop Simulation Software   %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%   ©2017, ACTS Technologies Inc.   %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%   All Rights Reserved   %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%   DO NOT DISTRIBUTE   %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% =========================================================================

function [MatData,Result] = Elastic(action,MatData,edp)
% ELASTIC linear-elastic material
% varargout = Elastic(action,MatData,strain)
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
% strain  : trial strain

%#codegen
% extract material properties
tag = MatData(1,1);      % unique material tag
E   = MatData(1,2);      % initial elastic modulus
% state variables
stressT = MatData(1,3);  
strainT = MatData(1,4);  
Result = 0;


switch action
   % ======================================================================
   case 'initialize'
       strainT = 0;
       stressT = 0;
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
       Result = stressT/E;
      
   % ======================================================================
   case 'getStress'      
       Result = strainT*E;
      
   % ======================================================================
   case 'getFlexibility'
       Result = 1/E;
      
   % ======================================================================
   case 'getStiffness'
       Result = E;
      
   % ======================================================================
   case 'getInitialStiffness'
       Result = E;
      
   % ======================================================================
   case 'getInitialFlexibility'
       Result = 1/E;
        
   % ======================================================================
   case 'commitState'
       Result = 0;
      
   % ======================================================================
end

% Record
MatData(1,1) = tag;      % unique material tag
MatData(1,2) = E;        % initial elastic modulus
MatData(1,3) = stressT;  % yield stress
MatData(1,4) = strainT;  % yield strain
end
