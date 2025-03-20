function [s_fRate, b, L, Pn] = s_fOptOFDM(N_alt, pos, P_tot, N_f, fmin, fmax, sigma2)
% Function name - s_fGetRAte
% Purpose - Compute sum rate for LWA
% Input arguments:
%   pos - user positions
%   P_tot - total power
%   N_f - number of frequency bins
%   sigma - noise power density
% Output arguments:
%   s_fRate - Rate
%   b, L - LWA parameter
%   Pn - power allocation

% band parameters
BW = fmax-fmin;
fn=fmin+BW/(2*N_f):BW/N_f:fmax;
Wn=ones(size(fn))*(BW/N_f);
Wn=Wn';

sum_rates_prog=zeros(1,N_alt);
s_fRate=sum_rates_prog;
% Pn=(P_tot./N_f)*ones(N_f,1);  %initialize for rate calculation
Pn=zeros(N_f,1); 
Pn(1)=P_tot;

for alternate=1:N_alt
    % Tune LWA parameters b and L
    [best_sum_rate, b, L] = s_fOptBL(Wn, fn, pos, Pn, sigma2);
    s_fRate(alternate)=best_sum_rate;


    %=======================  optimize powers  =============================:
    h=calc_channel(pos, L, b, fn);  %each row for a single frec
    h_norm_square=diag(h*h');
    %water fillig
    %[sum_rate, Pn, sum_rate0] = waterFilling(h_norm_square, sigma2, P_tot, Pn);
    [sum_rate, Pn] = modified_BW_waterFilling(h_norm_square, sigma2, P_tot, Wn);
    sum_rates_prog(alternate)=sum_rate;
end

end