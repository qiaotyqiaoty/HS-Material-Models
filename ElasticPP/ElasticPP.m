% =========================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%   ACTS Hardware-in-the-loop Simulation Software   %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%   DO NOT DISTRIBUTE   %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% By Joe Tianyang Qiao, March, 2020 %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% =========================================================================

function [MatData,Result] = ElasticPP(action,MatData,edp)
% ElasticPP (Elastic-Perfectly-Plastic) material
% varargout = ElasticPP(action,MatData,stress)
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


% extract material properties
tag = MatData(1,1);      % unique material tag
E = MatData(1,2);        % Elastic modulus
eyp = MatData(1,3);      % Positive yield strain
eyn = MatData(1,4);      % Negative yield strain
ezero = MatData(1,5);    % Initial strain (pre-stressing)

% state variables
ep = MatData(1,6);
fyp = MatData(1,7);
fyn = MatData(1,8);
stressT = MatData(1,9);
strainT = MatData(1,10);
tangentT = MatData(1,11);
stressC = MatData(1,12);
strainC = MatData(1,13);
tangentC = MatData(1,14);

Result = 0;

switch action
    % ======================================================================
    case 'initialize'
        strainT = 0;
        stressT = 0;
        strainC = 0;
        stressC = 0;
        tangentT = E;
        tangentC = E;
        if eyp<0
            eyp = -1*eyp;
        end
        if eyn>0
            eyn = -1*eyn;
        end
        fyp = E*eyp;
        fyn = E*eyn;
        ep = 0.0;
        Result = 0;
        
        % ======================================================================
    case 'setTrialStrain'
        strainT = edp;
        
        % Compute temp trial stress (only using modulus)
        sigT = E * (strainT - ezero - ep);
        % Yield function
        if sigT >= 0.0
            f = sigT - fyp;
        else
            f = -sigT + fyn;
        end
        % Yield?
        fYieldSurface = - E * eps;
        if f <= fYieldSurface
            % Not yielded
            stressT = sigT;
            tangentT = E;
        else
            % Yielded
            if sigT > 0.0
                stressT = fyp+1e-10*E;
            else
                stressT = fyn-1e-10*E;
            end
            tangentT = 1e-10*E;
        end
        
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
        Result = stressT;
        
    case 'getFlexibility' %x
        if abs(tangentT) < 1e-10*E
            Result = 1e-10*E;
        else
            Result = 1/tangentT;
        end
        
    case 'getStiffness'
        Result = tangentT;
        
        % ======================================================================
    case 'getInitialStiffness'
        Result = E;
        
        % ======================================================================
    case 'getInitialFlexibility'
        Result = 1/E;
        
        % ======================================================================
    case 'commitState'
        sigT = E * ( strainT - ezero - ep );
        
        if sigT >= 0.0
            f =  sigT - fyp;
        else
            f = -sigT + fyn;
        end
        
        fYieldSurface = - E * eps;
        if f > fYieldSurface
            if sigT > 0.0
                ep = ep + f / E;
            else
                ep = ep - f / E;
            end
        end
        
        strainC = strainT;
        stressC = stressT;
        tangentC = tangentT;
        Result = 0;
        
end

% ======================================================================

% Record
MatData(1,1) = tag;      % unique material tag
MatData(1,2) = E;
MatData(1,3) = eyp;
MatData(1,4) = eyn;
MatData(1,5) = ezero;
MatData(1,6) = ep;
MatData(1,7) = fyp;
MatData(1,8) = fyn;
MatData(1,9) = stressT;
MatData(1,10) = strainT;
MatData(1,11) = tangentT;
MatData(1,12) = stressC;
MatData(1,13) = strainC;
MatData(1,14) = tangentC;
end
