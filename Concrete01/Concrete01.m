% =========================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%   ACTS Hardware-in-the-loop Simulation Software   %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%   DO NOT DISTRIBUTE   %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% By Joe Tianyang Qiao, March, 2020 %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% =========================================================================

function [MatData,Result] = Concrete01(action,MatData,edp)
% Concrete01 material
% ONLY for displacement-based simulation!
% varargout = Concrete01(action,MatData,stress)
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
epsc0  = MatData(1,3);      % concrete strain at maximum strength (negative)
fpcu  = MatData(1,4);      % concrete crushing strength (negative)
epscu = MatData(1,5);      % concrete strain at crushing strength (negative)
% trial variables
Tstress = MatData(1,6);
Tstrain = MatData(1,7);
Ttangent = MatData(1,8);
% state history variables
Cstress = MatData(1,9);
Cstrain = MatData(1,10);
Ctangent = MatData(1,11);
% Other variables
TminStrain = MatData(1,12);
CminStrain = MatData(1,13);
TendStrain = MatData(1,14);
CendStrain = MatData(1,15);
TunloadSlope = MatData(1,16);
CunloadSlope = MatData(1,17);
Ec0 = MatData(1,18);

Result = 0;



switch action
    % ======================================================================
    case 'initialize'
        % Force all parameters negative
        if fpc > 0
            fpc = -fpc;
        end
        if epsc0 > 0
            epsc0 = -epsc0;
        end
        if fpcu > 0
            fpcu = -fpcu;
        end
        if epscu > 0
            epscu = -epscu;
        end
        
        % Initial values
        Ec0 = 2*fpc/epsc0;
        Tstrain = 0;
        Tstress = 0;
        Ttangent = Ec0;
        Cstrain = 0;
        Cstress = 0;
        Ctangent = Ec0;
        TminStrain = 0.0;
        CminStrain = 0.0;
        TunloadSlope = Ec0;
        CunloadSlope = Ec0;
        TendStrain = 0.0;
        CendStrain = 0.0;
        
        Result = 0;
        
        
    case 'setTrialStrain'
        % Reset trial history variables to last comitted state
        TminStrain = CminStrain;
        TendStrain = CendStrain;
        TunloadSlope = CunloadSlope;
        Tstress = Cstress;
        Ttangent = Ctangent;
        Tstrain = Cstrain;
        
        % Determine change in strain from last state
        dStrain = edp - Cstrain;
        
        if abs(dStrain) < eps
            Result = 0;
        else
            % Set trial strain
            Tstrain = edp;
            
            % Quick return
            if Tstrain > 0.0
                % Quick output when strain>0
                Tstress = 0;
                Ttangent = 0;
                Result = 0;
            else
                TunloadSlope = CunloadSlope;
                tempStress = Cstress + TunloadSlope*Tstrain - TunloadSlope*Cstrain;
                
                % Material goes into compression
                if edp < Cstrain
                    TminStrain = CminStrain;
                    TendStrain = CendStrain;
                    
                    % -------- Reload ---------
                    if Tstrain <= TminStrain
                        
                        TminStrain = Tstrain;
                        
                        % ----- Envelope ------
                        if Tstrain > epsc0
                            eta = Tstrain/epsc0;
                            Tstress = fpc*(2*eta-eta*eta);
                            Ec0 = 2.0*fpc/epsc0;
                            Ttangent = Ec0*(1.0-eta);
                        elseif Tstrain > epscu
                            Ttangent = (fpc-fpcu)/(epsc0-epscu);
                            Tstress = fpc + Ttangent*(Tstrain-epsc0);
                        else
                            Tstress = fpcu;
                            Ttangent = 0.0;
                        end
                        % -- End of Envelope --
                        
                        % ----- Unload ------
                        tempStrain = TminStrain;
                        
                        if tempStrain < epscu
                            tempStrain = epscu;
                        end
                        eta = tempStrain/epsc0;
                        ratio = 0.707*(eta-2.0) + 0.834;
                        if eta < 2.0
                            ratio = 0.145*eta*eta + 0.13*eta;
                        end
                        TendStrain = ratio*epsc0;
                        temp1 = TminStrain - TendStrain;
                        Ec0 = 2.0*fpc/epsc0;
                        temp2 = Tstress/Ec0;
                        
                        if temp1 > -eps
                            TunloadSlope = Ec0;
                        elseif temp1 <= temp2
                            TendStrain = TminStrain - temp1;
                            TunloadSlope = Tstress/temp1;
                        else
                            TendStrain = TminStrain - temp2;
                            TunloadSlope = Ec0;
                        end
                        % -- End of Unload --
                        
                    elseif Tstrain <= TendStrain
                        Ttangent = TunloadSlope;
                        Tstress = Ttangent*(Tstrain-TendStrain);
                    else
                        Tstress = 0.0;
                        Ttangent = 0.0;
                    end
                    % ----- End of Reload -----
                    
                    if tempStress > Tstress
                        Tstress = tempStress;
                        Ttangent = TunloadSlope;
                    end
                elseif tempStress <= 0.0
                    % Material goes toward tension
                    Tstress = tempStress;
                    Ttangent = TunloadSlope;
                else
                    % Made it into tension
                    Tstress = 0.0;
                    Ttangent = 0.0;
                end
                Result = 0;
            end
        end
        
        
    case 'setTrialStress'
        Tstress = edp;
        Result = 0;
        
        
    case 'getStrain'
        % force-control does not work!
        % stub
        Result = Tstrain;
        
        
    case 'getStress'
        Result = Tstress;
        
        
    case 'getFlexibility'
        Result = 1/(Ttangent+eps);
        
        % ======================================================================
    case 'getStiffness'
        Result = Ttangent;
        
        % ======================================================================
    case 'getInitialStiffness'
        Result = Ec0;
        
        % ======================================================================
    case 'getInitialFlexibility'
        Result = 1/Ec0;
        
        % ======================================================================
    case 'commitState'
        CminStrain = TminStrain;
        CunloadSlope = TunloadSlope;
        CendStrain = TendStrain;
        Cstrain = Tstrain;
        Cstress = Tstress;
        Ctangent = Ttangent;
        Result = 0;
        
        % ======================================================================
end

% Record
MatData(1,1) = tag;
MatData(1,2) = fpc;
MatData(1,3) = epsc0;
MatData(1,4) = fpcu;
MatData(1,5) = epscu;
% trial variables
MatData(1,6) = Tstress;
MatData(1,7) = Tstrain;
MatData(1,8) = Ttangent;
% state history variables
MatData(1,9) = Cstress;
MatData(1,10) = Cstrain;
MatData(1,11) = Ctangent;
MatData(1,12) = TminStrain;
MatData(1,13) = CminStrain;
MatData(1,14) = TendStrain;
MatData(1,15) = CendStrain;
MatData(1,16) = TunloadSlope;
MatData(1,17) = CunloadSlope;
MatData(1,18) = Ec0;
end
