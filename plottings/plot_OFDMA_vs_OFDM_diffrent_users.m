function plot_OFDMA_vs_OFDM_diffrent_users(Rates_OFDM_4, Rates_OFDMA_4, ...
                            Rates_OFDM_8, Rates_OFDMA_8, ...
                            Rates_OFDM_16, Rates_OFDMA_16)
figure;
labels_legend=strings(1,6);
SNR_db=-5:5;

%%%%%%% N_r = 4
plot(SNR_db,Rates_OFDM_4,'-*','LineWidth',1.5)
hold on
labels_legend(1)='LWA OFDM K=4'; 

plot(SNR_db,Rates_OFDMA_4,'-|','LineWidth',1.5)
labels_legend(2)='LWA OFDMA K=4'; 


%%%%%% N_r = 8
plot(SNR_db,Rates_OFDM_8,'--*','LineWidth',1.5)
hold on
labels_legend(3)='LWA OFDM K=8'; 

plot(SNR_db,Rates_OFDMA_8,'--o','LineWidth',1.5)
labels_legend(4)='LWA OFDMA K=8'; 

% %%%%%%% N_r = 16
plot(SNR_db,Rates_OFDM_16,'--x','LineWidth',1.5)
hold on
labels_legend(5)='LWA OFDM K=16'; 

plot(SNR_db,Rates_OFDMA_16,'--^','LineWidth',1.5)
labels_legend(6)='LWA OFDMA K=16'; 


xlabel('SNR [dB]')
ylabel('Sum-rate [bits/sec]')
legend(labels_legend)
savefig('\LWA-OFDMvsLWA-OFDMA_different_users.fig');

% exportgraphics(gca, 'ofdm.pdf', 'ContentType', 'vector', 'BackgroundColor', 'none')
end

