% =========================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%   ACTS Hardware-in-the-loop Simulation Software   %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%   DO NOT DISTRIBUTE   %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% By Joe Tianyang Qiao, March, 2020 %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% =========================================================================

function [MatData,Result] = Elastic02(action,MatData,edp)
% ELASTIC02 Elastic 02 material
% This material offers different modulus values for positive and negative
% directions
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
Epos = MatData(1,2);      % Epos: initial elastic modulus (tensile)
Eneg = MatData(1,3);      % Eneg: initial elastic modulus (compressive)
% state variables
stressT = MatData(1,4);     % trial stress
strainT = MatData(1,5);     % trial strain
strainC = MatData(1,6);     % committed strain (optional)
Result = 0;

switch action
   % ======================================================================
   case 'initialize'
       strainT = 0;
       stressT = 0;
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
       if strainT > 0.0
           Result = stressT/Epos;
       else
           Result = stressT/Eneg;
       end
      
   % ======================================================================
   case 'getStress'
       if strainT > 0.0
           Result = Epos*strainT;
       else
           Result = Eneg*strainT;
       end
      
   case 'getFlexibility'
       if strainC > 0.0
           Result = 1/Epos;
       else
           Result = 1/Eneg;
       end
   
   % ======================================================================
   case 'getStiffness'
       if strainT > 0.0
           Result = Epos;
       elseif strainT <0.0
           Result = Eneg;
       else
           Result = min(Epos,Eneg);
       end
      
   % ======================================================================
   case 'getInitialStiffness'
       Result = max(Epos,Eneg);
      
   % ======================================================================
   case 'getInitialFlexibility'
       Result = 1/max(Epos,Eneg);
        
   % ======================================================================
   case 'commitState'
       strainC = strainT;
       Result = 0;
      
   % ======================================================================
end

% Record
MatData(1,1) = tag;      % unique material tag
MatData(1,2) = Epos;        % initial elastic modulus (positive)
MatData(1,3) = Eneg;        % initial elastic modulus (negative)
MatData(1,4) = stressT;  % trial stress
MatData(1,5) = strainT;  % trial strain
MatData(1,6) = strainC;  % committed strain
end
