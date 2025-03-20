function h=calc_channel(r_pos, L, b, fn)   %r_pos are the users' positions {(rho_k, \phi_k)}_(k=1)^K
rho_k=r_pos(:,1).';
phi_k=r_pos(:,2).'; %deg

L_fn=prop_loss(fn.',rho_k);
G_fn=G_f_phi(fn.',phi_k*2*pi/360,b,L);
h=G_fn.*L_fn;

end
