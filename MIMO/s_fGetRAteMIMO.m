function [s_fRate] = s_fGetRAteMIMO(m_fEqCTF, P_tot, sigma2)
% Function name - s_fGetRAteMIMO
% Purpose - Compute sum rate for MIMO OFDM channel
% Input arguments:
%   m_fEqCTF - MIMO channel 
%   P_tot - power budget
%   sigma - noise power density
% Output arguments:
%   s_fRate - Rate


[s_nNr, s_nNt, s_nOmegaRes] = size(m_fEqCTF);

% Find power allocation for each omega
m_fNSR = zeros(s_nOmegaRes,  min(s_nNt, s_nNr));
m_fV_om = zeros( s_nNt,  s_nNt, s_nOmegaRes);
for ww=1:s_nOmegaRes
    % Obtain singular value decomposition of the channel at omega
    [m_fU,m_fGamma,m_fV] = svd(m_fEqCTF(:,:,ww));
    % Obtain inverse of squared singular values vector
    v_fNSR = diag(m_fGamma).^2;
    v_fNSR(find(v_fNSR)) = v_fNSR(find(v_fNSR)).^(-1);  
    m_fNSR(ww,:) = v_fNSR;
    % save matrix V
    m_fV_om(:, :, ww) = m_fV;
end
% Obtain power allocation matrix (time x frequency) - unit energy. divide rho
% by integration spacing to approximate integration by sum


% [m_fPower, s_fDelta] = m_fOptPwrAlloc(m_fNSR',  s_nOmegaRes );

%----------------TRY TO FIX DIMANTION PROBLEM---------------
[m_fPower, ~] = m_fOptPwrAlloc((m_fNSR.*sigma2)', P_tot );
if size(m_fPower,1)<s_nNt
    m_fPower=[m_fPower;zeros((s_nNt-size(m_fPower,1)),s_nOmegaRes)];
end


%-----------------------------------------------------------


% Get rate using integral
 v_fIntegrand = zeros(1, s_nOmegaRes);

 for ww=1:s_nOmegaRes
     % Generate composite white channel for given frequency omega
     m_fGw = m_fEqCTF(:,:,ww);
     % Obtain beamforming matrix
     m_fSxx_omega = m_fV_om(:, :, ww) * diag(m_fPower(:,ww)) *  m_fV_om(:, :, ww)';
     % Evaluate integrand for given omega
     temp=det(eye(s_nNr) + m_fGw *  m_fSxx_omega * m_fGw'./sigma2);
     v_fIntegrand(ww) = log2(temp);
 end
% Derive maximum achievable rate
s_fRate= abs((sum(v_fIntegrand) / s_nOmegaRes) ); 

end