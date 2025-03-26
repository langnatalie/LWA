function plot_power_and_channelNorm_OFDMA(BW, N_f, fn, pos, Pn, b, L, indicators, i_mc, path)
    Wn=ones(size(fn))*(BW/N_f)';
    sub_start=fn-(Wn/2);

    h=calc_channel(pos, L, b, fn);  %each row for a single frec
    h_norm_square = abs(h).^2;
    max_norm = max(h_norm_square(:));
    max_P = max(Pn);
    users = size(h,2);

    tiledlayout(2, users, 'TileSpacing', 'Compact', 'Padding', 'Compact')

    for user=1:users
        Pn_user = Pn .* (indicators==user)';
        h_norm_square_user = abs(h(:,user)).^2;

        % First subfigure (Power allocation)
        nexttile(user)
        stairs(sub_start,Pn_user);
        ylim([0, max_P]); % Set Y-axis limits to range from low to high
        title('Power allocation')
        xlabel('f_n');
        ylabel(['P_{n,',num2str(user),'}']);
        
        % Second subfigure (Sub-channel norms)
        nexttile(user+users)
        stairs(sub_start,h_norm_square_user);
        ylim([0, max_norm]); % Set Y-axis limits to range from low to high
        title('Sub-channel norms')
        xlabel('f_n');
        ylabel(['|h_{n,',num2str(user),'}|^2']);
    end
    
    savefig([path,'_i_mc_',num2str(i_mc),'.fig']);
    close;
end