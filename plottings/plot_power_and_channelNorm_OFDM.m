function plot_power_and_channelNorm_OFDM(BW, N_f, fn, pos, Pn, b, L, i_mc, path)
    Wn=ones(size(fn))*(BW/N_f);
    sub_start=fn-(Wn/2);

    h=calc_channel(pos, L, b, fn);  %each row for a single frec
    h_norm_square=vecnorm(h,2,2).^2;

    figure;
    subplot(2,1,1);
    stairs(sub_start,Pn);
    title('Power allocation')
    xlabel('f_n');
    ylabel('P_{n}');
        
    subplot(2,1,2);
    stairs(sub_start,h_norm_square);
    title('Sub-channel norms')
    xlabel('f_n');
    ylabel('||h_{n,:}||^2');
    savefig([path,'_i_mc_',num2str(i_mc),'.fig']);
    close;