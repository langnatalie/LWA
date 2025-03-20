function [s_fRate] = s_fGetRAte(Wn, hns_norm, Pn, sigma)
% Function name - s_fGetRAte
% Purpose - Compute sum rate for LWA
% Input arguments:
%   Wn - band widths
%   hns_norm - channel norms per band
%   Pn - power allocation per band
%   sigma - noise power density
% Output arguments:
%   s_fRate - Rate


%==============Normalize channel ========================
Avg_BW = mean(Wn);
hns_norm = hns_norm./(Wn/Avg_BW);
%=======================================================

s_fRate = sum(Wn.*log2(1 + Pn.*hns_norm / sigma));

end