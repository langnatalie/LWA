function plot_LWA_beampatterns(N_f, fn, pos, Pn, b, L, i_mc, path)
% test for snr_db = 6;
%% setup
% set coordinates
x=0:0.05:20;
y=(0:0.05:20)';

% polar_coordinates:
r=sqrt(x.^2+y.^2);
r(1,1)=1;
phi=atan(x.\y);

LOSS_tot=(r/min(r,[],'all')).^(-2);
LOSS_tot(1,1)=0;

x_users=round(pos(:,1).*cos(pos(:,2)*2*pi/360));
y_users=round(pos(:,1).*sin(pos(:,2)*2*pi/360));

%% channel generation

G_tot=zeros(size(phi));

% if i_mc==1 && paper_flag==1 
%     pos=[10.5424,50.4319;11.7711,15.3170;16.6281,54.4788;13.3083,34.2992];
% end
% if i_mc==2 && paper_flag==1 
%     pos=[11.0571,35.8169;11.4204,12.3435;11.6646,51.9041;16.2096,42.7898];
% end

for i=1:N_f %map rate capabilities 
 G_fi=Pn(i).*(abs(G_f_phi(fn(i),phi,b,L)).^2);
 G_tot=G_tot+G_fi;
end

G_tot=G_tot.*LOSS_tot;

%% plotting
figure;
imagesc(x,y,log(abs(G_tot)))
hold on
plot(x_users,y_users, 'gs','MarkerSize',12,'MarkerEdgeColor','r', 'MarkerFaceColor',[0.5,0.5,0.5])
colorbar
xlabel('x [m]')
ylabel('y [m]') 
legend('User locations')
annotation('textbox', [0.115, 0.82, 0.1, 0.1], 'String', "LWA")
savefig([path,'_i_mc_',num2str(i_mc),'.fig']);
close;
end

