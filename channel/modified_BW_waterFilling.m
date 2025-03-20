%=============================Fixed====================================
function [sum_rate, Pn] = modified_BW_waterFilling(hns_norm2, sigma, P, Wn) % Wn are the respective bandwidths of fn
    numSubchannels = length(hns_norm2);   
    sigma_tilde=sigma./hns_norm2;
    
    % Sort the channel gains in descending order
    %[sorted_sigmas,indices] = sort(sigma_tilde, 'descend');
    nonzero_indices=1:numSubchannels;
    indices=nonzero_indices;
    % Initialize water levels
    Pn = zeros(numSubchannels, 1);
    flag=1;
    % Perform water-filling algorithm
    while flag
        % Compute the threshold for this subchannel
        threshold = (P+sum(sigma_tilde(indices)))/sum(Wn(indices));
        Pn(indices)=threshold.*Wn(indices)-sigma_tilde(indices); 
        [Pn_min,idx_min]=min(Pn);
        if Pn_min<0
            Pn(idx_min)=0;
            nonzero_indices(idx_min)=0;
            indices=nonzero_indices(nonzero_indices~=0);
        else
            flag=0;
        end
    end
    sum_rate = s_fGetRAte(Wn, hns_norm2, Pn, sigma); 
end