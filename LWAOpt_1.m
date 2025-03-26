% Comparing rates between LWA and MIMO
clear all;
close all;
clc;

rng(1); %set seed

%% Paramters Initialization

% Bandwidth parameters
fmax=800*10^9;
fmin=200*10^9;
BW=fmax-fmin;
N_f=128; % number of frequency bands
d=BW/10;  %max sub-band constraint

fn=(fmin+0.5*(BW/N_f)):(BW/N_f):fmax; % uniform division

% Transmission power 
P_tot = 10;
SNR_db = -5:5; % used for sum-rate calculations
% SNR_db = 6; % used for all other plots than sum-rate calculations

%  LWA slit parameter ranges
Lmin=10*10^(-3);
Lmax=30*10^(-3); % before it was 50*10^(-3)
bmin=0.9*10^(-3);
bmax=1.1*10^(-3);

% Number of Monte Carlo trials
N_MC=30;

% Number of receivers 
N_r=4;

% Number of alternating optimization rounds
% For OFDM: N_r=4/16 + N_alt=2
N_alt=2; 

% For OFDMA: N_r=4 + N_alt=5 / N_r=16 + N_alt=10  
if N_r == 4 
    N_alt_OFDMA = 5;
else
    N_alt_OFDMA = 10;
end

%% benchmarks
    
% Which benchmarks to run
v_nCurves                 = [...          
    1 ...           % LWA + OFDM    
    1 ...           % LWA + OFDMA    
    0 ...           % MIMO
    ];
rates_per_iterOFDM=zeros(N_MC,N_alt,length(SNR_db)); 
rates_per_iterOFDMA=zeros(N_MC,N_alt_OFDMA,length(SNR_db)); 
M_antennas=[2,4,8];
MIMO_rates=zeros(N_MC,length(M_antennas),length(SNR_db));
HybMIMO_rates=zeros(N_MC,length(M_antennas),length(SNR_db));
%% Generate user positions
% set user locations parameters:
phi_max=55;  %deg
phi_min=10;

rho=10;

pos_MC=zeros([N_MC,N_r,2]);
pos_MC(:,:,1)=rho*rand([N_MC,N_r,1])+rho;
pos_MC(:,:,2)=(phi_max-phi_min)*rand([N_MC,N_r,1]) + phi_min;  %deg

%% Main simulation
% Loop over channel realizations
for i_mc=1:N_MC
    i_mc
    tic;
    %set user locations:
    pos=zeros([N_r,2]);
    pos(:,1)=pos_MC(i_mc,:,1);
    pos(:,2)=pos_MC(i_mc,:,2);  %deg
    
    % LWA slit defaults    
    L=(Lmin+Lmax)/2;
    b=(bmin+bmax)/2;
    % Get reference channel power 
    h=calc_channel(pos, L, b, fn);
    norm_type='max'; 
    h_max_val=max(h,[],'all');

    % Loop over SNR levels (SNR=P/sigma2)
    for snr_db=1:length(SNR_db)
        sigma2=(P_tot/N_f)*10^(-SNR_db(snr_db)/10);
        
        % LWA + OFDM simulation
        if (v_nCurves(1) == 1)               
            [sum_rate_OFDM, b, L, Pn] = s_fOptOFDM(N_alt, pos, P_tot, N_f, fmin, fmax, sigma2);
           
            rates_per_iterOFDM(i_mc,:,snr_db)=sum_rate_OFDM;  
            % path = '.\Results\Natalie results\power and channel norm 4 users\OFDM\all simulations\';
            % plot_LWA_beampatterns(N_f, fn, pos, Pn, b, L, i_mc, path);
            % plot_power_and_channelNorm_OFDM(BW, N_f, fn, pos, Pn, b, L, i_mc, path);
        end     

        %LWA + OFDMA simulation
        if (v_nCurves(2) == 1)    
            [sum_rate_OFDMA, b, L, Pn, indicators] = s_fOptOFDMA(N_alt_OFDMA, pos, P_tot, N_f, fmin, fmax, sigma2);

            rates_per_iterOFDMA(i_mc,:,snr_db)=sum_rate_OFDMA;       
            % path = '..\Natalie results\power and channel norm 4 users\OFDMA\G=Lsinc[...] small range L SNR=6\all simulations\';
            % plot_power_and_channelNorm_OFDMA(BW, N_f, fn, pos, Pn, b, L, indicators, i_mc, path);
            % plot_LWA_beampatterns(N_f, fn, pos, Pn, b, L, i_mc, path);            
        end        
                
        % MIMO benchmarks
        if (v_nCurves(3) == 1)
            for M_idx=1:length(M_antennas) 
                % compute rate with fully digital MIMO
                [s_fRateMIMO,H_MIMO] = MIMO_rate_calc(pos, M_antennas(M_idx), fn, P_tot, sigma2, h_max_val, norm_type);           
                MIMO_rates(i_mc,M_idx,snr_db)=s_fRateMIMO;               
            end 
            % compute rate with hybrid MIMO with 1 RF chain for max antennas
            [s_fRateHyb] = s_fHybMIMO(H_MIMO,  P_tot,  fmin, fmax, sigma2);
            HybMIMO_rates(i_mc,M_idx,snr_db)=s_fRateHyb;
        end    
    end 
    toc;
end

%% save content for later plotting
% LWA + OFDM simulation
if (v_nCurves(1) == 1)     
    % Overall rates LWA + OFDM
    Avg_rates_per_iter_OFDM=squeeze(mean(abs(rates_per_iterOFDM),1));
    Rates_OFDM_2=Avg_rates_per_iter_OFDM(end,:);
    save(['.\LWA-OFDM_',num2str(N_r),'users.mat'], 'Rates_OFDM_2');
end

% LWA + OFDMA simulation
if (v_nCurves(2) == 1)     
    % Overall rates LWA + OFDMA
    Avg_rates_per_iter_OFDMA=squeeze(mean(abs(rates_per_iterOFDMA),1));
    Rates_OFDMA_2=Avg_rates_per_iter_OFDMA(end,:);
    save(['.\LWA-OFDMA_',num2str(N_r),'users.mat'], 'Rates_OFDMA_2');
end

% MIMO benchmarks
if (v_nCurves(3) == 1)
    % Overall rates MIMO
    Avg_MIMO_rates=squeeze(mean(abs(MIMO_rates),1));
    Avg_HybMIMO_rates=squeeze(mean(abs(HybMIMO_rates),1));
    save(['.\MIMO_',num2str(N_r),'users.mat'], 'Avg_MIMO_rates');
    save(['.\HybMIMO_',num2str(N_r),'users.mat'], 'Avg_HybMIMO_rates');
end