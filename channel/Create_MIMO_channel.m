function [H]=Create_MIMO_channel(user_pos,num_antennas,frecs)

    n_users = length(user_pos(:,1));
    H=zeros(n_users,num_antennas,length(frecs));
    
    lambda_fs=3*10^(8)./frecs;
    lambda=mean(lambda_fs);
    
    antenna_xs=[0:1:num_antennas-1]*lambda; %row vector
    x_users=(user_pos(:,1).*cos(user_pos(:,2)*2*pi/360)); % col vector
    y_users=(user_pos(:,1).*sin(user_pos(:,2)*2*pi/360));
    
    for uu=1:n_users
        p_user = [x_users(uu), y_users(uu)];
        for nn=1:num_antennas
            p_ant = [antenna_xs(nn), 0];
            dist = norm(p_user-p_ant);
            theta = angle((p_user(1)-p_ant(1)) +1j*p_user(2)); % relative angle
            F_theta=6*((cos(theta))^2); % Boresight gain = 2 (dipole) 
            for f=1:length(frecs) 
                Akm = (sqrt(F_theta)*lambda_fs(f)/(4*pi*dist));
                H(uu,nn,f)=Akm*exp(-1i*dist*(2*pi/lambda_fs(f)));
            end
        end
      %   H_norms(f)=norm(H(:,:,f),'fro');
    end
    

    
    %H_mean_norm=mean(H_norms);
    H_mean_norm=mean(abs(H),'all');
    %H_mean_norm=max(abs(H),[],'all');
    H=H/H_mean_norm;



end