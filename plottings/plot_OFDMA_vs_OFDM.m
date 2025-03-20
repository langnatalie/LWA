function plot_OFDMA_vs_OFDM(Rates_OFDM, Rates_OFDMA)
figure;
labels_legend=strings(1,2);
SNR_db = -5:5;

plot(SNR_db,Rates_OFDM,'-*','LineWidth',1.5)
hold on
labels_legend(1)='LWA OFDM'; 

plot(SNR_db,Rates_OFDMA,'-|','LineWidth',1.5)
labels_legend(2)='LWA OFDMA'; 

xlabel('SNR [dB]')
ylabel('Sum-rate [bits/sec]')
legend(labels_legend)
savefig('LWA-OFDMvsLWA-OFDMA.fig')
end

