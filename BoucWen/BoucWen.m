% =========================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%   ACTS Hardware-in-the-loop Simulation Software   %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%   DO NOT DISTRIBUTE   %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% By Joe Tianyang Qiao, March, 2020 %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% =========================================================================

function [MatData,Result] = BoucWen(action,MatData,edp)
% Bouc-Wen Hysteretic material
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
alpha = MatData(1,2);        % amplification factor
ko = MatData(1,3);           % elastic modulus
n = MatData(1,4);            % shape factor (>=1, the larger the smoother)
gamma = MatData(1,5);
beta = MatData(1,6);
Ao = MatData(1,7);
tolerance = MatData(1,8);
maxNumIter = MatData(1,9);

% not active!
deltaA = MatData(1,10);
deltaNu = MatData(1,11);
deltaEta = MatData(1,12);


% state variables
Tstrain = MatData(1,13);
Cstrain = MatData(1,14);
Tz = MatData(1,15);
Cz = MatData(1,16);
Te = MatData(1,17);
Ce = MatData(1,18);
Tstress = MatData(1,19);
Ttangent = MatData(1,20);

Result = 0;

switch action
    % ======================================================================
    case 'initialize'
        deltaA = 0.0;
        deltaNu = 0.0;
        deltaEta = 0.0;
        Tstrain = 0.0;
        Cstrain = 0.0;
        Tz = 0.0;
        Cz = 0.0;
        Te = 0.0;
        Ce = 0.0;
        Tstress = 0.0;
        Ttangent = alpha*ko + (1-alpha)*ko*Ao;
        Result = 0;
        
        % ======================================================================
    case 'setTrialStrain'
        % Set trial strain and compute strain increment
        Tstrain = edp;
        dStrain = Tstrain - Cstrain;
        
        % Newton-Raphson scheme to solve for z_{i+1end := z1
        count = 0;
        startPoint = 0.01;
        Tz = startPoint;
        Tzold = startPoint;
        Tznew = 1.0;
        while ((abs(Tzold-Tznew) > tolerance ) && count<maxNumIter)
            
            Te = Ce + (1-alpha)*ko*dStrain*Tz;
            TA = Ao - deltaA*Te;
            Tnu = 1.0 + deltaNu*Te;
            Teta = 1.0 + deltaEta*Te;
            
            % --- signum(value) ---
            if dStrain*Tz > 0
                sign = 1.0;
            else
                sign = -1.0;
            end
            % --- end of signum ---
            
            Psi = gamma + beta*sign;
            Phi = TA - (abs(Tz)^n)*Psi*Tnu;
            f = Tz - Cz - Phi/Teta*dStrain;
            
            
            % Evaluate function derivative f' (underscore:=prime)
            Te_ = (1.0-alpha)*ko*dStrain;
            TA_ = -deltaA*Te_;
            Tnu_ = deltaNu*Te_;
            Teta_ = deltaEta*Te_;
            % --- signum(value) ---
            if Tz > 0
                sign = 1.0;
            else
                sign = -1.0;
            end
            % --- end of signum ---
            if Tz == 0.0
                power1 = 0.0;
                power2 = 0.0;
            else
                power1 = abs(Tz)^(n-1);
                power2 = abs(Tz)^n;
            end
            Phi_ = TA_ - n*power1*sign*Psi*Tnu - power2*Psi*Tnu_;
            f_ = 1.0 - (Phi_*Teta-Phi*Teta_)/(Teta^2)*dStrain;
            
            % Take a Newton step
            Tznew = Tz - f/f_;
            
            
            % Update the root (but the keep the old for convergence check)
            Tzold = Tz;
            Tz = Tznew;
            
            % Update counter
            count = count + 1;
            
            % Compute stress
            Tstress = alpha*ko*Tstrain + (1-alpha)*ko*Tz;
            
            
            % Compute deterioration parameters
            Te = Ce + (1-alpha)*ko*dStrain*Tz;
            TA = Ao - deltaA*Te;
            Tnu = 1.0 + deltaNu*Te;
            Teta = 1.0 + deltaEta*Te;
            
            
            % Compute tangent
            if (Tz ~= 0.0)
                % --- signum(value) ---
                if dStrain*Tz > 0
                    sign = 1.0;
                else
                    sign = -1.0;
                end
                % --- end of signum ---
                Psi = gamma + beta*sign;
                Phi = TA - (abs(Tz)^n)*Psi*Tnu;
                b1  = (1-alpha)*ko*Tz;
                b2  = (1-alpha)*ko*dStrain;
                b3  = dStrain/Teta;
                b4  = -b3*deltaA*b1 - b3*(abs(Tz)^n)*Psi*deltaNu*b1 ...
                    - Phi/(Teta*Teta)*dStrain*deltaEta*b1 + Phi/Teta;
                % --- signum(value) ---
                if Tz > 0
                    sign = 1.0;
                else
                    sign = -1.0;
                end
                % --- end of signum ---
                b5  = 1.0 + b3*deltaA*b2  ...
                    + b3*n*(abs(Tz)^(n-1))*sign*Psi*Tnu ...
                    + b3*(abs(Tz)^n)*Psi*deltaNu*b2 ...
                    + Phi/(Teta*Teta)*dStrain*deltaEta*b2;
                DzDeps = b4/b5;
                Ttangent = alpha*ko + (1-alpha)*ko*DzDeps;
            else
                Ttangent = alpha*ko + (1-alpha)*ko;
            end
        end
        Result = 0;
        
        
        % ======================================================================
    case 'setTrialStress'
        Tstress = edp;
        Result = 0;
        
        % ======================================================================
    case 'getStrain'
        Result = Tstrain;
        
        % ======================================================================
    case 'getStress'
        Result = Tstress;
        
    case 'getFlexibility'
        Result = 1/Ttangent;
        
    case 'getStiffness'
        Result = Ttangent;
        
        % ======================================================================
    case 'getInitialStiffness'
        Result = alpha*ko + (1-alpha)*ko*Ao;
        
        % ======================================================================
    case 'getInitialFlexibility'
        Result = 1/(alpha*ko + (1-alpha)*ko*Ao);
        
        % ======================================================================
    case 'commitState'
        Cstrain = Tstrain;
        Cz = Tz;
        Ce = Te;
        Result = 0;
        
end

% ======================================================================

% Record
MatData(1,1) = tag;      % unique material tag
MatData(1,2) = alpha;
MatData(1,3) = ko;
MatData(1,4) = n;
MatData(1,5) = gamma;
MatData(1,6) = beta;
MatData(1,7) = Ao;
MatData(1,8) = tolerance;
MatData(1,9) = maxNumIter;

MatData(1,10) = deltaA;
MatData(1,11) = deltaNu;
MatData(1,12) = deltaEta;
MatData(1,13) = Tstrain;
MatData(1,14) = Cstrain;
MatData(1,15) = Tz;
MatData(1,16) = Cz;
MatData(1,17) = Te;
MatData(1,18) = Ce;
MatData(1,19) = Tstress;
MatData(1,20) = Ttangent;
end
