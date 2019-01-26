function varargout = BLHysteric(action,MatData,edp)
%BILINEARHYSTERIC bilinear-elastic material for displacement method
% varargout = BiLinearHysteric(action,MatData,stress)
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
% edp  : trial stress or strain 
%
% Written by T.Y. Yang on 2016/04/08

% state variables
persistent stressT;
persistent strainT;
persistent stressC;
persistent strainC;

% extract material properties
tag  = MatData.tag;        % unique material tag
E    = MatData.E;          % initial elastic modulus
Fy   = MatData.Fy;         % yield stress
b    = MatData.b;          % hardening ratio
F0   = (1-b)*Fy;           % stress at zero strain
ey   = Fy/E;               % yield strain

if ~isfield(MatData,'dqLimit')
    dqLimit = inf;
else
    dqLimit = MatData.dqLimit;
end

if ~isfield(MatData,'dvLimit')
    dvLimit = inf;
else
    dvLimit = MatData.dvLimit;
end

switch action
   % ======================================================================
   case 'initialize'
      stressT(tag) = 0;
      strainT(tag) = 0;
      stressC(tag) = 0;
      strainC(tag) = 0;      
      varargout = {0.0};
   % ======================================================================
   case 'setTrialStrain'
      strainT(tag) = edp; 
      varargout = {0};
   % ======================================================================
   case 'setTrialStress'
      stressT(tag) = edp;  
      varargout = {0};
   % ======================================================================
   case 'getStress'
       B0   = stressC(tag)-E*strainC(tag);  % constant used to define the initial stiffness line which pass throgh the current stress
       Fy1  = (F0-b*B0)/(1-b); % Upper bound yield stress limit
       Fy2  = Fy1-2*Fy;            % Lower bound yield stress limit
       ey1  = (F0-B0)/E/(1-b); % Upper bound yield strain limit
       ey2  = ey1-2*ey;           % Lower bound yield strain limit

       % calculate the stress
       if strainT(tag) > ey1
           stressT(tag) = Fy1+(strainT(tag)-ey1)*b*E;
       elseif strainT(tag) < ey2
           stressT(tag) = Fy2+(strainT(tag)-ey2)*b*E;
       else
           stressT(tag) = strainT(tag)*E+B0;
       end
       
       % simulate if the stress exceeds the stress limit ==> Failure happened 
       if abs(stressC(tag) - stressT(tag)) > dqLimit
           errordlg('material stress limit exceeded')
           return
       end
       
       varargout = {stressT(tag)};
   % ======================================================================
   case 'getStrain'
       B0   = stressC(tag)-E*strainC(tag);  % constant used to define the initial stiffness line which pass throgh the current stress
       Fy1  = (F0-b*B0)/(1-b); % Upper bound yield stress limit
       Fy2  = Fy1-2*Fy;            % Lower bound yield stress limit
       ey1  = (F0-B0)/E/(1-b); % Upper bound yield strain limit
       ey2  = ey1-2*ey;           % Lower bound yield strain limit
       
       % calculate the strain
       if stressT(tag) > Fy1
           strainT(tag) = ey1+(stressT(tag)-Fy1)/b/E;
       elseif stressT(tag) < Fy2
           strainT(tag) = ey2+(stressT(tag)-Fy2)/b/E;
       else
           strainT(tag) = (stressT(tag)-B0)/E;
       end
       
       % simulate if the strain exceeds the strain limit ==> Failure happened  
       if abs(strainC(tag) - strainT(tag)) > dvLimit
           errordlg('material strain limit exceeded')
           return
       end

       varargout = {strainT(tag)};
   % ======================================================================
   case 'getStiffness'
       B0   = stressC(tag)-E*strainC(tag);  % constant used to define the initial stiffness line which pass throgh the current stress
       ey1  = (F0-B0)/E/(1-b); % Upper bound yield strain limit
       ey2  = ey1-2*ey;           % Lower bound yield strain limit
       
       if (strainT(tag) > ey1) || (strainT(tag) < ey2)
          stiffness = b*E;
       else
           stiffness = E;
       end
       varargout = {stiffness};      
    % ======================================================================
    case 'getInitialStiffness'
        varargout = {E};  
    % ======================================================================
    case 'getFlexibility'        
        B0   = stressC(tag)-E*strainC(tag);  % constant used to define the initial stiffness line which pass throgh the current stress
        Fy1  = (F0-b*B0)/(1-b); % Upper bound yield stress limit
        Fy2  = Fy1-2*Fy;            % Lower bound yield stress limit
        
        if (stressT(tag) > Fy1) || (stressT(tag) < Fy2)
            flexibility = 1/(b*E);
        else
            flexibility = 1/E;
        end        
        varargout = {flexibility};      
    % ======================================================================
    case 'getInitialFlexibility'
        varargout = {1/E};
   % ======================================================================
   case 'commitState'
      stressC(tag) = stressT(tag);
      strainC(tag) = strainT(tag);
      varargout = {0};      
   % ======================================================================
end
