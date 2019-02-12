% =========================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%   ACTS Hardware-in-the-loop Simulation Software   %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%   ?017, ACTS Technologies Inc.   %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%   All Rights Reserved   %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%   DO NOT DISTRIBUTE   %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% =========================================================================

function [MatData,Result] = ElasticNoTension(action,MatData,edp)
% ELASTICNOTENSION elastic-no-tension material
% varargout = ElasticNoTension(action,MatData,stress)
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
tag = MatData(1,1);      % unique material tag
E   = MatData(1,2);      % initial elastic modulus (compression)
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
       Result = strainT;
      
   % ======================================================================
   case 'getStress'
       if strainT < 0
           Result = E*strainT;
       else
           Result = 0;
       end
      
   % ======================================================================
   case 'getFlexibility'
       if strainT < 0
           Result = 1/E;
       else
           Result = 1e10*1/E;  % Take 10^10*(1/E) as infinity
       end
      
   % ======================================================================
   case 'getStiffness'
       if strainT < 0
           Result = E;
       else
           Result = 0;
       end
      
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
