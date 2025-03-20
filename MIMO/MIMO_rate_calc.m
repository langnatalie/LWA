function [s_fRate,m_fEqCTF] = MIMO_rate_calc(pos_users,num_antennas,frecs,P_tot,sigma2,norm_factor,norm_type)
% Explaining the parameters:
% s_nNt - number of transmit antennas
% s_nNr - number of receivers
% s_nOmegaRes - number of frequency bins 
% m_fEqCTF - this is the channel, its size should be s_nNt x s_nNr x s_nOmegaRes, i.e., the channel in each frequency
% 
% The code essentially finds the noise-to-signal ratio (NSR) in each eigenmode x frequency, and does waterfilling over it (via the function m_fOptPwrAlloc which is enclosed)
% 
% You end up getting the overall rate (in the s_fRate variable).
% 
% The first thing you should do is check if you can get the code running for some random channel.
% Then you should generate a channel corresponding to line-of-sight model, while possibly operating in the radiating near field (which is what we expect to have in THz).
% 
% To get the channel model, use the one described in Section II-B of the paper below:
% https://arxiv.org/pdf/2105.13087.pdf
% 
% Specifically, use a one-dimensional array (N_d = 1) and set the element spacing to be exactly half-wavelength (\lambda / 2).
% 


 
% create channel:
m_fEqCTF = Create_MIMO_channel(pos_users,num_antennas,frecs);
if strcmp(norm_type,'mean')
    m_fEqCTF=m_fEqCTF*norm_factor/mean(abs(m_fEqCTF),'all');
elseif strcmp(norm_type,'max')
    m_fEqCTF=m_fEqCTF*norm_factor/max(abs(m_fEqCTF),[],'all');
end
% compute rate
s_fRate = (frecs(end)-frecs(1))*s_fGetRAteMIMO(m_fEqCTF, P_tot, sigma2);

end