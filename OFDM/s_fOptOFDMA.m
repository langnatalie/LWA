function [s_fRate, b, L, Pn, indicators] = s_fOptOFDMA(N_alt, pos, P_tot, N_f, fmin, fmax, sigma2)
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

s_fRate=zeros(1,N_alt);

%initialize for rate calculation
% Pn=(P_tot./N_f)*ones(N_f,1);  
Pn=zeros(N_f,1); 
Pn(1)=P_tot;

%initialize for indicators
num_users=length(pos);
indicators=randi([1 num_users], [1, N_f]);
% indicators=ones([1, N_f]);

for alternate=1:N_alt
    % Tune LWA parameters b and L
    [~, b, L] = modified_indicators_s_fOptBL(Wn, fn, pos, Pn, sigma2, indicators);    

    %=======================  optimize powers  =============================:
    h=calc_channel(pos, L, b, fn);  %each row for a single frec
    %water fillig
    hnk = convert_to_hnk(h,indicators);
    h_norm_square = abs(hnk).^2;
    [~, Pn] = modified_BW_waterFilling(h_norm_square, sigma2, P_tot, Wn);

    %=======================  optimize indicators via genetic algorithm  =============================:
    [indicators, sum_rate] = genetic_algorithm(N_f, Wn, Pn, h, sigma2, num_users);

    s_fRate(alternate)=-sum_rate; % Flip sign back
end

end