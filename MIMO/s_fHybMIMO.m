function [s_fRate] = s_fHybMIMO(m_fEqCTF, P_tot,  fmin, fmax, sigma2)
% Function name - s_fGetRAte
% Purpose - Compute sum rate for LWA
% Input arguments:
%   m_fEqCTF - MIMO channel, its size should be s_nNt x s_nNu x s_nOmegaRes, i.e., the channel in each frequency
%   P_tot - total power
%   N_d - number of RF chains
%   sigma - noise power density
% Output arguments:
%   s_fRate - Rate


[~, N_u, N_f] = size(m_fEqCTF);
BW = fmax- fmin;
% compute beamform matrix of average channel with a a single RF chain
[Q_sub] = m_fMaGiQ(mean(m_fEqCTF,3), 1)/sqrt(N_u);
% apply beamformer
m_fHybCTF=squeeze(pagemtimes(m_fEqCTF,Q_sub))';


% compute rate
Wn=ones(1,N_f)*(BW/N_f);
Wn=Wn';

h_norm_square=diag(m_fHybCTF*m_fHybCTF');
%water fillig
[s_fRate, ~] = modified_BW_waterFilling(h_norm_square, sigma2, P_tot, Wn); 
 