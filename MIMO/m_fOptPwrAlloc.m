function [m_fPower, s_fDelta] = m_fOptPwrAlloc(m_fNSR, s_nRho)
% Function name - m_fOptPwrAlloc
% Purpose - Generate optimal power allocation solution
% Input arguments:
%   m_fNSR - NSR matrix (time x frequency)
%   s_nRho - Average power constraint
% Output arguments:
%   m_fPower - Power allocation map
%   s_fDelta - Waterfilling threshold


    % Iteratively find parameter Delta
    while (1)
        % Set Delta to sum of all NSRs of active tones
        s_fDelta = (s_nRho + sum(sum(m_fNSR))) /sum(sum(double(m_fNSR~= 0))) ;
        % Obtain power allocation for active tone
        m_fPower = double(m_fNSR ~= 0) .* (s_fDelta - m_fNSR);
       % If power allocated is valid - optimal solution found
        if (min(min(m_fPower)) >= 0)  break;  end
        % If negative power allocated - deactivate minimal tone and repeat
        m_fNSR = (m_fPower ~= min(min(m_fPower))) .* m_fNSR;   
    end
end