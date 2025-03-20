function plot_OFDM_vs_MIMO(Rates_OFDM_2, Avg_MIMO_rates, Avg_HybMIMO_rates)
figure;
labels_legend=strings(1,length(M_antennas)+2);
SNR_db = -5:5;
markers=["--*","--o","--x","--^","--p", "--.","--","-+","-h"];

% OFDM
plot(SNR_db,Rates_OFDM_2,'-*','LineWidth',1.5)
hold on
labels_legend(1)='LWA OFDM'; 

% MIMO
for m=1:length(M_antennas)
    plot(SNR_db,Avg_MIMO_rates(m,:),markers(m))
    labels_legend(m+1)=strcat('MIMO M=',num2str(M_antennas(m)));
end

% Hybrid MIMO
plot(SNR_db,Avg_HybMIMO_rates(end,:),markers(length(M_antennas)+1))
labels_legend(length(M_antennas)+2)=strcat('Hybrid MIMO M=',num2str(M_antennas(end)));

xlabel('SNR [dB]')
ylabel('Sum-rate [bits/sec]')
legend(labels_legend)
savefig('.\LWA-OFDMvsMIMO.fig')
end

