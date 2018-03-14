function [M_lr, outcome_regime, Q_to_Qstar] = collision_outcome(R_t, r_p, v, theta, mat, method, dbg)
% Return predicted outcome of collision between gravity-dominated bodies.
%
% NOTE: This function is now obsolete. I will keep it around for a while for
% historical interest but it should not be used to get actual answers until
% further notice. Instead use the new functions disruption_v and disruption_r
% that return a more limited but probably more robust answer.
%
% The outcome of a gravity-regime collision is a complicated function of the
% target radius, projectile-to-target mass ratio, the collision velocity, the
% collision energy, and the impact angle. In a head-on collision, the mass of the
% largest remnant is well approximated by a linear function of specific impact
% energy Q:
%             M_lr = M_t*(1 - 0.5*Q/Q_star)
% with Q_star being the critical energy required to disperse half the total mass. 
% There are a few different conventions of defining Q, in the target frame or the 
% center-of-mass frame, and normalize by the target mass or total mass. In 
% addition, there are a few different scaling laws for the critical disruption 
% energy, including velocity dependent ones. This function aims to provide a 
% convenient wrapper around a few published scaling laws and to let the user 
% obtain predicted outcomes of specific collision scenarios using what I think are
% the most convenient inputs: target and projectile radii, impact velocity and 
% angle, a material and scaling method.
%
%
% Author: Naor Movshovtiz (nmovshov at google dot com)

%% Input parsing
if ~exist('dbg','var'), dbg = true; end
if dbg
   % R_t
   validateattributes(R_t,{'numeric','preal'},{})
   validateattributes(double(R_t),{'double'},{'scalar','finite','positive'})
   % r_p
   validateattributes(r_p,{'numeric','preal'},{})
   validateattributes(double(r_p),{'double'},{'scalar','finite','positive'})
   % v
   validateattributes(v,{'numeric','preal'},{})
   validateattributes(double(v),{'double'},{'scalar','finite','positive'})
   % theta
   validateattributes(theta,{'numeric','preal'},{})
   validateattributes(double(theta),{'double'},{'scalar','finite'})
   assert(theta >=0 && theta < pi/2,'Impact angle must be in [0,pi/2)')
   % mat (either a material tag or bulk density)
   if ~exist('mat','var') || isempty(mat), mat = 'ice'; end
   validateattributes(mat,{'char','numeric','preal'},{'vector'},'','mat',5)
   if ischar(mat)
       assert(strcmpi(mat,'ice') || strcmpi(mat,'rock'),'Supported materials: ice, rock')
   else
       assert(isfinite(double(mat)),'Bulk density must be finite')
       assert(double(mat) > 0,'Bulk density must be positive')
   end
   % method
   if ~exist('method','var') || isempty(method), method = 'MKN14'; end
   validateattributes(method,{'char'},{'vector'},'','method',6)
   assert(strcmpi(method,'MKN14') || strcmpi(method,'LS12'),'Supported methods: MKN14, LS12')
end

%% Function body
% Some prep common to all methods.
si = setUnits;
if ~strcmp(class(R_t),'preal'), si = structfun(@double,si,'uniformoutput',false); end
if ischar(mat)
    if strcmpi(mat,'ice')
        rho = 920*si.kg/si.m^3;
    elseif strcmpi(mat,'rock')
        rho = 5500*si.kg/si.m^3;
    else
        error('Unknown material tag. Use one of: ice, rock')
    end
else
    rho = mat;
end
M_t = 4*pi/3*rho*R_t^3;
m_p = 4*pi/3*rho*r_p^3;
M_tot = M_t + m_p;

% Branch out by method
switch upper(method)
% (1) Energy scaled collision outcome using interacting mass, in target frame.
    case 'MKN14'
        % Calculate Q*D for the target
        if strcmpi(mat,'ice')
            B = 0.05*si.joule/si.kg;
            b = 1.1876;
        elseif strcmpi(mat,'rock')
            B = 1.48*si.joule/si.kg;
            b = 0.9893;
        else
            error('MKN14 scaling expects material tag: [ice | rock]')
        end
        QsD = B*(R_t/si.m)^b;
        
        % Calculate "interacting mass" and effective impact energy (L&S2012 eq. 11)
        el = (R_t + r_p)*(1 - sin(theta));
        al = 1;
        if el < 2*r_p, al = (3*r_p*el^2 - el^3)/(4*r_p^3); end
        m_p = al*m_p;
        q = 0.5*m_p*v^2/M_t;
                
        % Apply M_lr law
        M_lr = max([0, 1 - 0.5*q/QsD])*M_t;
        outcome_regime = {0, 'NA'};
        Q_to_Qstar = q/QsD;
    
% (2) Velocity dependent scaling, in CoM frame. This section follows appendix A.1
%     in Leinhardt & Steweart (2012).
    case 'LS12'
        % Step 1: calculate interacting mass.
        el = (R_t + r_p)*(1 - sin(theta));
        al = 1;
        if el < 2*r_p, al = (3*r_p*el^2 - el^3)/(4*r_p^3); end
        m_inter = m_p*al;
        
        % Step 2: check for perfect merger regime
        M_prime = M_t + m_inter;
        R_prime = (3*M_prime/4/pi/rho)^(1/3); %#ok<NASGU>
        bigG = si.gravity;
        %V_esc_prime = sqrt(2*bigG*M_prime/R_prime); % Leinhardt & Stewart (2012)
        V_esc_prime = sqrt(2*bigG*M_prime/(R_t + r_p)); % Stewart & Leinhardt (2012)
        %V_esc_prime = sqrt(2*bigG*M_tot/(R_t + r_p)); % My intuition
        if v < V_esc_prime
            M_lr = M_tot;
            outcome_regime = {1,'perfect merging'};
            Q_to_Qstar = NaN;
            return;
        end
        
        % Step 3: determine grazing/non-grazing
        if sin(theta) < (R_t/(R_t + r_p))
            isGrazing = false;
        else
            isGrazing = true;
        end
        
        % Step 4: calculate Q'*RD and V'*
        % (4a) calculate Rc1
        rho_1 = 1000*si.kg/si.m^3;
        Rc1 = (3*(M_t + m_p)/4/pi/rho_1)^(1/3);
        
        % (4b) calculate principle disruption value Q*RD,gamma=1 and V*gamma=1
        c_star = 1.9;
        Q_srdge1 = c_star*4/5*pi*rho_1*bigG*Rc1^2;
        %V_sge1 = sqrt(32/5*pi*c_star)*sqrt(rho_1*bigG)*Rc1;
        
        % (4c) calculate reduce mass and reduced interacting mass
        mu = (M_t*m_p)/(M_t + m_p);
        mu_inter = (M_t*m_inter)/(M_t + m_inter);
        Q_R = 0.5*mu*v^2/M_tot;
        
        % (4d) calculate disruption criterion Q*RD and critical velocity V*
        mu_bar = 0.35; % Stewart's web calculator
        %mu_bar = 0.36; % LS12 and SL12
        gamma = m_p/M_t;
        Q_star_RD = Q_srdge1*(0.25*(gamma + 1)^2/gamma)^(2/(3*mu_bar) - 1);
        %V_star = V_sge1*(0.25*(gamma + 1)^2/gamma)^(1/(3*mu_bar));
        
        % (4e) calculate adjusted Q'*RD and V'*
        Q_prime_star_RD = Q_star_RD*(mu/mu_inter)^(2 - 3*mu_bar/2);
        %V_prime_star = sqrt(2*Q_prime_star_RD/mu*M_tot);
        
        % Step 5: calculate Q and V at onset of erosion (M_lr = M_t)
        Q_erosion = 2*Q_prime_star_RD*(1 - M_t/M_tot);
        V_erosion = sqrt(2*Q_erosion*M_tot/mu);
        
        % Step 6: detect hit-and-run
        if (isGrazing && (v < V_erosion))
            M_lr = M_t;
            outcome_regime = {2, 'hit-and-run'};
            Q_to_Qstar = NaN;
            return
        end
        
        % Step 7: calculate Q_R and V for super-catastrphic regime (M_lr = 0.1M_t)
        Q_super_cat = 2*Q_prime_star_RD*(1 - 0.1*M_t/M_tot);
        V_super_cat = sqrt(2*Q_super_cat*M_tot/mu);
        
        % Step 8: detect erosion regime (meaningless?)
        if (v > V_erosion)
            %nothing
        end
        
        % Step 9: detect super-catastrophic regime
        if v > V_super_cat
            eta = -1.5;
            M_lr = M_tot*(0.1/1.8^eta)*(Q_R/Q_prime_star_RD)^eta;
            outcome_regime = {5, 'super-catastrophic'};
            Q_to_Qstar = Q_R/Q_prime_star_RD;
            return
        end
        
        % Step 10: non-grazing collisions
        if (~isGrazing)
            M_lr = M_tot*(1 - 0.5*Q_R/Q_prime_star_RD);
            if (v < V_erosion)
                outcome_regime = {6, 'accretion'};
            else
                outcome_regime = {7, 'disruption'};
            end
            Q_to_Qstar = Q_R/Q_prime_star_RD;
            return
        end
        
        % Step 11: grazing collisions
        if (isGrazing) % Just for symmetry, we know it is...
            M_lr = M_tot*(1 - 0.5*Q_R/Q_prime_star_RD);
            M_lr = min([M_lr M_t]);
            outcome_regime = {7, 'disruption'};
            Q_to_Qstar = Q_R/Q_prime_star_RD;
            return
        end

% (3) Place holder for future methods
    otherwise
        error('nerror:Mlr_method', 'Unknown method. Use one of: MKN14, LS12')
end
return
