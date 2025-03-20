function [s_fRate, b, L] = s_fOptBL(Wn, fn, pos, Pn, sigma2)
% Function name - s_fGetRAte
% Purpose - Compute sum rate for LWA
% Input arguments:
%   Wn - band widths
%   fn - central frequencies
%   pos - user positions
%   Pn - power allocation per band
%   sigma - noise power density
% Output arguments:
%   s_fRate - Rate
%   b, L - LWA parameters


% Grid size
N_b = 10;
N_L = 10;

% set scale bounds:
Lmin=10*10^(-3);
Lmax=50*10^(-3);

bmin=0.9*10^(-3);
bmax=1.1*10^(-3);

%=============  grid search b,L  ================:
%set grid
bs=[bmin:(bmax-bmin)/(N_b-1):bmax]; %meter
Ls=[Lmin:(Lmax-Lmin)/(N_L-1):Lmax];  %meter

%grid_search
b=0;
L=0;
s_fRate=0;
for bi=bs
    for Li=Ls

        hi=calc_channel(pos, Li, bi, fn);  %each row for a single frec
        hi_norm_square=diag(hi*hi');
        sum_rate_i = s_fGetRAte(Wn, hi_norm_square, Pn, sigma2);

        if sum_rate_i>s_fRate
            b=bi;
            L=Li;
            s_fRate=sum_rate_i;

        end
    end


end
end