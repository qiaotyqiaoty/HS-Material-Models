% =========================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%   ACTS Hardware-in-the-loop Simulation Software   %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%   ?017, ACTS Technologies Inc.   %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%   All Rights Reserved   %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%   DO NOT DISTRIBUTE   %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% =========================================================================

function [MatData,Result] = SelfCentering(action,MatData,edp)
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
k1 = MatData(1,2);
k2 = MatData(1,3);
ActF = MatData(1,4);
beta = MatData(1,5);
SlipDef = MatData(1,6);
BearDef = MatData(1,7);
rBear = MatData(1,8);

% commit state variables
Cstrain = MatData(1,9);
Cstress = MatData(1,10);
Ctangent = MatData(1,11);
CactivStrainPos = MatData(1,12);
CactivStrainNeg = MatData(1,13);
CslipStrain = MatData(1,14);
CupperStrainPos = MatData(1,15);
ClowerStrainPos = MatData(1,16);
CupperStressPos = MatData(1,17);
ClowerStressPos = MatData(1,18);
CupperStrainNeg = MatData(1,19);
ClowerStrainNeg = MatData(1,20);
CupperStressNeg = MatData(1,21);
ClowerStressNeg = MatData(1,22);
SlipF = MatData(1,23);
ActDef = MatData(1,24);
BearF = MatData(1,25);
Tstrain = MatData(1,26);
Tstress = MatData(1,27);
Ttangent = MatData(1,28);
TactivStrainPos = MatData(1,29);
TactivStrainNeg = MatData(1,30);
TslipStrain = MatData(1,31);
TupperStrainPos = MatData(1,32);
TlowerStrainPos = MatData(1,33);
TupperStressPos = MatData(1,34);
TlowerStressPos = MatData(1,35);
TupperStrainNeg = MatData(1,36);
TlowerStrainNeg = MatData(1,37);
TupperStressNeg = MatData(1,38);
TlowerStressNeg = MatData(1,39);

Result = 0;

switch action
    % =====================================================================
    case 'initialize'
        ActDef = ActF / k1;
        SlipF = ActF + (SlipDef - ActDef) * k2;
        if BearDef ~= 0
            if SlipDef ~= 0 && SlipDef < BearDef
                BearF = SlipF;
            end
        else
            BearF = ActF + (BearDef - ActDef) * k2;
        end
        % Initialize commit state variables
        Cstrain = 0.0;
        CactivStrainPos = 0.0;
        CactivStrainNeg = 0.0;
        CslipStrain = 0.0;
        CupperStrainPos = ActDef;
        ClowerStrainPos = (1-beta) * ActDef;
        CupperStressPos = ActF;
        ClowerStressPos = (1-beta) * ActF;
        CupperStrainNeg = -CupperStrainPos;
        ClowerStrainNeg = -ClowerStrainPos;
        CupperStressNeg = -CupperStressPos;
        ClowerStressNeg = -ClowerStressPos;
        % Initialize trial variables
        TactivStrainPos = 0.0;
        TactivStrainNeg = 0.0;
        TslipStrain = 0.0;
        TupperStrainPos = ActDef;
        TlowerStrainPos = (1-beta) * ActDef;
        TupperStressPos = ActF;
        TlowerStressPos = (1-beta) * ActF;
        TupperStrainNeg = -CupperStrainPos;
        TlowerStrainNeg = -ClowerStrainPos;
        TupperStressNeg = -CupperStressPos;
        TlowerStressNeg = -ClowerStressPos;
        Tstrain = 0.0;
        Tstress = 0.0;
        Ttangent = k1;
        
        Result = 0;
        
        % =================================================================
    case 'setTrialStrain'
        diffStrain = edp - Cstrain;
        
        if abs(diffStrain) < 1e-32
            Result = 0;
        end
        
        Tstrain = edp;
        noSlipStrain = Tstrain - CslipStrain;
        
        % Middle elastic portion
        % Entirely elastic response
        if abs(noSlipStrain) <= ((1-beta)*ActF/k1)
            Tstress = k1 * noSlipStrain;
            Ttangent = k1;
        else
            % Positive quadrant (strain>=0)
            if noSlipStrain >= 0
                if BearDef ~= 0 && Tstrain > BearDef
                    Tstress = BearF + (Tstrain - BearDef) * rBear * k1;
                    Ttangent = rBear * k1;
                elseif SlipDef ~= 0 && noSlipStrain > SlipDef
                    Tstress = SlipF;
                    TslipStrain = CslipStrain + diffStrain;
                    % med linear
                elseif noSlipStrain >= ClowerStrainPos && ...
                        noSlipStrain <= CupperStrainPos
                    Tstress = (noSlipStrain - CactivStrainPos) * k1;
                    Ttangent = k1;
                    % upper activation
                elseif noSlipStrain > CupperStrainPos
                    TupperStressPos = CupperStressPos + ...
                        (noSlipStrain - CupperStrainPos) * k2;
                    TupperStrainPos = noSlipStrain;
                    TlowerStrainPos = noSlipStrain - beta * ActF / k1;
                    TlowerStressPos = TupperStressPos - beta * ActF;
                    Tstress = TupperStressPos;
                    TactivStrainPos = TupperStrainPos - Tstress / k1;
                    Ttangent = k2;
                    % lower activation
                else        % Tstrain < ClowerStrainPos
                    TlowerStressPos = ClowerStressPos + ...
                        (noSlipStrain - ClowerStrainPos) * k2;
                    TlowerStrainPos = noSlipStrain;
                    TupperStrainPos = noSlipStrain + beta * ActF / k1;
                    TupperStressPos = TlowerStressPos + beta * ActF;
                    Tstress = TlowerStressPos;
                    TactivStrainPos = TlowerStrainPos - Tstress / k1;
                    Ttangent = k2;
                end
                
                % Negative quadrant (strain<0)
            else            % Tstrain < 0
                if BearDef ~= 0 && Tstrain < -BearDef
                    Tstress = -BearF + (Tstrain + BearDef) * rBear * k1;
                    Ttangent = rBear * k1;
                elseif SlipDef ~= 0 && noSlipStrain < -SlipDef
                    Tstress = -SlipF;
                    TslipStrain = CslipStrain + diffStrain;
                elseif (noSlipStrain <= ClowerStrainNeg) && ...
                        (noSlipStrain >= CupperStrainNeg)
                    Tstress = (noSlipStrain - CactivStrainNeg)*k1;
                    Ttangent = k1;
                elseif noSlipStrain < CupperStrainNeg
                    TupperStressNeg = CupperStressNeg + ...
                        (noSlipStrain - CupperStrainNeg) * k2;
                    TupperStrainNeg = noSlipStrain;
                    TlowerStrainNeg = noSlipStrain + beta * ActF / k1;
                    TlowerStressNeg = TupperStressNeg + beta * ActF;
                    Tstress = TupperStressNeg;
                    TactivStrainNeg = TupperStrainNeg - Tstress / k1;
                    Ttangent = k2;
                else
                    TlowerStressNeg = ClowerStressNeg + ...
                        (noSlipStrain - ClowerStrainNeg) * k2;
                    TlowerStrainNeg = noSlipStrain;
                    TupperStrainNeg = noSlipStrain - beta * ActF / k1;
                    TupperStressNeg = TlowerStressNeg - beta * ActF;
                    Tstress = TlowerStressNeg;
                    TactivStrainNeg = TlowerStrainNeg - Tstress / k1;
                    Ttangent = k2;
                end
            end
        end
        Result = 0;
        
        
        % =================================================================
    case 'setTrialStress'
        Tstress = edp;
        Result = 0;
        
        % =================================================================
    case 'getStrain'
        Result = Tstrain;
        
        % =================================================================
    case 'getStress'
        Result = Tstress;
        
    case 'getFlexibility'
        Result = 1/Ttangent;
        
    case 'getStiffness'
        Result = Ttangent;
        
        % =================================================================
    case 'getInitialStiffness'
        Result = k1;
        
        % =================================================================
    case 'getInitialFlexibility'
        Result = 1/k1;
        
        % =================================================================
    case 'commitState'
        Cstrain = Tstrain;
        Cstress = Tstress;
        Ctangent = Ttangent;
        CactivStrainPos = TactivStrainPos;
        CactivStrainNeg = TactivStrainNeg;
        CslipStrain = TslipStrain;
        CupperStrainPos = TupperStrainPos;
        ClowerStrainPos = TlowerStrainPos;
        CupperStressPos = TupperStressPos;
        ClowerStressPos = TlowerStressPos;
        CupperStrainNeg = TupperStrainNeg;
        ClowerStrainNeg = TlowerStrainNeg;
        CupperStressNeg = TupperStressNeg;
        ClowerStressNeg = TlowerStressNeg;
        Result = 0;
        
        % =================================================================
end

% Record
MatData(1,1) = tag;      % unique material tag
MatData(1,2) = k1;
MatData(1,3) = k2;
MatData(1,4) = ActF;
MatData(1,5) = beta;
MatData(1,6) = SlipDef;
MatData(1,7) = BearDef;
MatData(1,8) = rBear;
MatData(1,9) = Cstrain;
MatData(1,10) = Cstress;
MatData(1,11) = Ctangent;
MatData(1,12) = CactivStrainPos;
MatData(1,13) = CactivStrainNeg;
MatData(1,14) = CslipStrain;
MatData(1,15) = CupperStrainPos;
MatData(1,16) = ClowerStrainPos;
MatData(1,17) = CupperStressPos;
MatData(1,18) = ClowerStressPos;
MatData(1,19) = CupperStrainNeg;
MatData(1,20) = ClowerStrainNeg;
MatData(1,21) = CupperStressNeg;
MatData(1,22) = ClowerStressNeg;
MatData(1,23) = SlipF;
MatData(1,24) = ActDef;
MatData(1,25) = BearF;
MatData(1,26) = Tstrain;
MatData(1,27) = Tstress;
MatData(1,28) = Ttangent;
MatData(1,29) = TactivStrainPos;
MatData(1,30) = TactivStrainNeg;
MatData(1,31) = TslipStrain;
MatData(1,32) = TupperStrainPos;
MatData(1,33) = TlowerStrainPos;
MatData(1,34) = TupperStressPos;
MatData(1,35) = TlowerStressPos;
MatData(1,36) = TupperStrainNeg;
MatData(1,37) = TlowerStrainNeg;
MatData(1,38) = TupperStressNeg;
MatData(1,39) = TlowerStressNeg;
end
