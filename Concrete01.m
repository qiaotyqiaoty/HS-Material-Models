% =========================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%   ACTS Hardware-in-the-loop Simulation Software   %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%   ?017, ACTS Technologies Inc.   %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%   All Rights Reserved   %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%   DO NOT DISTRIBUTE   %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% =========================================================================

function [MatData,Result] = Concrete01(action,MatData,edp)
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
tag   = MatData(1,1);      % unique material tag
fpc   = MatData(1,2);      % concrete maximum compressive strength (negative)
epsc  = MatData(1,3);      % concrete strain at maximum strength (negative)
fpcu  = MatData(1,4);      % concrete crushing strength (negative)
epscu = MatData(1,5);      % concrete strain at crushing strength (negative)
% trial variables
stressT = MatData(1,6);
strainT = MatData(1,7);
tangentT = MatData(1,8);
% state history variables
stressC = MatData(1,9);
strainC = MatData(1,10);
strainCmin = MatData(1,11);
strainCunload = MatData(1,12);
strainCend = MatData(1,13);
unloadSlopeC = MatData(1,14);
tangentC = MatData(1,15);

% Force all parameters negative
if fpc > 0
    fpc = -fpc;
end
if epsc > 0
    epsc = -epsc;
end
if fpcu > 0
    fpcu = -fpcu;
end
if epscu > 0
    epscu = -epscu;
end

% Initial values
Ec0 = 2*fpc/epsc;

switch action
   % ======================================================================
   case 'initialize'
       strainT = 0;
       stressT = 0;
       strainC = 0;
       stressC = 0;
       strainCmin = 0;
       strainCunload = 0;
       strainCend = 0;
       tangentC = Ec0;
       unloadSlopeC = Ec0;
       tangentT = Ec0;
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
       if stressT >= 0
           Result = strainT;
       else
           Result = strainT;  % stub
       end
      
   % ======================================================================
   case 'getStress'
       % Determine change in strain from last state
       dStrain = strainT - strainC;
       % Reset trail history variables to last committed state
       strainTmin = strainCmin;
       strainTend = strainCend;
       unloadSlopeT = unloadSlopeC;
       stressTemp = stressC + unloadSlopeT*dStrain;
       if strainT > 0
           % Quick output when strain>0
            Result = 0;
       else
            % Material goes into compression
            if strainT <= strainC
                % -----Reload -----
                if strainT <= strainTmin
                    strainTmin = strainT;
                    % ----- Envelope -----
                    if strainT > epsc
                        eta = strainT/epsc;
                        stressT = fpc*(2*eta-eta*eta);
                        tangentT = Ec0*(1-eta);
                    elseif strainT > epscu
                        tangentT = (fpc-fpcu)/(epsc-epscu);
                        stressT = fpc+tangentT*(strainT-epsc);
                    else
                        tangentT = 0;
                        stressT = fpcu;
                    end
                    % ----- End of Envelope -----
                    % ----- Unload -----
                    strainTemp = strainTmin;
                    if strainTemp < epscu
                        strainTemp = epscu;
                    end
                    eta = strainTemp/epsc;
                    ratio = 0.707*(eta-2)+0.834;
                    if eta < 2
                        ratio = 0.145*eta*eta+0.13*eta;
                    end
                    strainTend = ratio*epsc;
                    temp1 = strainTmin - strainTend;
                    temp2 = stressT/Ec0;
                    if temp1 > 0
                        unloadSlopeT = Ec0;
                    elseif temp1 <= temp2
                        strainTend = strainTmin - temp1;
                        unloadSlopeT = stressT/temp1;
                    else
                        strainTend = strainTmin - temp2;
                        unloadSlopeT = Ec0;
                    end
                    % ----- End of Unload -----
                elseif strainT <= strainTend
                    tangentT = unloadSlopeT;
                    stressT = tangentT*(strainT-strainTend);
                else
                    tangentT = 0;
                    stressT = 0;
                end
                % ----- End of Reload -----
                
                if stressTemp > stressT
                    stressT = stressTemp;
                    tangentT = unloadSlopeT;
                end
                
            elseif stressTemp <= 0
                stressT = stressTemp;
                tangentT = unloadSlopeT;
            else
                stressT = 0;
                tangentT = 0;                
            end
            Result = stressT;
       end
       % History variables output
       strainCmin = strainTmin;
       unloadSlopeC = unloadSlopeT;
       strainCend = strainTend;
      
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
           Result = 1e10*1/E;  % Take 10^10*(1/E) as infinity
       end
      
   % ======================================================================
   case 'getInitialStiffness'
       Result = Ec0;
      
   % ======================================================================
   case 'getInitialFlexibility'
       Result = 1/Ec0;
        
   % ======================================================================
   case 'commitState'
       % State variables
       strainC = strainT;
       stressC = stressT;
       tangentC = tangentT;
       Result = 0;
      
   % ======================================================================
end

% Record
MatData(1,1) = tag;      % unique material tag
MatData(1,2) = fpc;
MatData(1,3) = epsc;
MatData(1,4) = fpcu;
MatData(1,5) = epscu;
% trial variables
MatData(1,6) = stressT;
MatData(1,7) = strainT;
MatData(1,8) = tangentT;
% state history variables
MatData(1,9) = stressC;
MatData(1,10) = strainC;
MatData(1,11) = strainCmin;
MatData(1,12) = strainCunload;
MatData(1,13) = strainCend;
MatData(1,14) = unloadSlopeC;
MatData(1,15) = tangentC;
end
