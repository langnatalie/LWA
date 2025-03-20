function [Q_sub] = m_fMaGiQ(m_fEqCTF, N_d)
% Function name - m_fMaGiQ
% Purpose - get hybrid beamformer for MIMO channel
% Input arguments:
%   m_fEqCTF - MIMO channel
%   N_d - number of RF chains
% Output arguments:
%   Q_sub - beamforming matrix

% Based on  Shahar Stein Ioushua and Yonina C. Eldar. "A family of hybrid analog–digital beamforming methods for massive MIMO systems." IEEE Transactions on Signal Processing 67.12 (2019): 3243-3257.

% TODO NIR - COMPUT BASED ON THE AVERAGED CHANNEL

[s_nNu, N_t] = size(m_fEqCTF);

% Generate channel in freq domain as one big matrix
m_fGFd = m_fEqCTF';
 
% Obtain optimal (unconstrained) Tx beamformer
[U,D]=eig(m_fGFd*m_fGFd');
[~, I] =sort(real(diag(D)),'descend'); %eigen values
Q_opt=U(:,I(1:N_d)); %take the first N_d eigen vectors 
% Approximate with phase shifters using MaGiQ algorithm

N_iter = 20;

Uk = eye(N_t);
Dk = eye(N_t);


for i=1:N_iter
    % Find optimal Q for fixed D and U
    Q_sub = Uk*Dk*Q_opt; 

    % Project as phase shifters
    Q_sub = exp(1j*angle(Q_sub));

    % Find optimal U for fixed D and Q
    [U,~,V]=svd(Q_sub*(Dk*Q_opt)');
    Uk=U*V';


end